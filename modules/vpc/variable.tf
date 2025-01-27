variable "vpcName" {
  description = "Name of the VPC"
  type        = string
}

variable "vpcCidr" {
  description = "The CIDR Range of the VPC"
  type        = string
}

variable "subnets" {
  type = map(object({
    subnetCIDR = string
    az         = optional(string)
  }))
}