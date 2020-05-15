# Centos 7 Alternative Container

The build files here provide an example on how to build a Centos 7 Driverless AI container without Python2. Note that by removing Python 2 from the container, yum will be broken. As such, the removal of Python 2 is performed in the last layer of the image.

## How To Build

You can then build the image by running the following command:

```
make runtime-centos7
```