#!/bin/bash
set -e

source dev-container-features-test-lib

check "sval version" sval --version

reportResults
