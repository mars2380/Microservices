#!/bin/bash
function install {
	CKECK=$(terraform --version)
	if [ ! -z "$CKECK" ]; then
		echo "Terraform is installed"
		sleep 3
	else
		echo "NO"
		wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
		unzip terraform_0.11.7_linux_amd64.zip
		rm terraform_0.11.7_linux_amd64.zip
		export PATH=$PATH:$(pwd)
	fi
}

install

terraform init Terraform/
terraform plan Terraform/
terraform apply -auto-approve
