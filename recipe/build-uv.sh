#!/usr/bin/env bash
set -eux

echo "ensuring rust-version in Cargo.toml:#/workspace/package/rust-version is ${CBC_RUST_VERSION}"
CARGO_TOML_RUST_VERSION=$(grep -iE "rust-version = \".*\"" Cargo.toml)

if [[ "${CARGO_TOML_RUST_VERSION}" == "rust-version = \"${CBC_RUST_VERSION}\"" ]] ;
then
  echo "OK rust version in Cargo.toml and conda_build_config.yaml agree: ${CBC_RUST_VERSION}"
else
  echo "ERROR rust version unexpcted"
  echo "... please update recipe/conda_build_config.yaml#/rust_compiler_version"
  echo "    to match ${CARGO_TOML_RUST_VERSION}"
  exit 2
fi

export CARGO_PROFILE_RELEASE_STRIP=symbols

# see https://github.com/conda-forge/uv-feedstock/pull/202#issuecomment-2890816026
# if [[ "${target_platform}" == "linux-ppc64le" ]]; then
#   export CFLAGS="${CFLAGS//-fno-plt/}"
#   export CXXFLAGS="${CXXFLAGS//-fno-plt/}"
# fi

cd crates/uv

cargo install \
  --no-track \
  --locked \
  --path . \
  --profile release \
  --root "${PREFIX}" \
  || cargo install \
  --no-track \
  --locked \
  --path . \
  --profile release \
  --root "${PREFIX}"

cargo-bundle-licenses \
  --format yaml \
  --output "${SRC_DIR}/THIRDPARTY.yml"
