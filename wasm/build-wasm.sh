#!/bin/sh
# Build the Angband browser bundle with the unix-tui-to-wasm runtime in
# wasm/utw (a submodule).  Set WEB_DIR or OBJ_DIR to relocate the output.
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export ROOT

exec "$ROOT/wasm/utw/wasm/build-wasm.sh" "$@"
