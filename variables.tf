variable "vpc_cidr" {
  description = "The cidr for VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 1))
    error_message = "The given cidr is not valid"
  }
}


variable "public_subnets" {
  description = "Value of CIDR and AZ for public subnets"
  type = map(object({
    availability_zone = string
    cidr_block        = string
  }))
  default = {
    public_subnet_1 = {
      availability_zone = "us-east-1a"
      cidr_block        = "10.0.1.0/24"
    }
    public_subnet_2 = {
      availability_zone = "us-east-1b"
      cidr_block        = "10.0.2.0/24"
    }
  }
}

variable "private_subnets" {
  description = "Value of CIDR and AZ for public subnets"
  type = map(object({
    availability_zone = string
    cidr_block        = string
  }))
  default = {
    private_subnet_1 = {
      availability_zone = "us-east-1a"
      cidr_block        = "10.0.3.0/24"
    }
    private_subnet_2 = {
      availability_zone = "us-east-1b"
      cidr_block        = "10.0.4.0/24"
    }
  }
}

variable "ami_id" {
  description = "The AMI for the instance"
}

variable "key_name" {
  description = "value of the key_pair name"
}

variable "db-subnet-name" {
  description = "name of the db subnet group"
}

variable "db-sg-name" {
  description = "name of the db security group"
}

variable "db-username" {
  description = "Database username"
  type        = string
}

variable "db-password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
