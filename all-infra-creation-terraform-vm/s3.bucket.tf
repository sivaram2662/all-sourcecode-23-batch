resource "aws_s3_bucket" "tfstatefile" {
  bucket = "aws-artifactory-devops-name"

  tags = {
    Name        = "aws-artifactory-devops-name"
    Environment = "Dev"
  }
}