# Molecule: ECR Repository with lifecycle policy
module "repository" {
  source  = "git::https://github.com/PlatformStackPulse/tf-atom-ecr-repository-aws.git?ref=472c7c3f2bbd821cd631a3f19ed084380f2612af"
  context = module.this.context

  image_tag_mutability = var.image_tag_mutability
  scan_on_push         = var.scan_on_push
}

module "lifecycle_policy" {
  source  = "git::https://github.com/PlatformStackPulse/tf-atom-ecr-lifecycle-policy-aws.git?ref=2939f8e66a85cd201d35947eea61285ce2070015"
  context = module.this.context

  repository_name = module.this.id
  policy = var.lifecycle_policy != null ? var.lifecycle_policy : jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last ${var.max_image_count} images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = var.max_image_count
      }
      action = { type = "expire" }
    }]
  })

  depends_on = [module.repository]
}
