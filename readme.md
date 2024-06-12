# Create the AWS instance, VPC with terraform standard

### terraform configuration

### `provider.tf`

This file will contain the provider configuration.

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

```

### `main.tf`

This file will contain the main resources such as the EC2 instance and its output.

```
# main.tf

resource "aws_instance" "example" {
  ami                  = "ami-045602374a1982480"
  instance_type        = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  subnet_id            = aws_subnet.public-tf-testing.id
}

output "instance_ip" {
  value = aws_instance.example.public_ip
}

```

### `network.tf`

This file will contain all the networking resources such as VPC, subnets, route tables, and security groups.

```
# network.tf

resource "aws_vpc" "tf-testing" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "tf-testing"
  }
}

resource "aws_subnet" "public-tf-testing" {
  cidr_block         = "10.0.1.0/24"
  vpc_id             = aws_vpc.tf-testing.id
  availability_zone  = "us-east-1a"
}

resource "aws_subnet" "private-tf-testing" {
  cidr_block         = "10.0.2.0/24"
  vpc_id             = aws_vpc.tf-testing.id
  availability_zone  = "us-west-1a"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tf-testing.id
}

resource "aws_route_table" "public-tf-route" {
  vpc_id = aws_vpc.tf-testing.id
}

resource "aws_route_table" "private-tf-route" {
  vpc_id = aws_vpc.tf-testing.id
}

resource "aws_route" "public-tf-route" {
  route_table_id         = aws_route_table.public-tf-route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private-tf-route" {
  route_table_id         = aws_route_table.private-tf-route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public-tf-route.id
  subnet_id      = aws_subnet.public-tf-testing.id
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.tf-testing.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

```

### Folder Structure

Make sure your directory structure looks like this:

```css
your-terraform-directory/
├── provider.tf
├── variables.tf
├── main.tf
└── network.tf

```

### Running Terraform

Navigate to your project directory and run the following commands:

1. **Initialize Terraform**:
    
    ```
    terraform init
    ```
    
2. **Validate Configuration**:
    
    ```
    terraform validate
    ```
    
3. **Plan and Apply**:
    
    ```
    terraform plan
    terraform apply
    ```

### Verify Status

1. Go to aws console 
2. Check VPC 
3. Go to EC2 instance and check the public IPv4, private subnet and security group

### Destory the resource

Destory the following commands:

1. **Initialize Terraform**:
    
    ```
    terraform destory
    ```