#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
node --test test-worker/*.test.mjs
node scripts/test-voice-pipeline.cjs
bash scripts/voice-pipeline.sh
flutter analyze
flutter test
