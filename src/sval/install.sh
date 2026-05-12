#!/usr/bin/env bash
set -e

SVAL_VERSION=${VERSION:-"latest"}

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

if [ "${SVAL_VERSION}" = "latest" ]; then
  SVAL_VERSION=$(curl -fsSL -o /dev/null -w "%{url_effective}" "https://github.com/iaingalloway/sval/releases/latest" | sed 's|.*/tag/||')
fi

# Download URL tag uses v-prefix; tarball filename uses bare version
SVAL_VERSION_TAG="v${SVAL_VERSION#v}"
SVAL_VERSION_NUM="${SVAL_VERSION#v}"

echo "Installing sval ${SVAL_VERSION_TAG}..."

ARCH=$(uname -m)
case "${ARCH}" in
  x86_64)  ARCH_STR="amd64" ;;
  aarch64) ARCH_STR="arm64" ;;
  *)
    echo "Unsupported architecture: ${ARCH}"
    exit 1
    ;;
esac

TARBALL="sval-${SVAL_VERSION_NUM}-linux-${ARCH_STR}.tar.gz"
URL="https://github.com/iaingalloway/sval/releases/download/${SVAL_VERSION_TAG}/${TARBALL}"

echo "Downloading ${URL}..."
curl -fsSL -o "/tmp/${TARBALL}" "${URL}"

mkdir -p /tmp/sval-extract
tar xf "/tmp/${TARBALL}" -C /tmp/sval-extract
mv /tmp/sval-extract/sval /usr/local/bin/sval
chmod +x /usr/local/bin/sval
rm -rf /tmp/sval-extract "/tmp/${TARBALL}"

echo "Done. $(sval --version)"
