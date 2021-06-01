# provider - aws and region
provider "aws" {
  region  = var.region
}

# create a custom vpc
resource "aws_vpc" "terraform_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = var.vpc_name
  }
}

### tier #1 - web tier
# create an internet gateway to connect vpc with internet
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.terraform_vpc.id
}

# create a public subnet #1
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = var.public_subnet_cidr_block_1

  tags = {
    Name = var.public_subnet_name_1
  }
}

# create a public route table #1
resource "aws_route_table" "public_subnet_1_to_internet" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = var.public_route_table_1
  }
}

# make a route table connection in between public route table #1 with public subnet #1
resource "aws_route_table_association" "internet_for_public_subnet_1" {
  route_table_id = aws_route_table.public_subnet_1_to_internet.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

## ensure high availability of web tier
# create a public subnet #2
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = var.public_subnet_cidr_block_2

  tags = {
    Name = var.public_subnet_name_2
  }
}

# create a public route table #2
resource "aws_route_table" "public_subnet_2_to_internet" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = var.public_route_table_2
  }
}

# make a route table connection in between public route table #2 with public subnet #2
resource "aws_route_table_association" "internet_for_public_subnet_2" {
  route_table_id = aws_route_table.public_subnet_2_to_internet.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

### tier #2 - app tier
# create a private subnet #1
resource "aws_subnet" "private_subnet_1" {
  cidr_block = var.private_subnet_cidr_block_1
  vpc_id = aws_vpc.terraform_vpc.id
  availability_zone = var.private_subnet_1_az

  tags = {
    Name = var.tagkey_name_private_subnet_1
  }
}

# create an EIP #1 and Nat gateway #1
resource "aws_eip" "eip_1" {
  count = "1"
}

resource "aws_nat_gateway" "natgateway_1" {
  count = "1"
  allocation_id = aws_eip.eip_1[count.index].id
  subnet_id = aws_subnet.public_subnet_1.id
}

# create a private route table #1
resource "aws_route_table" "nategateway_route_table_1" {
  count  = "1"
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1[count.index].id
  }

  tags = {
    Name = var.tagkey_name_natgateway_route_table_1
  }
}

# make a route table connection in between private route table #1 with private subnet #1
resource "aws_route_table_association" "private_subnet_1_to_natgateway" {
  count          = "1"
  route_table_id = aws_route_table.nategateway_route_table_1[count.index].id
  subnet_id      = aws_subnet.private_subnet_1.id
}

## ensure high availability of app tier
# create a private subnet #2
resource "aws_subnet" "private_subnet_2" {
  cidr_block = var.private_subnet_cidr_block_2
  vpc_id = aws_vpc.terraform_vpc.id
  availability_zone = var.private_subnet_2_az

  tags = {
    Name = var.tagkey_name_private_subnet_2
  }
}

# create an EIP #2 and Nat gateway #2
resource "aws_eip" "eip_2" {
  count = "1"
}

resource "aws_nat_gateway" "natgateway_2" {
  count = "1"
  allocation_id = aws_eip.eip_2[count.index].id
  subnet_id = aws_subnet.public_subnet_2.id
}

# create a private route table #2
resource "aws_route_table" "nategateway_route_table_2" {
  count  = "1"
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_2[count.index].id
  }

  tags = {
    Name = var.tagkey_name_natgateway_route_table_2
  }
}

# make a route table connection in between private route table #2 with private subnet #2 
resource "aws_route_table_association" "private_subnet_2_to_natgateway" {
  count          = "1"
  route_table_id = aws_route_table.nategateway_route_table_2[count.index].id
  subnet_id      = aws_subnet.private_subnet_2.id
}

### tier #3 - database tier
# create a private subnet #3
resource "aws_subnet" "private_subnet_3" {
  cidr_block = var.private_subnet_cidr_block_3
  vpc_id = aws_vpc.terraform_vpc.id
  availability_zone = var.private_subnet_3_az

  tags = {
    Name = var.tagkey_name_private_subnet_3
  }
}

# create an EIP #3 and Nat gateway #3
resource "aws_eip" "eip_3" {
  count = "1"
}

