# First steps and an overview to get up and running in tsuru and terraform

# 1 create app
tsuru app-create desafio-devops static -o dev -t infravideos

# 2 build image
docker-compose -f docker-compose.yml build

# 3 push image
docker push docker-tsuru.artifactory.globoi.com/tsuru/desafio-devops:latest

# 4 deploy image
tsuru app deploy -i docker-tsuru.artifactory.globoi.com/tsuru/desafio-devops:latest -a desafio-devops

# 5 print info
tsuru app info --app desafio-devops

# 6 run tests
APP_URL=http://desafio-devops.gcloud.dev.globoi.com ./tests/api_tests.sh

# 7 setup terraform token
tsuru token show
export TF_VAR_host=https://tsuru.globoi.com
export TF_VAR_token=<token>

# 8 import AWS credentials: 
aws configure
##    AWS Access Key ID [None]: XXXXXXXXXXXXXXXXX
##    AWS Secret Access Key [None]: secr3t
##    Default region name [None]: us-west-2
##    Default output format [None]: json

# 9 terraform apply rpaas
cd ./rpaas 
terraform plan -out=tfplan
terraform apply tfplan

# 10 checkout service info
tsuru service instance info rpaasv2-be-rjdev desafiodevops-rpaas-be-dev

# 11 terraform apply app
cd ../app
terraform plan -out=tfplan
terraform apply tfplan

# 11 checkout app info
tsuru app info --app desafiodevops-dev

# 12 deploy app image 
tsuru app deploy -i docker-tsuru.artifactory.globoi.com/tsuru/desafio-devops:latest -a desafiodevops-dev

# 13 checkout app info again to see deployment status
tsuru app info --app desafiodevops-dev

# 14 run tests
APP_URL=http://desafiodevops-dev.gcloud.dev.globoi.com ../../tests/api_tests.sh
