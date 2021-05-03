output "vpc" {
  value       = aws_vpc.terraform_vpc.cidr_block
  description = "VPC created"
}

output "public_subnet_1" {
  value       = var.public_subnet_cidr_block_1
  description = "Public Subnet 1 Cidr_block"
}

output "public_subnet_2" {
  value       = var.public_subnet_cidr_block_2
  description = "Public Subnet 2 Cidr_block"
}

output "private_subnet_1" {
  value       = var.private_subnet_cidr_block_1
  description = "Public Subnet 2 Cidr_block"
}

output "rds_instance_type" {
  value       = var.rds_instance_class
  description = "RDS instance type"
}

output "alb" {
  value       = aws_lb.alb
  description = "ALB info"
}
