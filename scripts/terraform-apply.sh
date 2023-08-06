#!/bin/bash

set -o pipefail
set -e

# Script to run Terraform apply in a specific directory
# Usage: ./terraform-apply.sh <directory_path>

if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory_path>"
  exit 1
fi

terraform_working_dir="$1"

terraform -chdir="$1" apply -input=false -no-color -auto-approve| \
  sed -e 's/AWS_SECRET_ACCESS_KEY".*/<REDACTED>/g' \
      -e 's/AWS_ACCESS_KEY_ID".*/<REDACTED>/g' \
      -e 's/$AWS_SECRET_ACCESS_KEY".*/<REDACTED>/g' \
      -e 's/$AWS_ACCESS_KEY_ID".*/<REDACTED>/g' \
      -e 's/\[id=.*\]/\[id=<REDACTED>\]/g'
