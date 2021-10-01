terraform {

  backend "s3" {
    bucket         = "tsuru-gcp-tfstates"
    key            = "rpaas/dev/BE/rpaasv2-BE_desafiodevops-dev/terraform.tfstate"
    dynamodb_table = "tsuru-gcp-tfstates"
    region         = "sa-east-1"
    encrypt        = true
  }

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

variable "host" {}
variable "token" {}

provider "tsuru" {
  host                   = var.host
  token                  = var.token
  skip_cert_verification = true
}
provider "rpaas" {
  host                   = var.host
  token                  = var.token
  skip_cert_verification = false
}


resource "tsuru_app" "desafiodevops-dev" {
  name           = "desafiodevops-dev"
  plan           = "small"
  platform       = ""
  team_owner     = "infravideos"
  description    = "APP de teste"
  pool           = "dev"
  default_router = "galeb_dev"
}

resource "tsuru_service_instance_bind" "desafiodevops-dev-rpaasv2-fe-rjdev" {
 app              = tsuru_app.desafiodevops-dev.name
 service_name     = "rpaasv2-fe-rjdev"
 service_instance = "desafiodevops-rpaas-fe-dev"
}


resource "tsuru_service_instance" "rpaasv2-be-BE_desafiodevops-rpaas-be-dev" {
  name         = "desafiodevops-rpaas-be-dev"
  service_name = "rpaasv2-be-rjdev"
  description  = ""
  owner        = "gg_hdg_gigagloob"
  plan         = ""
  tags         = []
  parameters   = {}
}

resource "rpaas_route" "rpaasv2-be-desafiodevops-rpaas-be-dev" {
  depends_on   = [tsuru_service_instance.rpaasv2-be-desafiodevops-rpaas-be-dev]
  service_name = "rpaasv2-be-rjdev"
  instance     = "desafiodevops-rpaas-be-dev"
  path         = "/"
  content      = <<EOT
location / {
  proxy_buffer_size     6k;
  proxy_set_header Connection "";
  proxy_http_version 1.1;
  proxy_cache_lock on;
  proxy_cache_background_update on;
  proxy_pass            http://desafiodevops_api_dev$request_uri;
  break;
}
	EOT
}

resource "rpaas_block" "rpaasv2-be-desafiodevops-api-dev-rpaas-be-gcp-dev-http" {
  depends_on   = [tsuru_service_instance.rpaasv2-be-desafiodevops-rpaas-be-dev]
  service_name = "rpaasv2-be-rjdev"
  instance     = "desafiodevops-rpaas-be-dev"
  name         = "http"
  content      = <<EOT
upstream desafiodevops_api_dev {
    server desafiodevops-api-dev.gcloud.globoi.com fail_timeout=2s max_fails=0 weight=1;
    keepalive 100;
}

  EOT

}
