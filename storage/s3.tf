# Used for global resource naming
resource "random_id" "bucket-suffix" {
  byte_length = 8
}

# Main logging bucket for all applications
resource "aws_s3_bucket" "log-bucket" {
  bucket = "log-bucket-${random_id.bucket-suffix.hex}"
}

# Our main webapp bucket
resource "aws_s3_bucket" "webapp" {
  bucket = "webapp-bucket-${random_id.bucket-suffix.hex}"
  acl    = "private"
  policy = file("storage/bucketpolicy.json")

  # Enable SSE
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  # Enable server access logging to our log_bucket
  logging {
    target_bucket = aws_s3_bucket.log-bucket.id
    target_prefix = "webapplog/"
  }

  tags = {
    Name        = "webapp"
    Environment = "test"
  }
}

# Ensure Object Ownership is setup properly on webapp bucket 
resource "aws_s3_bucket_ownership_controls" "webapp" {
  bucket = aws_s3_bucket.webapp.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Ensure Object Ownership is setup properly on logging bucket 
resource "aws_s3_bucket_ownership_controls" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.id 

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Ensure Public Access Block is enabled 
resource "aws_s3_bucket_public_access_block" "webapp" {
  bucket = aws_s3_bucket.webapp.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Ensure Public Access Block is enabled 
resource "aws_s3_bucket_public_access_block" "log-bucket" {
  bucket = aws_s3_bucket.log-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}