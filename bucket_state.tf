
# bucket to store state for the app infra
resource "aws_kms_key" "terraform_state_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "sparrow-simpleproject-terraform-states" # Enable versioning so we can see the full revision history of our

  tags = {
    Name = "sparrow-simpleproject-terraform-states"
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_conf" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_state_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "sparrow-simpleproject-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}