#!/bin/bash
set -e

source dev-container-features-test-lib

check "gitversion version" gitversion /version

reportResults
