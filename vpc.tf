# provider - aws and region with profile
provider "aws" {
  region  = var.region
  profile = "Dev"
}

# create a custom vpc
resource "aws_vpc" "eu_vpc_interact_public_cloud" {
  cidr_block           = var.aws_vpc_cidr_block
  instance_tenancy     = var.aws_vpc_instance_tenancy == "" ? "default" : var.aws_vpc_instance_tenancy
  enable_dns_support   = var.aws_vpc_enable_dns_support != "" ? true : false
  enable_dns_hostnames = var.aws_vpc_enable_dns_hostnames != "" ? true : false

  tags = {
    Name                  = var.aws_vpc_tagname
    (var.aws_vpc_tag_key) = var.aws_vpc_tag_value
  }
}

# create a vpc dhcp option
resource "aws_vpc_dhcp_options" "vpc_dhcp_options" {
  domain_name         = var.aws_vpc_domain_name
  domain_name_servers = var.aws_vpc_domain_name_servers

  tags = {
    Name = var.aws_vpc_tagname_dhcp
  }
}

# create random integers for iam role poilicy name
resource "random_integer" "iam_role_policy_random_integer_1" {
  min = var.iam_role_policy_random_integer_min_1
  max = var.iam_role_policy_random_integer_max_1
}

resource "random_integer" "iam_role_policy_random_integer_2" {
  min = var.iam_role_policy_random_integer_min_2
  max = var.iam_role_policy_random_integer_max_2
}

resource "random_integer" "iam_role_policy_random_integer_3" {
  min = var.iam_role_policy_random_integer_min_3
  max = var.iam_role_policy_random_integer_max_3
}

# create an iam role, policy
resource "aws_iam_role" "flow_logs_role" {
  name = "flow_logs_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = data.aws_iam_policy_document.flow_logs_policy_document.json

  inline_policy {
    name = "oneClick_flowlogsRole_${random_integer.iam_role_policy_random_integer_1.result}"
    policy = data.aws_iam_policy_document.inline_policy_1.json
  }  

  inline_policy {
    name = "oneClick_flowlogsRole_${tonumber(((random_integer.iam_role_policy_random_integer_2.result)))}"
    policy = data.aws_iam_policy_document.inline_policy_2.json
  }  

  inline_policy {
    name = "oneClick_flowlogsRole_${tonumber(((random_integer.iam_role_policy_random_integer_3.result)))}"
    policy = data.aws_iam_policy_document.inline_policy_3.json
  }  
}

# create a cloud watch log group
resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = var.aws_cloudwatch_log_group_flow_logs_name
  retention_in_days = var.aws_cloudwatch_log_group_retention_in_days
}

# create a vpc flow log
resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  traffic_type    = var.aws_flow_log_traffic_type == "" ? "ALL" : var.aws_flow_log_traffic_type
  vpc_id          = aws_vpc.eu_vpc_interact_public_cloud.id
}


