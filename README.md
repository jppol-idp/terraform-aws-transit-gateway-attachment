# terraform-aws-transit-gateway-attachment

### Example usage of the terraform-aws-transit-gateway-attachment module, in this case from the idp-test account 971422674709 in jppol-idp/idp-main-setup/infrastructure/accounts/jppol-idp-test/971422674709/05.transit-gateway 05.transit-gateway
*main.tf*
```yaml
  module "idp-shared-test" {  # Change this to your module name
  source                  = "github.com/jppol-idp/terraform-aws-transit-gateway-attachment?ref=v1.0.7"
  dns_support             = true
  tgw-id                  = "tgw-00300cb5cb91bbd19"
  vpc-tag-filter-key      = "Name"
  vpc-tag-filter-value    = "idp-shared-test"  # Change this to your VPC tag
  subnet-tag-filter-key   = "tier"
  subnet-tag-filter-value = "private"
  tgw-attachment-name     = "tgw-shared"
}
```

You should only have to change `vpc-tag-filter-value`

---

*provider.tf*
```yaml
terraform {
  required_version = "~> 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.8"
    }
  }

  backend "s3" {
    bucket         = "jppol-idp-state"
    key            = "idp/accounts/971422674709/05.transit-gateway"
    region         = "eu-west-1"
    dynamodb_table = "arn:aws:dynamodb:eu-west-1:692859947694:table/jppol-idp-state"
    encrypt        = true
    assume_role = {
      role_arn = "arn:aws:iam::971422674709:role/idp-deploy-access"
    }
  }
}

provider "aws" {
  region              = "eu-west-1"
  allowed_account_ids = ["971422674709"]
  assume_role {
    role_arn = "arn:aws:iam::971422674709:role/idp-deploy-access"
  }
  default_tags {
    tags = {
      "terraform"   = "true",
      "origin"      = "/idp/accounts/971422674709/05.transit-gateway",
      "cost_center" = "9910",
      "service"     = "idp"
    }
  }
}
```

It should be enough to replace `971422674709` with your account id 

---
