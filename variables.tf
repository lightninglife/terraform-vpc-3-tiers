variable "region" {
  type        = string
  description = "aws_region"
}

variable "aws_vpc_cidr_block" {
  type        = string
  description = "aws_vpc_cidr_block"
}

variable "aws_vpc_instance_tenancy" {
  type        = string
  description = "aws_vpc_instance_tenancy"
}

variable "aws_vpc_enable_dns_support" {
  type        = number
  description = "aws_vpc_enable_dns_support"
}

variable "aws_vpc_enable_dns_hostnames" {
  type        = number
  description = "aws_vpc_enable_dns_hostnames"
}

variable "aws_vpc_tagname" {
  type        = string
  description = "aws_vpc_tagname"
}

variable "aws_vpc_tag_key" {
  type        = string
  description = "aws_vpc_tag_key"
}

variable "aws_vpc_tag_value" {
  type        = string
  description = "aws_vpc_tag_value"
}

variable "aws_vpc_domain_name" {
  type        = string
  description = "aws_vpc_domain_name"
}

variable "aws_vpc_domain_name_servers" {
  type        = list(string)
  description = "aws_vpc_domain_name_servers"
}

variable "aws_vpc_tagname_dhcp" {
  type        = string
  description = "aws_vpc_tagname_dhcp"
}

variable "iam_role_policy_random_integer_min_1" {
  type        = number
  description = "iam_role_policy_random_integer_min_1"
}

variable "iam_role_policy_random_integer_max_1" {
  type        = number
  description = "iam_role_policy_random_integer_max_1"
}

variable "iam_role_policy_random_integer_min_2" {
  type        = number
  description = "iam_role_policy_random_integer_min_2"
}

variable "iam_role_policy_random_integer_max_2" {
  type        = number
  description = "iam_role_policy_random_integer_max_2"
}

variable "iam_role_policy_random_integer_min_3" {
  type        = number
  description = "iam_role_policy_random_integer_min_3"
}

variable "iam_role_policy_random_integer_max_3" {
  type        = number
  description = "iam_role_policy_random_integer_max_3"
}

variable "flow_logs_iam_role_name" {
  type        = string
  description = "flow_logs_iam_role_name"
}

variable "flow_logs_policy_name" {
  type        = string
  description = "flow_logs_policy_name"
}

variable "aws_cloudwatch_log_group_flow_logs_name" {
  type        = string
  description = "aws_cloudwatch_log_group_flow_logs_name"
}

variable "aws_cloudwatch_log_group_retention_in_days" {
  type        = number
  description = "aws_cloudwatch_log_group_retention_in_days "
}

variable "aws_flow_log_traffic_type" {
  type        = string
  description = "aws_flow_log_traffic_type"
}