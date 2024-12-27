# subscription id to use for terraform plan and apply
# variable "subscription_id" {
#   description = "The subscription ID to use for terraform plan and apply"
#   type        = string
# }

variable "billing_account_name" {
  description = "The billing account name or billing account id"
  type        = string
}

variable "billing_profile_name" {
  description = "The billing profile name or billing profile id"
  type        = string
}

variable "invoice_section_name" {
  description = "The invoice section name or invoice section id"
  type        = string
}

variable "subscription_name" {
  description = "The name of the subscription"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = null
}