resource "aws_nat_gateway" "natgateway_3" {
  count = "1"
  allocation_id = aws_eip.eip_3[count.index].id
  subnet_id = aws_subnet.private_subnet_3.id
}

# create a private route table #3
resource "aws_route_table" "nategateway_route_table_3" {
  count  = "1"
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_3[count.index].id
  }

  tags = {
    Name = var.tagkey_name_natgateway_route_table_3
  }
}

# make a route table connection in between private route table #3 with private subnet #3
resource "aws_route_table_association" "private_subnet_3_to_natgateway" {
  count          = "1"
  route_table_id = aws_route_table.nategateway_route_table_3[count.index].id
  subnet_id      = aws_subnet.private_subnet_3.id
}

## ensure high availability of database tier
# create a private subnet #4
resource "aws_subnet" "private_subnet_4" {
  cidr_block = var.private_subnet_cidr_block_4
  vpc_id = aws_vpc.terraform_vpc.id
  availability_zone = var.private_subnet_4_az

  tags = {
    Name = var.tagkey_name_private_subnet_4
  }
}

# create an EIP #4 and Nat gateway #4
resource "aws_eip" "eip_4" {
  count = "1"
}

resource "aws_nat_gateway" "natgateway_4" {
  count = "1"
  allocation_id = aws_eip.eip_4[count.index].id
  subnet_id = aws_subnet.private_subnet_4.id
}

# create a private route table #4
resource "aws_route_table" "nategateway_route_table_4" {
  count  = "1"
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_4[count.index].id
  }

  tags = {
    Name = var.tagkey_name_natgateway_route_table_4
  }
}

# make a route table connection in between private route table #4 with private subnet #4
resource "aws_route_table_association" "private_subnet_4_to_natgateway" {
  count          = "1"
  route_table_id = aws_route_table.nategateway_route_table_4[count.index].id
  subnet_id      = aws_subnet.private_subnet_4.id
}


### EC2 information
# Create a keypair
resource "tls_private_key" "public_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = var.key_name
  public_key = tls_private_key.public_key.public_key_openssh
}

# Create 2 EC instances for high availability
locals {
  subs = concat([aws_subnet.public_subnet_1.id], [aws_subnet.public_subnet_2.id])
}

resource "aws_instance" "terraform_ec2" {
  count          = var.ec2_count
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids      = [aws_security_group.alb_sg.id]
  subnet_id                   = element(local.subs, 2)
  associate_public_ip_address = var.associate_public_ip_address_bool
}

### RDS Mysql information 
# Create 2 RDS Mysql intances for high availability
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_3.id, aws_subnet.private_subnet_4.id]

  tags = {
    Name = "RDS Mysql subnet group"
  }
}

resource "aws_db_instance" "rds_mysql_instance"  {
  count                 = var.rds_mysql_instance_count
  allocated_storage     = var.rds_allocated_storage
  engine                = var.rds_engine
  engine_version        = var.rds_engine_version
  instance_class        = var.rds_instance_class
  name                  = var.rds_name
  username              = var.rds_username
  password              = var.rds_password
  parameter_group_name  = var.rds_parameter_group_name
  skip_final_snapshot   = var.rds_skip_final_snapshot
  publicly_accessible   = var.rds_publicly_accessible
  vpc_security_group_ids = [aws_security_group.alb_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.id
}

### ALB information
# Create an ALB 
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id,aws_subnet.public_subnet_2.id]

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Environment  = var.alb_tagname
  }
}

### shared Security Group 
# Create a shared security group 
resource "aws_security_group" "alb_sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = var.rds_from_port
    to_port     = var.rds_to_port
    protocol    = "tcp"
    description = "MySQL"
    self        = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = var.my_ip_address
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    self        = true
  }

  egress {
    from_port        = var.sg_egress_from_port
    to_port          = var.sg_egress_to_port
    protocol         = var.sg_egress_protocol
    cidr_blocks      = var.sg_egress_cidr_blocks
  }

  tags = {
    Name = var.sg_tagname
  }
}
