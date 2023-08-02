#!/bin/sh

tflint_exitcode=0
tflint_output=""

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

    # Run tflint on the current directory and capture the output
    tflint_output_current=$(tflint --config "$tflint_config" --chdir "$terraform_working_dir" 2>&1)
    
    # Add the tflint output to the variable
    tflint_output+="\n\n<details><summary>:mag: TFLint Output for ${directory}</summary>\n\n\`\`\`hcl\n${tflint_output_current}\n\`\`\`\n</details>"

    tflint_exitcode=$((tflint_exitcode + $?))
    echo "tflint_exitcode=${tflint_exitcode}"
done

if [ $tflint_exitcode -eq 0 ]; then
  TFLINT_STATUS=":white_check_mark: Success"
else
  TFLINT_STATUS=":x: Failed"
fi

if [ "${GITHUB_EVENT_NAME}" = "pull_request" ] && [ -n "${GITHUB_TOKEN}" ]; then
    COMMENT="## :hammer_and_wrench: Terraform Static Analysis - TFLint Scan Status: ${TFLINT_STATUS}
${tflint_output}"
    echo $COMMENT
    PAYLOAD=$(echo "${COMMENT}" | jq -R --slurp '{body: .}' -c)
    URL=$(jq -r .pull_request.comments_url "${GITHUB_EVENT_PATH}")
    echo "${PAYLOAD}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" -H "Content-Type: application/json" -d @- "${URL}" > /dev/null
fi
