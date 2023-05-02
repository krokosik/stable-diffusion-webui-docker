FROM alpine/git:2.36.2 as download

COPY clone.sh /clone.sh

RUN . /clone.sh deflicker https://github.com/ChenyangLEI/All-in-one-Deflicker 9257e66433b2869adb8ec779b80d8219109f34fc
RUN . /clone.sh deflicker_weigths https://github.com/ChenyangLEI/cvpr2023_deflicker_public_folder 63f5c0db8d3e00dce9565c9825932788496d4b88

FROM continuumio/miniconda3:22.11.1

RUN apt-get update && apt-get install ffmpeg libsm6 libxext6 -y

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

COPY --from=download /repositories/ /repositories/

RUN cp -rf /repositories/deflicker_weigths/pretrained_weights /repositories/deflicker/

ENV ROOT=/repositories/deflicker

RUN --mount=type=cache,target=/opt/conda/pkgs \
    conda env create -f ${ROOT}/environment.yml

RUN echo "conda activate deflicker" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

COPY . /docker

WORKDIR ${ROOT}
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all
ENV CLI_ARGS=""
ENV PYTHONPATH=${ROOT}
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python test.py ${CLI_ARGS}