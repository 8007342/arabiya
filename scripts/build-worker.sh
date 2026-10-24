#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
# A self-contained Worker also runs in Forge previews without host node_modules.
node_modules/.bin/esbuild worker/index.mjs --bundle --format=esm --platform=browser --outfile=build/worker/index.mjs
