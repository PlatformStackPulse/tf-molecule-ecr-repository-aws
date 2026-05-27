output "enabled" {
  description = "Whether enabled"
  value       = local.enabled
}

output "repository_url" {
  description = "ECR repository URL"
  value       = module.repository.repository_url
}

output "repository_arn" {
  description = "ECR repository ARN"
  value       = module.repository.arn
}

output "repository_name" {
  description = "ECR repository name"
  value       = module.this.id
}
