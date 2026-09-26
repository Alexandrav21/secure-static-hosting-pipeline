#!/usr/bin/env bash

set -euo pipefail

site_dir="site"

if [ ! -d "$site_dir" ]; then
  echo "Site directory does not exist: $site_dir"
  exit 1
fi

if [ ! -f "$site_dir/index.html" ]; then
  echo "Required file is missing: $site_dir/index.html"
  exit 1
fi

if find "$site_dir" -type l | grep -q .; then
  echo "Symbolic links are not allowed in the site directory."
  exit 1
fi

if find "$site_dir" -type f \
  \( -name "*.pem" \
  -o -name "*.key" \
  -o -name "*.p12" \
  -o -name "*.pfx" \
  -o -name ".env" \) \
  | grep -q .; then
  echo "Potentially sensitive file found in site directory."
  exit 1
fi

echo "Site integrity checks passed."