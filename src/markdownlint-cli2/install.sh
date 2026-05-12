#!/usr/bin/env bash
set -e

MARKDOWNLINT_CLI2_VERSION=${VERSION:-"latest"}

if ! command -v npm > /dev/null; then
  echo "ERROR: npm is not available. Please include a Node.js feature (>= 20) in your devcontainer.json."
  exit 1
fi

NODE_MAJOR=$(node --version | sed 's/v//' | cut -d. -f1)
if [ "${NODE_MAJOR}" -lt 20 ]; then
  echo "ERROR: Node.js >= 20 is required (found $(node --version)). markdownlint-cli2 uses the /v regex flag introduced in Node 20."
  exit 1
fi

echo "Installing markdownlint-cli2 ${MARKDOWNLINT_CLI2_VERSION}..."
npm install -g "markdownlint-cli2@${MARKDOWNLINT_CLI2_VERSION}"

echo "Done. $(markdownlint-cli2 --version)"
