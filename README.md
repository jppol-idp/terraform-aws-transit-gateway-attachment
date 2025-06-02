# terraform-aws-transit-gateway-attachment

### Example usage of the terraform-aws-transit-gateway-attachment module
```yaml
module "idp-test" {
  source                  = "github.com/jppol-idp/terraform-aws-transit-gateway-attachment?ref=v1.0.0"
  dns_support             = true
  tgw-id                  = "tgw-00300cb5cb91bbd19"
  vpc-tag-filter-key      = "Name"
  vpc-tag-filter-value    = "idp-test"
  subnet-tag-filter-key   = "Tier"
  subnet-tag-filter-value = "*Private*"
  tgw-attachement-name    = "tgw-shared"
}
```
