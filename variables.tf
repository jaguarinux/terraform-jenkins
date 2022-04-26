# code name
variable "code_name" {
  default = "sparrow"
}
# Region
variable "region" {
  description = "Default region"
  default     = "us-east-1"
}
# zones
variable "az1" {
  description = "Default region"
  default     = "us-east-1a"
}
variable "az2" {
  description = "Default region"
  default     = "us-east-1c"
}
# CDIRS for subnets
variable "subnet_cidrs_private" {
  description = "Subnet CIDRs for private subnets"
  default     = ["10.0.41.0/28", "10.0.41.16/28"]
  type        = list(string)
}
variable "subnet_cidrs_public1" {
  description = "Subnet CIDRs for public subnets 1"
  default     = "10.0.41.32/28"
}
variable "subnet_cdirs_public2" {
  description = "Subnet CIDRs for public subnet 2"
  default     = "10.0.41.48/28"
}
# ingress ports
variable "iSSH" {
  description = "SSH ingress port"
  type        = number
  default     = 22
}
variable "iHTTP" {
  description = "HTTP ingress port"
  type        = number
  default     = 80
}
# egress ports
variable "eAll" {
  description = "egress port All"
  type        = number
  default     = 0
}
# cdir block SG
variable "cdirAll" {
  description = "Default cdir block to All"
  default     = "0.0.0.0/0"
}
# AMI Linux 2
variable "ami-1" {
  description = "ami us-east-1"
  default     = "ami-03ededff12e34e59e"
}
# AMI Linux 2022
variable "ami-2022" {
  description = "ami 2022 us-east-1"
  default     = "ami-0b784fdb4a12f014a"
}
