
terraform {
  required_providers {
    tsuru = {
      source = "tsuru/tsuru"
    }
    rpaas = {
      source  = "tsuru/rpaas"
      version = "~> 0.0.9"
    }
  }
}

provider "tsuru" {
  host                   = var.host
  token                  = var.token
  skip_cert_verification = true
}
provider "rpaas" {
  host                   = var.host
  token                  = var.token
  skip_cert_verification = true
}