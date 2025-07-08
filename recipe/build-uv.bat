@echo on

set CARGO_PROFILE_RELEASE_STRIP=symbols

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation

cargo-bundle-licenses ^
    --format yaml ^
    --output "%SRC_DIR%\THIRDPARTY.yml" ^
    || exit 3
