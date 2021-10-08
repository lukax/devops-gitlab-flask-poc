terraform {
  backend "s3" {
    bucket         = "tsuru-gcp-tfstates"
    key            = "rpaas/dev/FE/rpaasv2-FE_desafiodevops-dev-tests/terraform.tfstate"
    dynamodb_table = "tsuru-gcp-tfstates"
    region         = "sa-east-1"
    encrypt        = true
  }
}
