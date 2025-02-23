resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "tsar-terraform-state"
}

resource "aws_s3_bucket_versioning" "versioning_tfstate" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
