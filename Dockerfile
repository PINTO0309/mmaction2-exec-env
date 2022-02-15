ARG PYTORCH="1.10.0"
ARG CUDA="11.3"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.1 7.5 8.6+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"
ARG PYTORCH="1.10.0"
ARG MMCUDA="113"
ARG MMCVFULL="1.4.4"
ARG USERNAME=user
ARG WKDIR=/home/${USERNAME}
WORKDIR ${WKDIR}

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        git ninja-build libglib2.0-0 \
        libsm6 libxrender-dev libxext6 \
        ffmpeg sudo wget nano python3-pip \
    && sed -i 's/# set linenumbers/set linenumbers/g' /etc/nanorc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install mmcv-full
RUN pip install mmcv-full==${MMCVFULL} \
-f https://download.openmmlab.com/mmcv/dist/cu${MMCUDA}/torch${PYTORCH}/index.html

# Install MMAction2
RUN conda clean --all
RUN git clone https://github.com/open-mmlab/mmaction2.git /mmaction2 \
    && cd /mmaction2 \
    && git checkout 93e001f4898eccf45103c3eb2ee6d01f8220aa67
WORKDIR /mmaction2
RUN mkdir -p /mmaction2/data
ENV FORCE_CUDA="1"
RUN pip3 install pip --upgrade \
    && pip install moviepy==1.0.3 \
    && pip install mmdet==2.21.0 \
    && pip install mmtrack==0.10.0 \
    && pip install mmpose==0.23.0 \
    && pip install cython==0.29.27 --no-cache-dir \
    && pip install onnx==1.10.2 \
    && pip install onnxruntime-gpu==1.10.0 \
    && pip install onnxruntime-extensions==0.4.2 \
    && pip install onnxoptimizer==0.2.6 \
    && pip install onnx-simplifier==0.3.6 \
    && pip install --no-cache-dir -e .

# Create a user who can sudo in the Docker container
RUN echo "root:root" | chpasswd \
    && adduser --disabled-password --gecos "" "${USERNAME}" \
    && echo "${USERNAME}:${USERNAME}" | chpasswd \
    && echo "%${USERNAME}    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}
USER ${USERNAME}
RUN sudo chown ${USERNAME}:${USERNAME} ${WKDIR} \
    && sudo chown -R ${USERNAME}:${USERNAME} /mmaction2