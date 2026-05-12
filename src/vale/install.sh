#!/usr/bin/env bash
set -e

VALE_VERSION=${VERSION:-"latest"}

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

if [ "${VALE_VERSION}" = "latest" ]; then
  VALE_VERSION=$(curl -fsSL -o /dev/null -w "%{url_effective}" "https://github.com/vale-cli/vale/releases/latest" | sed 's|.*/tag/||')
fi

# Vale tags use v prefix; filenames use bare version number
VERSION_NUM="${VALE_VERSION#v}"
VERSION_TAG="v${VERSION_NUM}"

echo "Installing Vale ${VALE_VERSION}..."

ARCH=$(uname -m)
case "${ARCH}" in
  x86_64)  ARCH_STR="64-bit" ;;
  aarch64) ARCH_STR="arm64" ;;
  *)
    echo "Unsupported architecture: ${ARCH}"
    exit 1
    ;;
esac

TARBALL="vale_${VERSION_NUM}_Linux_${ARCH_STR}.tar.gz"
CHECKSUMS="vale_${VERSION_NUM}_checksums.txt"
BASE_URL="https://github.com/vale-cli/vale/releases/download/${VERSION_TAG}"

echo "Downloading ${TARBALL}..."
curl -fsSL -o "/tmp/${TARBALL}" "${BASE_URL}/${TARBALL}"
curl -fsSL -o "/tmp/${CHECKSUMS}" "${BASE_URL}/${CHECKSUMS}"

cd /tmp
grep "${TARBALL}" "/tmp/${CHECKSUMS}" | sha256sum -c -
cd /

mkdir -p /tmp/vale-extract
tar xf "/tmp/${TARBALL}" -C /tmp/vale-extract
mv /tmp/vale-extract/vale /usr/local/bin/vale
chmod +x /usr/local/bin/vale
rm -rf /tmp/vale-extract "/tmp/${TARBALL}" "/tmp/${CHECKSUMS}"

echo "Done. $(vale --version)"
