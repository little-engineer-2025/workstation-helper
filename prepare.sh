#!/bin/bash

set -e

for item in ./prepare.d/*.sh; do
  echo -e "\n>> Processing '${item}'"
  source "${item}"
done

cat <<EOF
Manual tasks:
- Add `proxy=http://127.0.0.1:3128` at /etc/yum.repos.d/*.repo files.
- Add `protocol=https` at /etc/yum.repos.d/*.repo files.
EOF
