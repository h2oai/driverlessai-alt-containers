FROM nvidia/cuda:11.2.2-cudnn8-devel-ubi8

RUN yum install -y less which wget procps

RUN mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# unnoficial release
ARG DAI_URL=https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.10.0-60/x86_64-centos7/dai-1.10.0-1.x86_64.rpm

RUN set -ex && \
    wget -q "${DAI_URL}" && \
    rpm -i `basename "${DAI_URL}"` && \
    rm -rf /opt/h2oai/dai/lib/cuda-11.2 && \
    echo "docker" > /opt/h2oai/dai/metadata/package_type && \
    rm -rf `basename "${DAI_URL}"` && \
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

ENV DAI_ENV_QUIET=1
ENV LANG=en_US.utf8
ENV LC_ALL=C
ENV HOME /opt/h2oai/dai/home

RUN mkdir /license && chmod -R o+w /license
RUN chmod o+w /etc/passwd

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY run.sh /run.sh
ENTRYPOINT ["/tini", "--", "./run.sh"]

EXPOSE 12345
