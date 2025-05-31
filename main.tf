locals {

  dns_support = var.dns_support ? "enable" : "disable"
}

##########################
#      Data Sources      #
##########################

data "aws_vpc" "tgw-vpc" {
  filter {
    name   = "tag:${var.vpc-tag-filter-key}"
    values = [var.vpc-tag-filter-value]
  }
}

data "aws_subnets" "tgw_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.tgw-vpc.id]
  }
  filter {
    name   = "tag:${var.subnet-tag-filter-key}"
    values = [var.subnet-tag-filter-value]
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "default" {
  subnet_ids         = data.aws_subnets.tgw_subnets.ids
  transit_gateway_id = var.tgw-id
  vpc_id             = data.aws_vpc.tgw-vpc.id
  dns_support        = local.dns_support
}
