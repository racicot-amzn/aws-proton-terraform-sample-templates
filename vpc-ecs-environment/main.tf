/*
This file is managed by AWS Proton. Any changes made directly to this file will be overwritten the next time AWS Proton performs an update.

To manage this resource, see AWS Proton Resource: arn:aws:proton:us-east-1:259837135622:environment/vpc-ecs-environment

If the resource is no longer accessible within AWS Proton, it may have been deleted and may require manual cleanup.
*/

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  cidr = var.environment.inputs.vpc_cidr

  azs                = ["${var.aws_region}a"]
  private_subnets    = [var.environment.inputs.private_subnet_one_cidr, var.environment.inputs.private_subnet_two_cidr]
  public_subnets     = [var.environment.inputs.public_subnet_one_cidr, var.environment.inputs.public_subnet_two_cidr]
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = var.environment.name
  }
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.4.1"
  name    = "${var.environment.name}-ECS"
}

module "sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "3.3.0"
}