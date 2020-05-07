# Enable GPU

In order to be able to run the docker image with GPU capabalities, please apply these steps on the host:

```
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt-get update
sudo apt-get install nvidia-container-runtime
```

```
sudo tee /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
sudo pkill -SIGHUP dockerd
```

This will install `nvidia-container-runtime` which is required in order for the container to have GPU access. Once `nvidia-container-runtime` is installed, you will need to add `--runtime=nvidia` when running `docker run ...` command to start the container. You may also use the `NVIDIA_VISIBLE_DEVICES` environment variable to specify what GPU to make visible to the container by adding it to the `docker run ...` command as well. For example:

```
docker run --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES="0" ...
```

will only make GPU #0 available to the container.
