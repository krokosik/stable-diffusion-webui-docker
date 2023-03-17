# syntax=docker/dockerfile:1

FROM alpine:3.17 as xformers
RUN apk add --no-cache aria2
RUN aria2c -x 5 --dir / --out wheel.whl 'https://github.com/AbdBarho/stable-diffusion-webui-docker/releases/download/5.0.0/xformers-0.0.17.dev449-cp310-cp310-manylinux2014_x86_64.whl'

FROM python:3.10.9-slim

SHELL ["/bin/bash", "-ceuxo", "pipefail"]

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN PIP_NO_CACHE_DIR=1 pip install torch==1.13.1 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117

RUN apt-get update && apt install fonts-dejavu-core rsync git jq moreutils ffmpeg -y && apt-get clean

RUN --mount=type=cache,target=/root/.cache/pip <<EOF
git clone https://github.com/comfyanonymous/ComfyUI
cd ComfyUI
pip install -r requirements.txt
EOF

RUN --mount=type=cache,target=/root/.cache/pip  \
    --mount=type=bind,from=xformers,source=/wheel.whl,target=/xformers-0.0.15-cp310-cp310-linux_x86_64.whl \
    pip install triton /xformers-0.0.15-cp310-cp310-linux_x86_64.whl

ENV ROOT=/ComfyUI

# Note: don't update the sha of previous versions because the install will take forever
# instead, update the repo state in a later step

ARG SHA=9613c725a82ad29f6f6633508642827c9d3438a7
RUN --mount=type=cache,target=/root/.cache/pip <<EOF
cd ComfyUI
git fetch
git reset --hard ${SHA}
pip install -r requirements.txt
EOF

COPY . /docker

WORKDIR ${ROOT}
ENV CLI_ARGS=""
EXPOSE 7860
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python -u main.py --listen --port 7860 ${CLI_ARGS}
