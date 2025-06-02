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

data "aws_subnets" "tgw_attachment_subnets" {
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
  subnet_ids         = data.aws_subnets.tgw_attachment_subnets.ids
  transit_gateway_id = var.tgw-id
  vpc_id             = data.aws_vpc.tgw-vpc.id
  dns_support        = local.dns_support
  tags = {
    Name = var.tgw-attachment-name
  }
}

# Lookup route tables associated with each subnet
data "aws_route_table" "private_rt" {
  for_each  = toset(data.aws_subnets.tgw_attachment_subnets.ids)
  subnet_id = each.value
}

# Flatten combinations of route table IDs and destination CIDRs
locals {
  private_route_combinations = flatten([
    for rt in data.aws_route_table.private_rt : [
      for cidr in var.tgw-routed-subnets : {
        route_table_id         = rt.id
        destination_cidr_block = cidr
      }
    ]
  ])
}

resource "aws_route" "tgw_routes" {
  for_each = {
    for combo in local.private_route_combinations : 
    "${combo.route_table_id}:${combo.destination_cidr_block}" => combo
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  transit_gateway_id     = var.tgw-id
}
