#!/usr/bin/env bash
# @trace spec:voice-canon
# Default is offline validation; synthesis is an explicit authoring operation.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
node scripts/voice-pipeline.cjs "$@"
