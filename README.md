# Docker image to deploy an alpaca-cpp container with conda-ready environments 

## Requirements

1. You have gnu/linux
2. You have docker engine installed
3. You have an NVIDIA gpu

## Preliminary steps

Please, install the NVIDIA Container Toolkit following [this guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html).

## To build the container 

```bash
chmod +x build start stop rm
```

```bash
./build
```

## To start the container 

```bash
./start
```

## To connect locally

```bash
docker container attach alpaca-cpp-container
```

## To connect remotly thorugh SSH

```bash
ssh 
```

## To stop the container running

```bash
./stop
```
