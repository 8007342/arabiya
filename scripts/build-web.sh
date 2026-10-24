#!/usr/bin/env bash
# @trace spec:cloud-edge-sync, spec:voice-canon
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

bash scripts/voice-pipeline.sh

flutter_version="$(tr -d '[:space:]' < .flutter-version)"
flutter_bin="$(command -v flutter || true)"
if [[ -n "$flutter_bin" ]]; then
  installed_version="$("$flutter_bin" --version --machine | node -e 'let data="";process.stdin.on("data",chunk=>data+=chunk);process.stdin.on("end",()=>console.log(JSON.parse(data).frameworkVersion));')"
else
  installed_version=""
fi

if [[ "$installed_version" != "$flutter_version" ]]; then
  sdk_dir="$PWD/.cache/flutter-$flutter_version"
  if [[ ! -x "$sdk_dir/bin/flutter" ]]; then
    mkdir -p .cache
    download_dir="$(mktemp -d "$PWD/.cache/flutter-download.XXXXXX")"
    trap 'rm -rf "$download_dir"' EXIT
    git clone --depth 1 --branch "$flutter_version" https://github.com/flutter/flutter.git "$download_dir/sdk"
    mv "$download_dir/sdk" "$sdk_dir"
  fi
  flutter_bin="$sdk_dir/bin/flutter"
fi

"$flutter_bin" config --no-analytics
"$flutter_bin" pub get --enforce-lockfile
"$flutter_bin" build web --release --base-href / --no-web-resources-cdn
