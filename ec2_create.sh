#!/bin/bash
function install_linux {
	CKECK=$(terraform --version)
	if [ ! -z "$CKECK" ]; then
		echo "Terraform is installed"
		sleep 3
	else
		echo "NO"
		wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
		unzip terraform_0.11.7_linux_amd64.zip
		rm terraform_*.zip
		export PATH=$PATH:$(pwd)
	fi
}

function install_mac {
	CKECK=$(terraform --version)
	if [ ! -z "$CKECK" ]; then
		echo "Terraform is installed"
		sleep 3
	else
		echo "NO"
		curl https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_darwin_amd64.zip -o terraform_0.7_linux_amd64.zip
		unzip terraform_0.11.7_linux_amd64.zip
		rm terraform_*.zip
	fi
}

oscheck="$(uname)"
if [[ "$oscheck" == "Linux" ]]; then
	install_linux
elif [[ "$oscheck" == "Darwin" ]]; then
	install_mac
else
	echo "No Linux or Apple"
fi

terraform init Terraform_/
terraform plan Terraform_/
terraform apply -auto-approve Terraform_/
