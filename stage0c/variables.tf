variable "github_organization_name" {
  description = "GitHub organization (or user)"
  type        = string
}

variable "github_repository_name" {
  description = "The GitHub repository to set up workload identity for"
  type        = string
}

variable "azure_roles" {
  description = "Which roles to assign to the workload identity in Azure?"
  type        = list(string)
}

variable "branches" {
  description = "List of git branches to add as subject identifiers"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "List of git tags to add as subject identifiers"
  type        = list(string)
  default     = []
}

variable "environments" {
  description = "List of GitHub environments to add as subject identifiers"
  type        = list(string)
  default     = []
}

variable "pull_request" {
  description = "Add the 'pull request' subject identifier?"
  type        = bool
  default     = false
}
