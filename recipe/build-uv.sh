#!/usr/bin/env bash
set -eux

# see https://github.com/conda-forge/uv-feedstock/pull/202#issuecomment-2890816026
if [[ "${target_platform}" == "linux-ppc64le" ]]; then
  export CARGO_TARGET_POWERPC64LE_UNKNOWN_LINUX_GNU_LINKER="${CC}"
  export CFLAGS="${CFLAGS//-fno-plt/}"
  export CXXFLAGS="${CXXFLAGS//-fno-plt/}"
fi

if [[ "${target_platform}" == "linux-riscv64" ]]; then
  export CARGO_TARGET_RISCV64GC_UNKNOWN_LINUX_GNU_LINKER="${CC}"
  # Conda .pc files already contain the relocated host prefix.
  unset PKG_CONFIG_SYSROOT_DIR
  export PKG_CONFIG_ALLOW_CROSS=1
  export PKG_CONFIG_LIBDIR="${PREFIX}/lib/pkgconfig"
  export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig"
fi

cd crates/uv

cargo auditable install \
  --no-track \
  --locked \
  --path . \
  --profile release \
  --root "${PREFIX}"

cargo-bundle-licenses \
  --format yaml \
  --output "${SRC_DIR}/THIRDPARTY.yml"

if [[ "${target_platform}" == "${build_platform}" ]]; then
  mkdir -p \
    "${PREFIX}/share/bash-completion/completions" \
    "${PREFIX}/share/fish/vendor_completions.d" \
    "${PREFIX}/share/zsh/site-functions"

  "${PREFIX}/bin/uv" generate-shell-completion bash \
    > "${PREFIX}/share/bash-completion/completions/uv"
  "${PREFIX}/bin/uv" generate-shell-completion fish \
    > "${PREFIX}/share/fish/vendor_completions.d/uv.fish"
  "${PREFIX}/bin/uv" generate-shell-completion zsh \
    > "${PREFIX}/share/zsh/site-functions/_uv"
fi
