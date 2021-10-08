terraform {
  backend "s3" {
    bucket         = "tsuru-gcp-tfstates"
    key            = "rpaas/dev/BE/rpaasv2-BE_desafiodevops-dev-tests/terraform.tfstate"
    dynamodb_table = "tsuru-gcp-tfstates"
    region         = "sa-east-1"
    encrypt        = true
  }
}
