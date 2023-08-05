#!/bin/bash

set -o pipefail
set -e

# Script to run Terraform plan in a specific directory
# Usage: ./terraform-plan.sh <directory_path>

if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory_path>"
  exit 1
fi

terraform_working_dir="$1"

terraform -chdir="${terraform_working_dir}" plan -input=false -no-color | \
  sed -e 's/AWS_SECRET_ACCESS_KEY".*/<REDACTED>/g' \
      -e 's/AWS_ACCESS_KEY_ID".*/<REDACTED>/g' \
      -e 's/$AWS_SECRET_ACCESS_KEY".*/<REDACTED>/g' \
      -e 's/$AWS_ACCESS_KEY_ID".*/<REDACTED>/g' \
      -e 's/\[id=.*\]/\[id=<REDACTED>\]/g' | tee /dev/stderr | grep '^Plan: \|^No changes.'
