variable "image_tag_mutability" {
  description = "Tag mutability (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "Max images to keep (used in default lifecycle policy)"
  type        = number
  default     = 30
}

variable "lifecycle_policy" {
  description = "Custom lifecycle policy JSON (overrides default)"
  type        = string
  default     = null
}
