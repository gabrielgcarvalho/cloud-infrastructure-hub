#!/bin/sh

terraform_files=$(find . -type f -name "*.tf")

if [ -z "$terraform_files" ]; then
    echo "No Terraform files found."
    exit 0
fi

for file in $terraform_files; do
    echo "Checking $file"
    terraform fmt -check "$file"
done
