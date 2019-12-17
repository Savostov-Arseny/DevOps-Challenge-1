variable "access_key" {}
variable "secret_key" {}
variable "aws_region" {}
variable "instance_type" {}
variable "key_name" {}

variable "tag_name" {
  default = "SA_solution"
}
variable "vpc_zone_identifier" {
  description = "Subnet_ids list using by autoscaling group"
  type        = list(string)
}
