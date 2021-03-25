FROM centos:7

RUN \
    yum install -y \
        less \
        which \
        wget \
        graphviz && \
    wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/f/fdupes-1.6.1-1.el7.x86_64.rpm && \
    yum install -y fdupes-1.6.1-1.el7.x86_64.rpm && \
    rm -rf fdupes-1.6.1-1.el7.x86_64.rpm && \
    yum clean all -y && rm -rf /var/cache/yum

ARG DAI_URL=https://s3.amazonaws.com/artifacts.h2o.ai/releases/ai/h2o/dai/rel-1.9.1-76/x86_64-centos7/dai-1.9.1.1-linux-x86_64.sh

COPY ln_dupes.py /ln_dupes.py
COPY run.sh /run.sh

RUN mkdir -p /opt/h2oai

RUN \
    cd /opt/h2oai && \
    echo "------------- Download and extract DriverlessAI ----------------------------------------" && \
    wget -q "${DAI_URL}" && \
    chmod 755 `basename "${DAI_URL}"` && \
    ./`basename "${DAI_URL}"` && \
    rm -rf `basename "${DAI_URL}"` && \
    rm -rf /opt/h2oai/dai && \
    ln -s `basename "${DAI_URL%.sh}"` /opt/h2oai/dai && \
    cd /opt/h2oai/dai && \
    echo "------------- Remove unused ------------------------------------------------------------" && \
    rm -rf libexec && \
    rm -rf python/lib/node_modules && \
    rm -rf python/lib/vega-cli && \
    rm -rf python/lib/vega-lite-cli && \
    rm -rf src && \
    echo "------------- Remove CUDA related packages ---------------------------------------------" && \
    rm -rf python/lib/python3.6/site-packages/tensorflow_gpu && \
    rm -rf lib/cuda-10.0 && \
    echo "------------- Remove backward compatibility packages -----------------------------------" && \
    rm -rf python/lib/python3.6/site-packages/xgboost_prev && \
    echo "------------- Use public docs instead of bundled docs ----------------------------------" && \
    rm -rf docs && \
    docs_path=$(dirname `dirname $DAI_URL`)/docs/userguide && \
    sed -i "s|Flux.staticUrl('/docs/userguide/index.html')|'$docs_path/index.html'|g" python/lib/python3.6/site-packages/h2oai/ui/main.js && \
    sed -i "s|Flux.staticUrl('/docs/userguide/scoring-mojo-pipelines.html')|'$docs_path/scoring-mojo-pipelines.html'|g" python/lib/python3.6/site-packages/h2oai/ui/main.js && \
    sed -i "s|'/docs/userguide|'$docs_path|g" python/lib/python3.6/site-packages/h2oai/ui/main.js && \
    sed -i "s|e.staticUrl(\"/docs/userguide/index.html\")|\"$docs_path/index.html\"|g" python/lib/python3.6/site-packages/h2oai/ui/main.min.js && \
    sed -i "s|e.staticUrl(\"/docs/userguide/scoring-mojo-pipelines.html\")|\"$docs_path/scoring-mojo-pipelines.html\"|g" python/lib/python3.6/site-packages/h2oai/ui/main.min.js && \
    sed -i "s|\"/docs/userguide|\"$docs_path|g" python/lib/python3.6/site-packages/h2oai/ui/main.min.js && \
    echo "------------- Remove unecessary platform specific artifacts ----------------------------" && \
    find . -type f -iname "*macos*.whl" -delete && \
    find . -type f -iname "*ppc64*.whl" -delete && \
    #echo "------------- Symlink duplicates -------------------------------------------------------" && \
    #rm -rf h2oai_scorer/mojo-pipeline/mojo2-runtime.jar && \
    #ln -s mojo2-runtime.jar h2oai_scorer/mojo-pipeline/mojo2-runtime.jar && \
    #rm -rf python/lib/python3.6/site-packages/h2oai/ui/mojo2-runtime.jar && \
    #ln -s mojo2-runtime.jar python/lib/python3.6/site-packages/h2oai/ui/mojo2-runtime.jar && \
    #fdupes -r -S -n -1 -q h2oai_scorer | ./dai-env.sh python /ln_dupes.py -l 1000 && \
    echo "------------- Fix permissions ----------------------------------------------------------" && \
    echo "docker" > /opt/h2oai/dai/metadata/package_type && \
    rm -rf /opt/h2oai/dai/tmp && \
    ln -s /tmp /opt/h2oai/dai/tmp && \
    mkdir /log && \
    chmod -R o+w /log && \
    rm -rf /opt/h2oai/dai/log && \
    ln -s /log /opt/h2oai/dai/log && \
    mkdir -p /opt/h2oai/dai/home && \
    chmod -R o+rwx /opt/h2oai/dai/home && \
    mkdir -p /opt/h2oai/dai/redis-data && \
    chmod -R o+rwx /opt/h2oai/dai/redis-data && \
    mkdir -p /opt/h2oai/dai/minio-data && \
    chmod -R o+rwx /opt/h2oai/dai/minio-data && \
    echo "------------- DriverlessAI installation complete ---------------------------------------"

ENV DAI_ENV_QUIET=1
ENV LANG=en_US.utf8
ENV LC_ALL=en_US.utf8
ENV HOME /opt/h2oai/dai/home

# Disable GPU detection
ENV CUDA_VISIBLE_DEVICES=

RUN mkdir /license && chmod -R o+w /license
RUN chmod o+w /etc/passwd

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT ["/tini", "--", "./run.sh"]

EXPOSE 12345
