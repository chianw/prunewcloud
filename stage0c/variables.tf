variable "organization_name" {
  description = "GitHub organization (or user)"
  type        = string
}

variable "repository_name" {
  description = "The GitHub repository to set up workload identity for"
  type        = string
}

variable "azure_role" {
  description = "Which role to assign to the workload identity in Azure?"
  type        = string
}

variable "environment" {
  description = "The GitHub environments to add as subject identifiers"
  type        = string
}

variable "pull_request" {
  description = "Add the 'pull request' subject identifier?"
  type        = bool
  default     = false
}
