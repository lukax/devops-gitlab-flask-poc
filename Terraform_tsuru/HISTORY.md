# First steps and an overview to get up and running in tsuru and terraform

# 0 setup tsuru
tsuru target-remove default
tsuru target-add default https://tsuru.globoi.com -s
tsuru login  

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

# install rpaasv2 plugin
( set -eu -o pipefail \
&& mkdir -p ~/.tsuru/plugins \
&& version=$(curl -fsSL https://api.github.com/repos/tsuru/rpaas-operator/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') \
&& curl -fsSL "https://github.com/tsuru/rpaas-operator/releases/download/v${version}/rpaasv2_${version}_$(uname -s)_$(uname -m).tar.gz" \
|  tar -C ~/.tsuru/plugins -xzf- rpaasv2 \
&& echo -e 'rpaasv2 plugin successfully installed!\nYou can use it by issuing "tsuru rpaasv2 -h" right now.' \
|| echo 'failed to install rpaasv2 plugin... try again later' && false )

# checkout RPaaS service info
tsuru rpaasv2 info -s rpaasv2-be-rjdev -i desafiodevops-rpaas-be-dev

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

# connect to rpaas shell
tsuru rpaasv2 shell -s rpaasv2-be-rjdev -i desafiodevops-rpaas-be-dev

# connect to app container shell
tsuru app shell -a desafiodevops-dev

# test the app through RPaaS instance
APP_URL=http://desafiodevops-rpaas-be-dev-service.rpaasv2-be-rjdev.rpaas.tsuru.dev.globoi.com ../../tests/api_tests.sh