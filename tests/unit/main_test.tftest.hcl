# Unit Tests for tf-molecule-ecr-repository-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:   terraform test -test-directory=tests/unit
# Verbose:    terraform test -test-directory=tests/unit -verbose
#
# Assertions are limited to plan-KNOWN values (the tf-label id string,
# input pass-throughs, and the enabled flag). Computed attributes such as
# the repository ARN/URL are unknown under a mock provider and are not
# asserted on.

mock_provider "aws" {}

variables {
  # tf-label context inputs — form the resource id "eg-test-thing"
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module-specific inputs (valid sample values)
  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true
  max_image_count      = 10
  lifecycle_policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "expire untagged"
      selection = {
        tagStatus   = "untagged"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = 14
      }
      action = { type = "expire" }
    }]
  })
}

# ---------------------------------------------------------------------------
# Test: module is enabled and derives the expected tf-label id
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "Module should be enabled by default"
  }

  assert {
    condition     = output.repository_name == "eg-test-thing"
    error_message = "repository_name should be the tf-label id 'eg-test-thing'"
  }
}

# ---------------------------------------------------------------------------
# Test: a namespace/name change flows through to the derived repository name
# ---------------------------------------------------------------------------
run "id_reflects_context" {
  command = plan

  variables {
    namespace = "acme"
    stage     = "prod"
    name      = "api"
  }

  assert {
    condition     = output.repository_name == "acme-prod-api"
    error_message = "repository_name should track the tf-label context (expected 'acme-prod-api')"
  }

  assert {
    condition     = output.enabled == true
    error_message = "Module should remain enabled"
  }
}
