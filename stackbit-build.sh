#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5dcde80a290dfb001aeb9d38/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5dcde80a290dfb001aeb9d38 
fi
curl -s -X POST https://api.stackbit.com/project/5dcde80a290dfb001aeb9d38/webhook/build/ssgbuild > /dev/null
bundle install && bundle exec jekyll build
./inject-netlify-identity-widget.js _site
curl -s -X POST https://api.stackbit.com/project/5dcde80a290dfb001aeb9d38/webhook/build/publish > /dev/null
