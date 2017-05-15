/**
 * S3
 * -------------------------------------------------------------------------------------------------------------------
 */

resource "aws_s3_bucket" "aws_s3_website" {
  bucket = "${var.bucket_name}"
  acl    = "public-read"
  policy = "${data.aws_iam_policy_document.aws_s3_website.json}"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

data "aws_iam_policy_document" "aws_s3_website" {
  statement {
    sid = "PublicReadGetObject"
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    principals {
      identifiers = ["*"]
      type = "*"
    }
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }
}
