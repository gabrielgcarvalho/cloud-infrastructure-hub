#!/bin/bash

plan_out=""

# Identify which Terraform directories have changes 
directories=`git diff-tree --no-commit-id --name-only -r @^ | awk '{print $1}' | grep '\.tf' | sed 's#/[^/]*$##' | grep -v '\.tf' | uniq`
echo
echo "TF directories with changes"
echo $directories

git config --global --add safe.directory /github/workspace

for directory in $directories; do
    echo
    echo "Running terraform in ${directory}"

    # Set the working directory
    terraform_working_dir="${GITHUB_WORKSPACE}/${directory}"

    terraform -chdir="${terraform_working_dir}" init -input=false -no-color
    current_plan_out=`terraform -chdir="${terraform_working_dir}" plan -input=false -no-color | sed -e 's/AWS_SECRET_ACCESS_KEY".*/<REDACTED>/g' \
    -e 's/AWS_ACCESS_KEY_ID".*/<REDACTED>/g' \
    -e 's/$AWS_SECRET_ACCESS_KEY".*/<REDACTED>/g' \
    -e 's/$AWS_ACCESS_KEY_ID".*/<REDACTED>/g' \
    -e 's/\[id=.*\]/\[id=<REDACTED>\]/g' | tee /dev/stderr | grep '^Plan: \|^No changes.'`

    plan_out = "${plan_out} <br> <strong>Plan for ${terraform_working_dir}<strong> <br> ${current_plan_out} <br>"
    echo $plan_out
done

if [ "${GITHUB_EVENT_NAME}" == "pull_request" ] && [ -n "${GITHUB_TOKEN}" ]; then
    COMMENT="## 📝 Terraform Plan <br>
${plan_out}"

    PAYLOAD=$(echo "${COMMENT}" | jq -R --slurp '{body: .}' -c)
    URL=$(jq -r .pull_request.comments_url "${GITHUB_EVENT_PATH}")
    echo "${PAYLOAD}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" -H "Content-Type: application/json" -d @- "${URL}" > /dev/null
fi

