#!/bin/bash

set -e

for item in ./prepare.d/*.sh; do
  echo -e "\n>> Processing '${item}'"
  source "${item}"
done
