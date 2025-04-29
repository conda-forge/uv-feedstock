#!/usr/bin/env bash
set -eux

export CARGO_PROFILE_RELEASE_STRIP=symbols

cd crates/uv

cargo install \
  --no-track \
  --locked \
  --path . \
  --profile release \
  --root "${PREFIX}"

cargo-bundle-licenses \
  --format yaml \
  --output "${SRC_DIR}/THIRDPARTY.yml"
