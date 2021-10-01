terraform {
  required_version = ">= 1.0"
  required_providers {
    tsuru = {
      source  = "tsuru/tsuru"
      version = "~> 2.1.3"
    }
  }
}

provider "tsuru" {
  host                   = var.host
  token                  = var.token
  skip_cert_verification = true
}
