resource "aws_s3_bucket" "bucket" {
  bucket = "prrtprrt-$YOURNAME"
  acl    = "private"

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.mykey.arn
      }
    }
  }
}

resource "aws_kms_key" "mykey" {
  description             = "KMS key for S3 bucket prrtprrt-$YOURNAME"
  deletion_window_in_days = 7

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement = [
      {
        Sid    = "Allow administration of the key",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "kms:*",
        Resource = "*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "aws_kms_alias" "mykey-alias" {
  name          = "alias/prrtprrt-$YOURNAME"
  target_key_id = aws_kms_key.mykey.key_id
}
