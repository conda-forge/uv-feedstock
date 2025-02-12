#!/usr/bin/env bash
set -eux

export CARGO_PROFILE_RELEASE_STRIP=symbols

# Use jemalloc on linux-aarch64 and linux-ppc64le
if [[ "${target_platform}" == "linux-aarch64" || "${target_platform}" == "linux-ppc64le" ]]; then
  export JEMALLOC_SYS_WITH_LG_PAGE=16
fi

# use lld on osx
if [[ "${target_platform}" == osx-* ]]; then
  export CMAKE_LINKER_TYPE="LLD"
else
  export CMAKE_LINKER_TYPE="DEFAULT"
fi

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
