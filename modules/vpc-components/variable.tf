variable "natGateway" {
  description = "Name of the Nat Gateway"
  type = list(object({
    natGatewayName = optional(string)
    subnetID       = optional(string)
  }))
  default = []
}

variable "rtbAssociation" {
  description = "Subnet and Route Table Association"
  type = list(object({
    subnetID     = string
    routeTableID = string
  }))
  default = []
}

variable "routeTable" {
  description = "Mapping of route table definitions"
  type = map(object({
    routes = list(object({
      cidrBlock           = optional(string, null)
      gatewayId           = optional(string, null)
      natGatewayId        = optional(string, null)
      egressOnlyGatewayId = optional(string, null)
    }))
  }))
  default = {}
}


variable "vpcID" {
  description = "VPC ID"
  type        = string
  default     = null
}