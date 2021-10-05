resource "tsuru_service_instance" "rpaasv2-be-desafiodevops-rpaas-be-dev" {
  name         = "desafiodevops-rpaas-be-dev"
  service_name = "rpaasv2-be-rjdev"
  description  = ""
  owner        = "infravideos"
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
  proxy_pass            http://desafiodevops_dev$request_uri;
  proxy_set_header Host "desafiodevops-dev.gcloud.dev.globoi.com";
  break;
}
	EOT
}
# adicionado proxy_set_header host para o router nao ficar perdido

resource "rpaas_block" "rpaasv2-be-desafiodevops-api-dev-rpaas-be-gcp-dev-http" {
  depends_on   = [tsuru_service_instance.rpaasv2-be-desafiodevops-rpaas-be-dev]
  service_name = "rpaasv2-be-rjdev"
  instance     = "desafiodevops-rpaas-be-dev"
  name         = "http"
  content      = <<EOT
upstream desafiodevops_dev {
    server desafiodevops-dev.gcloud.dev.globoi.com fail_timeout=2s max_fails=0 weight=1;
    keepalive 100;
}

  EOT

}