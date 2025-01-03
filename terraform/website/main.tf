module "s3" {
  source = "github.com/sahilphule/templates/terraform/modules/aws/s3"
  # source = "../../../../templates/terraform/modules/aws/s3"

  s3-bucket-properties = local.s3-bucket-properties
}

resource "aws_s3_bucket_policy" "s3-bucket-policy" {
  bucket = local.s3-bucket-id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : ["s3:GetObject"],
        "Resource" : "arn:aws:s3:::${local.s3-bucket-properties.s3-bucket-name}/*"
      }
    ]
  })

  depends_on = [
    module.s3
  ]
}

resource "aws_s3_bucket_website_configuration" "static" {
  bucket = local.s3-bucket-id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

module "cloudfront" {
  source = "github.com/sahilphule/templates/terraform/modules/aws/cloudfront"
  # source = "../../../../templates/terraform/modules/aws/cloudfront"

  cloudfront-properties          = local.cloudfront-properties
  s3-bucket-regional-domain-name = local.s3-bucket-regional-domain-name
  acm-certificate-arn            = local.acm-certificate-arn

  depends_on = [
    module.s3
  ]
}

module "route53-record" {
  source = "github.com/sahilphule/templates/terraform/modules/aws/route53-record"
  # source = "../../../../templates/terraform/modules/aws/route53-record"

  route53-record-properties = local.route53-record-properties
  route53-zone-id           = local.route53-zone-id

  depends_on = [
    module.cloudfront
  ]
}