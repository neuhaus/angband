# Angband in the browser

The WebAssembly build of Angband's text (GCU) front end uses the
[unix-tui-to-wasm](https://github.com/neuhaus/unix-tui-to-wasm) runtime,
checked out at `wasm/utw`.  The game is rendered through an xterm.js terminal
and input goes through xterm-pty; curses calls from `src/main-gcu.c` are served
by PDCursesMod's VT port (`wasm/utw/wasm/PDCursesMod`, a nested submodule),
which emits the ANSI sequences xterm.js understands.

## Build

```sh
# Emscripten (the runtime is pinned to the version in wasm/utw/wasm/emsdk-version)
source /path/to/emsdk/emsdk_env.sh
./wasm/build-wasm.sh
```

`wasm/build-wasm.sh` only sets `ROOT` and runs the runtime's build script.
That script initializes both submodule levels if needed and is pinned to and
verified with Emscripten 7.0.0.  If your active SDK differs from the pinned
version, set `ALLOW_UNTESTED_EMSDK=1` as the script suggests.

The build system detects Emscripten, enables `SUPPORT_GCU_FRONTEND`, and uses
`UTW_CURSES=pdcurses`; no extra CMake options are needed.  The servable bundle
is written to `build/web`:

```sh
cd build/web
python3 -m http.server 8000
# http://localhost:8000/
```

## Data and saves

`lib/gamedata`, `lib/help`, `lib/screens` and `lib/customize` are preloaded
read-only at `/lib`.  Player state (saves, scores, user prefs) is written to
`/data`, which the runtime mounts on IndexedDB, so it survives a page reload.

The terminal defaults to 100x30 (`UTW_COLS`/`UTW_ROWS` in `CMakeLists.txt`).
It can be chosen per load with a URL fragment, without rebuilding:

```
http://localhost:8000/#cols=120&rows=40
```

Reload the page to change it.  Angband requires at least 80x24; smaller
values make it exit with its usual error message.
