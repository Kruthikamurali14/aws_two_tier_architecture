<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.rds-1](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.db-subnet-grp](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/db_subnet_group) | resource |
| [aws_instance.instance_1](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/instance) | resource |
| [aws_instance.instance_2](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/instance) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/internet_gateway) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/lb) | resource |
| [aws_lb_listener.front_end](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.tg_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/lb_target_group_attachment) | resource |
| [aws_route_table.main_rt](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/route_table) | resource |
| [aws_route_table_association.rt_assoc_1](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.rt_assoc_2](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/route_table_association) | resource |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/security_group) | resource |
| [aws_security_group.db-sg](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/security_group) | resource |
| [aws_security_group.ec2-sg](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/security_group) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/subnet) | resource |
| [aws_vpc.new_vpc](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The AMI for the instance | `any` | n/a | yes |
| <a name="input_db-password"></a> [db-password](#input\_db-password) | Database password | `string` | n/a | yes |
| <a name="input_db-sg-name"></a> [db-sg-name](#input\_db-sg-name) | name of the db security group | `any` | n/a | yes |
| <a name="input_db-subnet-name"></a> [db-subnet-name](#input\_db-subnet-name) | name of the db subnet group | `any` | n/a | yes |
| <a name="input_db-username"></a> [db-username](#input\_db-username) | Database username | `string` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | value of the key\_pair name | `any` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Value of CIDR and AZ for public subnets | <pre>map(object({<br/>    availability_zone = string<br/>    cidr_block        = string<br/>  }))</pre> | <pre>{<br/>  "private_subnet_1": {<br/>    "availability_zone": "us-east-1a",<br/>    "cidr_block": "10.0.3.0/24"<br/>  },<br/>  "private_subnet_2": {<br/>    "availability_zone": "us-east-1b",<br/>    "cidr_block": "10.0.4.0/24"<br/>  }<br/>}</pre> | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Value of CIDR and AZ for public subnets | <pre>map(object({<br/>    availability_zone = string<br/>    cidr_block        = string<br/>  }))</pre> | <pre>{<br/>  "public_subnet_1": {<br/>    "availability_zone": "us-east-1a",<br/>    "cidr_block": "10.0.1.0/24"<br/>  },<br/>  "public_subnet_2": {<br/>    "availability_zone": "us-east-1b",<br/>    "cidr_block": "10.0.2.0/24"<br/>  }<br/>}</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The cidr for VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | n/a |
<!-- END_TF_DOCS -->