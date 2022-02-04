FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04 as stage0

COPY dai.deb /

RUN \
    apt-get update && \
    apt-get install -y \
        syslog-ng

RUN \
    dpkg -i /dai.deb && \
    rm -fr /dai.deb && \
    rm -rf /opt/h2oai/dai/lib/cuda-11.2 && \
    echo "docker" > /opt/h2oai/dai/metadata/package_type && \
    rm -rf /opt/h2oai/dai/tmp && \
    ln -s /tmp /opt/h2oai/dai/tmp && \
    rm -rf /opt/h2oai/dai/log && \
    ln -s /log /opt/h2oai/dai/log && \
    chmod -R a-w /opt/h2oai/dai/python && \
    chmod -R a-w /opt/h2oai/dai/cuda-11.2 && \
    chmod -R a-w /opt/h2oai/dai/cpu-only && \
    chmod -R o+rwx /opt/h2oai/dai/home && \
    mkdir -p /opt/h2oai/dai/redis-data && \
    chmod -R o+rwx /opt/h2oai/dai/redis-data && \
    mkdir -p /opt/h2oai/dai/minio-data && \
    chmod -R o+rwx /opt/h2oai/dai/minio-data

FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04 as stage1
RUN mkdir -p /opt/
COPY --from=stage0 /opt/ /opt/
RUN mkdir -p /etc/dai/
COPY --from=stage0 /etc/dai/ /etc/dai/
RUN mkdir -p /usr/lib/systemd/system/
COPY --from=stage0 /usr/lib/systemd/system/ /usr/lib/systemd/system/

ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && \
    apt-get install -y \
        curl \
        less \
        wget \
        graphviz \
        gcc \
        locales \
        unzip \
        syslog-ng \
        libncursesw5 \
        ocl-icd-libopencl1 \
        clinfo && \
    rm -rf /var/lib/apt/lists/*

RUN \
    bash -c \
        'if [ `arch` = "x86_64" ]; then \
             mkdir -p /etc/OpenCL/vendors && \
             echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd; \
         fi'

# Set locale
ENV LANGUAGE=en_US.utf8 LANG=en_US.utf8

RUN locale-gen en_US.utf8 \
 && dpkg-reconfigure locales

RUN \
    set -ex && \
    echo "docker" > /opt/h2oai/dai/metadata/package_type && \
    rm -rf /opt/h2oai/dai/tmp && \
    ln -s /tmp /opt/h2oai/dai/tmp && \
    mkdir /log && \
    chmod -R o+w /log && \
    rm -rf /opt/h2oai/dai/log && \
    ln -s /log /opt/h2oai/dai/log

# Make a default directory where license files can be stored inside the container.
# To make these persist across container sessions, mount a volume over this point.
RUN \
    mkdir /license && \
    chmod -R o+w /license

#
# Prepare /etc/passwd for modification (this is required to support HDFS client).
# See: https://blog.openshift.com/jupyter-on-openshift-part-6-running-as-an-assigned-user-id/
#
RUN chmod o+w /etc/passwd

# Add shell wrapper
COPY run.sh /run.sh

# Set home directory for docker user, whether it be root or not.
# This was made world writable earlier.
ENV HOME /opt/h2oai/dai/home

# Set lang
# The specified 'LC_ALL' needs to have UTF8 support, or failures can occur
# if the dataset has unicode characters in AutoDoc.
ENV LANG="en_US.utf8"
ENV LC_ALL="en_US.utf8"

ENTRYPOINT ["./run.sh"]

EXPOSE 12345
