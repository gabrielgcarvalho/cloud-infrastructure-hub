#!/bin/bash

# Find and run Terratest tests recursively
for test_dir in $(find . -type d -name "*_test.go" -exec dirname {} \; | sort -u); do
    echo "Running tests in $test_dir"
    cd "$test_dir"
    test_output=$(go test -v 2>&1)
    test_exitcode=$?
    cd -

    # Append the test output to the comment
    COMMENT+="\n\n#### \`Terratest Output for ${test_dir}\`\n\`\`\`\n${test_output}\n\`\`\`"

    # If test exit code is non-zero, mark the overall status as failed
    if [ $test_exitcode -ne 0 ]; then
        TERRATEST_STATUS=":x: Failed"
    fi
done

# Set success status if no failures occurred
if [ -z "$TERRATEST_STATUS" ]; then
    TERRATEST_STATUS=":white_check_mark: Success"
fi

if [ "${GITHUB_EVENT_NAME}" = "pull_request" ] && [ -n "${GITHUB_TOKEN}" ]; then
    COMMENT="## \`Terratest Test Results\`
#### TERRATEST SCAN STATUS: ${TERRATEST_STATUS}
$COMMENT"

    PAYLOAD=$(echo "${COMMENT}" | jq -R --slurp '{body: .}' -c)
    URL=$(jq -r .pull_request.comments_url "$GITHUB_EVENT_PATH")
    echo "$PAYLOAD" | curl -s -S -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/json" -d @- "$URL" > /dev/null
fi
