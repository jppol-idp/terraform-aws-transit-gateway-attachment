locals {

  dns_support    = var.dns_support ? "enable" : "disable"
  appliance_mode = var.tgw-appliance-mode-support ? "enable" : "disable"
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
  subnet_ids             = data.aws_subnets.tgw_attachment_subnets.ids
  transit_gateway_id     = var.tgw-id
  vpc_id                 = data.aws_vpc.tgw-vpc.id
  dns_support            = local.dns_support
  appliance_mode_support = local.appliance_mode
  tags = {
    Name = var.tgw-attachment-name
  }
}

# Lookup route tables associated with each subnet
data "aws_route_table" "private_rt" {
  for_each  = toset(data.aws_subnets.tgw_attachment_subnets.ids)
  subnet_id = each.value
}

locals {
  # Get unique route table IDs from your data source
  unique_route_table_ids = distinct([for rt in data.aws_route_table.private_rt : rt.id])

  # Create all unique combinations of route table IDs and routed subnets
  private_route_combinations = flatten([
    for rt_id in local.unique_route_table_ids : [
      for cidr in var.tgw-routed-subnets : {
        route_table_id         = rt_id
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
