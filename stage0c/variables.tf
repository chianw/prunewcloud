variable "organization_name" {
  description = "GitHub organization (or user)"
  type        = string
}

variable "repository_name" {
  description = "The GitHub repository to set up workload identity for"
  type        = string
}

variable "azure_roles" {
  description = "Which role to assign to the workload identity in Azure?"
  type        = list(string)
}

# assign Management Group Contributor, Management Group Reader, Hierarchy Settings Administrator, Resource Policy Contributor to ESLZ service principal at tenant root group
# in GH the secret will be defined as mgt_group_roles = ["Management Group Contributor", "Management Group Reader", "Hierarchy Settings Administrator", "Resource Policy Contributor"]
variable "mgt_group_roles" {
  description = "Which role to assign to the workload identity in the management group?"
  type        = list(string)
}

variable "environments" {
  description = "The GitHub environments to add as subject identifiers"
  type        = list(string)
}

variable "pull_request" {
  description = "Add the 'pull request' subject identifier?"
  type        = bool
  default     = false
}

variable "app_id" {
  description = "GitHub App ID"
  type        = string
}

variable "app_installation_id" {
  description = "GitHub App Installation ID"
  type        = string
}

variable "app_pem_file" {
  description = "Path to the GitHub App PEM file"
  type        = string
}