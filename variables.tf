variable "dns_support" {
  description = "Whether DNS support is `enabled`. Valid values: `disable`, `enable`. Default value: `enable`."
  type        = string
  default     = "enable"
}

variable "tgw-id" {
  description = "ID of tgw"
  type        = string
}

variable "subnet-tag-filter-key" {
  description = "Key of the tag to filter subnets. Default value: `Name`."
  type        = string
  default     = "Name"
}

variable "subnet-tag-filter-value" {
  description = "Value of the tag to filter subnets. Default value: `*Private*`."
  type        = string
  default     = "*Private*"
}

variable "vpc-tag-filter-key" {
  description = "Key of the tag to filter vpcs. Default value: `Name`."
  type        = string
  default     = "Name"
}

variable "vpc-tag-filter-value" {
  description = "Value of the tag to filter subnets. Default value: `*Private*`."
  type        = string
}

variable "tgw-attachment-name" {
  description = "Name of the tgw attachment. Default value: `None`."
  type        = string
  default     = ""
}
