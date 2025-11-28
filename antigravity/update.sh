#!/usr/bin/env bash
set -e

VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

URL="https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/${VERSION}/linux-x64/Antigravity.tar.gz"

echo "Prefetching $URL..."
HASH=$(nix-prefetch-url "$URL")
SRI_HASH=$(nix hash to-sri --type sha256 "$HASH")

echo "Hash: $SRI_HASH"

# Update package.nix
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PACKAGE_FILE="$SCRIPT_DIR/package.nix"

sed -i "s/version = \".*\";/version = \"$VERSION\";/" "$PACKAGE_FILE"
sed -i "s/sha256 = \".*\";/sha256 = \"$SRI_HASH\";/" "$PACKAGE_FILE"

echo "Updated $PACKAGE_FILE to version $VERSION"
