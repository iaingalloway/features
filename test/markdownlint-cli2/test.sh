#!/bin/bash
set -e

source dev-container-features-test-lib

check "markdownlint-cli2 version" markdownlint-cli2 --version

reportResults
