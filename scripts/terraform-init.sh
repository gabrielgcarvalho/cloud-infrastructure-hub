#!/bin/bash

# Script to run Terraform init in a specific directory
# Usage: ./terraform-init.sh <directory_path>

if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory_path>"
  exit 1
fi

terraform_working_dir="$1"

terraform -chdir="${terraform_working_dir}" init -input=false -no-color