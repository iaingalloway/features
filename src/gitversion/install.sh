#!/usr/bin/env bash
set -e

GITVERSION_VERSION=${VERSION:-"latest"}

install_packages() {
  apt-get update -y
  apt-get install -y --no-install-recommends "$@"
}

if ! command -v curl > /dev/null; then
  install_packages curl ca-certificates
fi

if ! command -v tar > /dev/null; then
  install_packages tar
fi

if [ "${GITVERSION_VERSION}" = "latest" ]; then
  GITVERSION_VERSION=$(curl -fsSL -o /dev/null -w "%{url_effective}" "https://github.com/GitTools/GitVersion/releases/latest" | sed 's|.*/tag/||')
fi

# GitVersion download URLs use bare version numbers (no v prefix)
GITVERSION_VERSION="${GITVERSION_VERSION#v}"

echo "Installing GitVersion ${GITVERSION_VERSION}..."

ARCH=$(uname -m)
case "${ARCH}" in
  x86_64)  ARCH_STR="x64" ;;
  aarch64) ARCH_STR="arm64" ;;
  *)
    echo "Unsupported architecture: ${ARCH}"
    exit 1
    ;;
esac

PLATFORM="linux"

TARBALL="gitversion-${PLATFORM}-${ARCH_STR}-${GITVERSION_VERSION}.tar.gz"
URL="https://github.com/GitTools/GitVersion/releases/download/${GITVERSION_VERSION}/${TARBALL}"

echo "Downloading ${URL}..."
curl -fsSL -o "/tmp/${TARBALL}" "${URL}"

mkdir -p /tmp/gitversion-extract
tar xf "/tmp/${TARBALL}" -C /tmp/gitversion-extract
mv /tmp/gitversion-extract/gitversion /usr/local/bin/gitversion
chmod 755 /usr/local/bin/gitversion
rm -rf /tmp/gitversion-extract "/tmp/${TARBALL}"

echo "Done. $(gitversion /version)"
