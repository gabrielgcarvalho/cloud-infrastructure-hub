#!/bin/bash

# Script to comment pr
# Usage: ./comment-pr.sh <comment>

if [ $# -ne 1 ]; then
  echo "Usage: $0 <comment>"
  exit 1
fi

COMMENT="$1"

PAYLOAD=$(echo "${COMMENT}" | jq -R --slurp '{body: .}' -c)
URL=$(jq -r .pull_request.comments_url "${GITHUB_EVENT_PATH}")
echo "${PAYLOAD}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" -H "Content-Type: application/json" -d @- "${URL}" > /dev/null