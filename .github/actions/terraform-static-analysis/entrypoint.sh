#!/bin/sh

# Get a list of all terraform directories in the repo
directories=$(find . -type f -name '*.tf' | sed 's#/[^/]*$##' | sed 's/.\///' | sort | uniq)
echo
echo "All TF directories"
echo $directories

# TF Lint Configuration
tflint_config="/tflint-configs/tflint.aws.hcl"

echo "Running tflint --init..."
tflint --init --config "$tflint_config"

# Loop through each Terraform directory
for directory in $directories; do
    echo
    echo "Running tflint in ${directory}"
    
    # Set the working directory for tflint
    terraform_working_dir="${GITHUB_WORKSPACE}/${directory}"
    
    # Run tflint on the current directory
    tflint --config "$tflint_config" --chdir "$terraform_working_dir" 2>&1
done
