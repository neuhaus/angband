# Angband in the browser

This directory holds the [unix-tui-to-wasm](../unix-tui-to-wasm) runtime used
by the WebAssembly build of Angband's text (GCU) front end.  The game is
rendered through an xterm.js terminal and input goes through xterm-pty; the
runtime's minimal curses layer (`curses/`) implements the curses calls used by
`src/main-gcu.c`.

## Build

```sh
# Emscripten (the runtime is pinned to the version in wasm/emsdk-version)
source /path/to/emsdk/emsdk_env.sh
./wasm/build-wasm.sh
```

The build was verified with Emscripten 6.0.12.  If your active SDK differs from
the pinned version, set `ALLOW_UNTESTED_EMSDK=1` as the runtime's build script
suggests.

The build system detects Emscripten, enables `SUPPORT_GCU_FRONTEND`, and uses
`UTW_CURSES`; no extra CMake options are needed.  The servable bundle is
written to `build/web`:

```sh
cd build/web
python3 -m http.server 8000
# http://localhost:8000/
```

## Data and saves

`lib/gamedata`, `lib/help`, `lib/screens` and `lib/customize` are preloaded
read-only at `/lib`.  Player state (saves, scores, user prefs) is written to
`/data`, which the runtime mounts on IndexedDB, so it survives a page reload.

The terminal is fixed at 100x30 (`UTW_COLS`/`UTW_ROWS` in `CMakeLists.txt`).
