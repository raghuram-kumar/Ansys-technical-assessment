variable "sgName" {
  description = "Name of the Secueity Group"
  type        = string
}

variable "sgDescription" {
  description = "Description of the securityGroup"
  type        = string
  default     = "Default SG"
}

variable "sgVPCID" {
  description = "VPC ID for the security Grouo"
  type        = string
}

variable "sgRulesIngress" {
  description = "Rules for the securityGroup"
  type = list(object({
    cidr     = string
    fromPort = number
    protocol = string
    toPort   = number
  }))
}

variable "sgRulesEgress" {
  description = "Rules for the securityGroup"
  type = list(object({
    cidr     = string
    protocol = string
  }))
}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default = {
    "ManagedBy" = "Terraform"
  }
}