
resource "tsuru_app" "desafiodevops-dev" {
  name           = "desafiodevops-dev"
  plan           = "small"
  platform       = "static"
  team_owner     = "infravideos"
  description    = "APP de teste"
  pool           = "dev"
  default_router = "galeb_dev"
}

resource "tsuru_service_instance_bind" "desafiodevops-dev-rpaasv2-be-rjdev" {
 app              = tsuru_app.desafiodevops-dev.name
 service_name     = "rpaasv2-be-rjdev"
 service_instance = "desafiodevops-rpaas-be-dev"
}