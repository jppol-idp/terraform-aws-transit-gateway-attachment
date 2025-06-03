## terraform-aws-transit-gateway-attachment

### Example usage of the terraform-aws-transit-gateway-attachment module

*main.tf*
```yaml
  module "<vpc-name>" {  # Change this to your module name
  source                  = "github.com/jppol-idp/terraform-aws-transit-gateway-attachment?ref=v1.0.7"
  dns_support             = true
  tgw-id                  = "<tgw-id>"  # Change this to the tgw id
  vpc-tag-filter-key      = "Name"
  vpc-tag-filter-value    = "<vpc name tag>"  # Change this to your VPC tag
  subnet-tag-filter-key   = "tier"
  subnet-tag-filter-value = "private"
  tgw-attachment-name     = "tgw-shared"
}
```
