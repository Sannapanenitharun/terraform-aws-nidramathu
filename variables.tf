# ═══════════════════════════════════════════════════════════════
#  variables.tf — nidramathu FinOps Platform
# ═══════════════════════════════════════════════════════════════

variable "project" {
  description = "Project / platform name used as a prefix for all resources"
  type        = string
  default     = "nidramathu"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# ── Networking ──────────────────────────────────────────────────
variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC (used for RDS security group ingress)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS subnet group"
  type        = list(string)
}

# ── Database ────────────────────────────────────────────────────
variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

# ── Budget & Alerts ─────────────────────────────────────────────
variable "monthly_budget_limit" {
  description = "Monthly AWS cost budget limit in USD"
  type        = string
  default     = "500"
}

variable "alert_emails" {
  description = "List of email addresses to receive budget and alarm alerts"
  type        = list(string)
  default     = ["finops-team@example.com"]
}
