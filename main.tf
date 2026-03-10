resource "aws_iam_role" "nidramathu_role" {
  name = "nidramathuReadRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = var.platform_account
      }
      Action = "sts:AssumeRole"
      Condition = {
        StringEquals = {
          "sts:ExternalId" = var.external_id
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = aws_iam_role.nidramathu_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
