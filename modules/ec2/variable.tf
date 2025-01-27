variable "instanceName" {
  description = "Name of the EC2 Instance"
  type        = string
}

variable "amiID" {
  description = "AMI ID of the EC2 Instance"
  type        = string
  default     = "ami-0ac4dfaf1c5c0cce9"
}

variable "instanceType" {
  description = "EC2 Family"
  type        = string
  default     = "t2.micro"
}

variable "instanceSubnetID" {
  description = "Subnet ID to place the EC2 Instance"
  type        = string
}

variable "enablePublicIP" {
  description = "Enable Public IP for the instance"
  type        = bool
  default     = false
}

variable "ec2KeyName" {
  description = "Provide the keypair name of the manually created key"
  type = string
  default = null
}

variable "sgList" {
  description = "List of securityGroups to associate with EC2 Instance"
  type = list(string)
  default = []
}