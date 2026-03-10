# ═══════════════════════════════════════════════════════════════
#  FinOps Platform — nidramathu
#  Provider: AWS | Environment: dev
# ═══════════════════════════════════════════════════════════════

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Platform    = "nidramathu"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "FinOps-Team"
    }
  }
}


# ───────────────────────────────────────────────────────────────
# 1. S3 BUCKETS
# ───────────────────────────────────────────────────────────────

# Primary data bucket for FinOps reports & exports
resource "aws_s3_bucket" "finops_data" {
  bucket = "${var.project}-finops-data-${var.environment}"
}

resource "aws_s3_bucket_versioning" "finops_data" {
  bucket = aws_s3_bucket.finops_data.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "finops_data" {
  bucket = aws_s3_bucket.finops_data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "finops_data" {
  bucket                  = aws_s3_bucket.finops_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle: move to IA after 30 days, Glacier after 90, expire after 365
resource "aws_s3_bucket_lifecycle_configuration" "finops_data" {
  bucket = aws_s3_bucket.finops_data.id
  rule {
    id     = "cost-optimize-storage"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    expiration {
      days = 365
    }
  }
}

# Lambda deployment artifacts bucket
resource "aws_s3_bucket" "lambda_artifacts" {
  bucket = "${var.project}-lambda-artifacts-${var.environment}"
}

resource "aws_s3_bucket_public_access_block" "lambda_artifacts" {
  bucket                  = aws_s3_bucket.lambda_artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# ───────────────────────────────────────────────────────────────
# 2. IAM ROLES & POLICIES
# ───────────────────────────────────────────────────────────────

# --- Lambda Execution Role ---
resource "aws_iam_role" "lambda_exec" {
  name = "${var.project}-lambda-exec-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_finops" {
  name        = "${var.project}-lambda-finops-policy-${var.environment}"
  description = "Grants Lambda access to S3, RDS, and Cost Explorer for nidramathu"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
        Resource = [
          aws_s3_bucket.finops_data.arn,
          "${aws_s3_bucket.finops_data.arn}/*"
        ]
      },
      {
        Sid    = "CostExplorerReadOnly"
        Effect = "Allow"
        Action = ["ce:GetCostAndUsage", "ce:GetCostForecast", "ce:GetReservationUtilization"]
        Resource = "*"
      },
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_finops_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_finops.arn
}

# --- RDS Monitoring Role ---
resource "aws_iam_role" "rds_monitoring" {
  name = "${var.project}-rds-monitoring-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "monitoring.rds.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


# ───────────────────────────────────────────────────────────────
# 3. RDS DATABASE
# ───────────────────────────────────────────────────────────────

resource "aws_db_subnet_group" "nidramathu" {
  name       = "${var.project}-db-subnet-${var.environment}"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "rds" {
  name        = "${var.project}-rds-sg-${var.environment}"
  description = "Allow internal access to RDS for nidramathu"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "nidramathu" {
  identifier             = "${var.project}-db-${var.environment}"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_encrypted      = true
  db_name                = "nidramathu"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.nidramathu.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  deletion_protection    = false
  monitoring_interval    = 60
  monitoring_role_arn    = aws_iam_role.rds_monitoring.arn
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  tags = { Name = "${var.project}-db-${var.environment}" }
}


# ───────────────────────────────────────────────────────────────
# 4. LAMBDA FUNCTIONS
# ───────────────────────────────────────────────────────────────

# Package placeholder — replace with actual zip or S3 key
data "archive_file" "cost_reporter" {
  type        = "zip"
  output_path = "${path.module}/lambda/cost_reporter.zip"
  source {
    content  = "def handler(event, context): return {'statusCode': 200}"
    filename = "handler.py"
  }
}

resource "aws_lambda_function" "cost_reporter" {
  function_name    = "${var.project}-cost-reporter-${var.environment}"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "handler.handler"
  runtime          = "python3.12"
  filename         = data.archive_file.cost_reporter.output_path
  source_code_hash = data.archive_file.cost_reporter.output_base64sha256
  timeout          = 300
  memory_size      = 256

  environment {
    variables = {
      ENVIRONMENT     = var.environment
      S3_BUCKET       = aws_s3_bucket.finops_data.bucket
      DB_HOST         = aws_db_instance.nidramathu.address
      DB_NAME         = "nidramathu"
    }
  }
}

# Scheduled trigger — runs daily at 06:00 UTC
resource "aws_cloudwatch_event_rule" "daily_cost_report" {
  name                = "${var.project}-daily-cost-report-${var.environment}"
  schedule_expression = "cron(0 6 * * ? *)"
}

resource "aws_cloudwatch_event_target" "cost_reporter_target" {
  rule      = aws_cloudwatch_event_rule.daily_cost_report.name
  target_id = "CostReporterLambda"
  arn       = aws_lambda_function.cost_reporter.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cost_reporter.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_cost_report.arn
}


# ───────────────────────────────────────────────────────────────
# 5. COST & BUDGET ALERTS
# ───────────────────────────────────────────────────────────────

resource "aws_budgets_budget" "monthly_cost" {
  name         = "${var.project}-monthly-budget-${var.environment}"
  budget_type  = "COST"
  limit_amount = var.monthly_budget_limit
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.alert_emails
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.alert_emails
  }
}

resource "aws_sns_topic" "finops_alerts" {
  name = "${var.project}-alerts-${var.environment}"
}

resource "aws_sns_topic_subscription" "email_alert" {
  count     = length(var.alert_emails)
  topic_arn = aws_sns_topic.finops_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_emails[count.index]
}


# ───────────────────────────────────────────────────────────────
# 6. CLOUDWATCH MONITORING & DASHBOARDS
# ───────────────────────────────────────────────────────────────

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.cost_reporter.function_name}"
  retention_in_days = 30
}

# Lambda Error Alarm
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.project}-lambda-errors-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Triggers when cost-reporter Lambda throws errors"
  alarm_actions       = [aws_sns_topic.finops_alerts.arn]
  dimensions = {
    FunctionName = aws_lambda_function.cost_reporter.function_name
  }
}

# RDS CPU Alarm
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.project}-rds-cpu-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "RDS CPU utilization above 80%"
  alarm_actions       = [aws_sns_topic.finops_alerts.arn]
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.nidramathu.identifier
  }
}

# FinOps Dashboard
resource "aws_cloudwatch_dashboard" "nidramathu" {
  dashboard_name = "${var.project}-dashboard-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          title  = "Lambda Invocations & Errors"
          period = 300
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.cost_reporter.function_name],
            ["AWS/Lambda", "Errors", "FunctionName", aws_lambda_function.cost_reporter.function_name]
          ]
        }
      },
      {
        type = "metric"
        properties = {
          title  = "RDS CPU Utilization"
          period = 300
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.nidramathu.identifier]
          ]
        }
      },
      {
        type = "metric"
        properties = {
          title  = "S3 Bucket Size"
          period = 86400
          metrics = [
            ["AWS/S3", "BucketSizeBytes", "BucketName", aws_s3_bucket.finops_data.bucket, "StorageType", "StandardStorage"]
          ]
        }
      }
    ]
  })
}
