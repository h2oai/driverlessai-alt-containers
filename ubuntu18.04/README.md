# Ubuntu 18.04 Alternative Container

## How Build

In order to build this alternative image, you'll first need to have the URL for downloading the `jdk1.8.0_144.jar` artifact handy. You can then build the image by running the following command:

```
make JDL_URL="[JDK URL]" runtime-ubuntu18.04
```

## Enabling GPU

In order for the Driverless AI container to use the GPUs available on your system, you will need to have NVIDIA drivers >= 410 installed on the host. You'll also have to have `nvidia-container-runtime` installed. In order to install `nvidia-container-runtime`, please run the `enable_gpu.sh` script.

Once `nvidia-container-runtime` is installed, you will need to add `--runtime=nvidia` when running `docker run ...` command to start the container. You may also use the `NVIDIA_VISIBLE_DEVICES` environment variable to specify what GPU to make visible to the container by adding it to the `docker run ...` command as well. For example:

```
docker run --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES="0" ...
```

will only make GPU #0 available to the container.
