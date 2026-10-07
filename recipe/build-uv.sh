#!/usr/bin/env bash
set -eux

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
