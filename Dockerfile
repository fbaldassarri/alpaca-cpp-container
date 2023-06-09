# Dockerfile to deploy an alpaca-cpp container with conda-ready environments 

# docker pull continuumio/miniconda3:latest

ARG TAG=latest
FROM continuumio/miniconda3:$TAG 

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        git \
        locales \
        sudo \
        build-essential \
        dpkg-dev \
        wget \
        openssh-server \
        nano \
    && rm -rf /var/lib/apt/lists/*

# Setting up locales

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# SSH exposition

EXPOSE 22/tcp
RUN service ssh start

# Create user

RUN groupadd --gid 1020 alpaca-cpp-group
RUN useradd -rm -d /home/alpaca-cpp-home -s /bin/bash -G users,sudo,alpaca-cpp-group -u 1000 alpaca-cpp-user

# Update user password
RUN echo 'alpaca-cpp-user:admin' | chpasswd

# Updating conda to the latest version
RUN conda update conda -y

# Create virtalenv
RUN conda create -n alpacacpp -y python=3.10.6

# Adding ownership of /opt/conda to $user
RUN chown -R alpaca-cpp-user:users /opt/conda

# conda init bash for $user
RUN su - alpaca-cpp-user -c "conda init bash"

# conda activate alpacacpp env
RUN su - alpaca-cpp-user -c "echo \"conda activate alpacacpp\" >> ~/.bashrc "

# Download latest github/alpaca-cpp in alpaca.cpp directory and compile it
RUN su - alpaca-cpp-user -c "git clone https://github.com/antimatter15/alpaca.cpp ~/alpaca.cpp \
                            && cd ~/alpaca.cpp \
                            && make  \
                            && make chat "

# Download default testing model
RUN su - alpaca-cpp-user -c "cd ~/alpaca.cpp \ 
                            && wget https://huggingface.co/Sosaka/Alpaca-native-4bit-ggml/resolve/main/ggml-alpaca-7b-q4.bin "

# Preparing for login
ENV HOME /home/alpaca-cpp-home
WORKDIR ${HOME}/alpaca.cpp
USER alpaca-cpp-user
# CMD ["/bin/bash"] 
CMD ["/bin/bash", "-c", "~/alpaca.cpp/chat"] 
