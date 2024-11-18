data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "artifact" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "allow" {
  bucket = aws_s3_bucket.artifact.id
  policy = data.aws_iam_policy_document.allow_rules.json

}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.artifact.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.artifact.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "allow_rules" {
  statement {
    sid = "codedeployS3Policy1"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
    actions   = ["s3:PutObject"]
    resources = [aws_s3_bucket.artifact.arn, "${aws_s3_bucket.artifact.arn}/*"]

  }
  statement {
     sid = "codedeployS3Policy2"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:role/${var.iam-instance-role}"]
    }
    actions   = ["s3:Get*", "s3:List*"]
    resources = [aws_s3_bucket.artifact.arn, "${aws_s3_bucket.artifact.arn}/*"]

  }
}
