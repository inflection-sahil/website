output "cloudfront-distribution-domain-name" {
  description = "cloudfront distribution domain name"
  value       = module.cloudfront.cloudfront-distribution-domain-name
}

output "cloudfront-distribution-hosted-zone-id" {
  description = "cloudfront distribution hosted zone id"
  value       = module.cloudfront.cloudfront-distribution-hosted-zone-id
}