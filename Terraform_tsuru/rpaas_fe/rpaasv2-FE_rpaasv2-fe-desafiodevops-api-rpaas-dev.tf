data "tsuru_app" "desafiodevops-dev" {
  name = "desafiodevops-dev"
}

resource "tsuru_service_instance" "this" {
  name         = "desafiodevops-rpaas-fe-dev"
  service_name = "rpaasv2-fe-rjdev"
  description  = ""
  owner        = "infravideos"
  plan         = ""
  tags         = []
  parameters   = {}
}
resource "rpaas_route" "this" {
  depends_on   = [tsuru_service_instance.this]
  service_name = "rpaasv2-fe-rjdev"
  instance     = "desafiodevops-rpaas-fe-dev"
  path         = "/"
  content      = <<EOT
location / {
  proxy_buffer_size     6k;
  proxy_set_header Connection "";
  proxy_http_version 1.1;
  proxy_cache_lock on;
  proxy_cache_background_update on;
  proxy_pass            http://desafiodevops_dev$request_uri;
  proxy_set_header Host "desafiodevops-dev.gcloud.dev.globoi.com";
  break;
}
	EOT
}
# adicionado proxy_set_header host para o router nao ficar perdido

resource "rpaas_block" "this" {
  depends_on   = [tsuru_service_instance.this]
  service_name = "rpaasv2-fe-rjdev"
  instance     = "desafiodevops-rpaas-fe-dev"
  name         = "http"
  content      = <<EOT
upstream desafiodevops_dev {
    server desafiodevops-dev.gcloud.dev.globoi.com fail_timeout=2s max_fails=0 weight=1;
    keepalive 100;
}

  EOT

}