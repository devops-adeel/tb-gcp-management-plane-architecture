#!/bin/bash

set -euo pipefail

TERRAFORM_VERSION=0.14.6
TERRAGRUNT_VERSION=0.28.1

function setup {
  echo "Executing setup..."

  #install terragrunt
  wget -O /tmp/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_darwin_amd64
  chmod +x /tmp/terragrunt
  sudo mv /tmp/terragrunt /usr/local/bin
  terragrunt -version

  #install terraform
  wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_darwin_amd64.zip
  unzip -q /tmp/terraform.zip -d /tmp
  chmod +x /tmp/terraform
  sudo mv /tmp/terraform /usr/local/bin
  terraform --version
}

function bootstrap {
  echo "Executing bootstrap..."
}

function deployment {
  echo "Executing deployment..."
}

while (( "$#" )); do
  case "$1" in
    -s|--setup)
      setup
      shift
      ;;
    -b|--bootstrap)
      bootstrap
      shift
      ;;
    -d|--deployment)
      deployment
      shift
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    --*=|-*) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # unsupported positional arguments
      echo "Error: Unsupported positional argument $1" >&2
      shift
      ;;
  esac
done
