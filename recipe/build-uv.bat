@echo on

cd crates\uv

cargo install ^
    --no-track ^
    --locked ^
    --path . ^
    --profile release ^
    --root "%LIBRARY_PREFIX%" ^
    || exit 1

cargo-bundle-licenses ^
    --format yaml ^
    --output "%SRC_DIR%\THIRDPARTY.yml" ^
    || exit 3

md ^
    "%LIBRARY_PREFIX%\share\bash-completion\completions" ^
    "%LIBRARY_PREFIX%\share\fish\vendor_completions.d" ^
    "%LIBRARY_PREFIX%\share\zsh\site-functions" ^
    || exit 4

"%LIBRARY_BIN%\uv.exe" generate-shell-completion bash > "%LIBRARY_PREFIX%\share\bash-completion\completions\uv" ^
    || exit 5
"%LIBRARY_BIN%\uv.exe" generate-shell-completion fish > "%LIBRARY_PREFIX%\share\fish\vendor_completions.d\uv.fish" ^
    || exit 6
"%LIBRARY_BIN%\uv.exe" generate-shell-completion zsh  > "%LIBRARY_PREFIX%\share\zsh\site-functions\uv" ^
    || exit 7
