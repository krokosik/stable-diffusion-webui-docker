#!/bin/bash

set -Eeuo pipefail

declare -A MOUNTS

MOUNTS["/root/.cache"]="/data/.cache"

# main
MOUNTS["${ROOT}/models/checkpoints"]="/data/StableDiffusion"
MOUNTS["${ROOT}/models/vae"]="/data/VAE"
MOUNTS["${ROOT}/models/Codeformer"]="/data/Codeformer"
MOUNTS["${ROOT}/models/upscale_models"]="/data/GFPGAN"
MOUNTS["${ROOT}/models/upscale_models"]="/data/ESRGAN"
MOUNTS["${ROOT}/models/upscale_models"]="/data/BSRGAN"
MOUNTS["${ROOT}/models/upscale_models"]="/data/RealESRGAN"
MOUNTS["${ROOT}/models/upscale_models"]="/data/SwinIR"
MOUNTS["${ROOT}/models/upscale_models"]="/data/ScuNET"
MOUNTS["${ROOT}/models/upscale_models"]="/data/LDSR"
MOUNTS["${ROOT}/models/hypernetworks"]="/data/Hypernetworks"
MOUNTS["${ROOT}/models/torch_deepdanbooru"]="/data/Deepdanbooru"
MOUNTS["${ROOT}/models/clip"]="/data/BLIP"
MOUNTS["${ROOT}/models/midas"]="/data/MiDaS"
MOUNTS["${ROOT}/models/loras"]="/data/Lora"
MOUNTS["${ROOT}/models/controlnet"]="/data/ControlNet"

MOUNTS["${ROOT}/models/embeddings"]="/data/embeddings"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

if [ -f "/data/config/auto/startup.sh" ]; then
  pushd ${ROOT}
  . /data/config/auto/startup.sh
  popd
fi

exec "$@"
