#!/bin/bash

#
# Note:  This run script is meant to be run inside the docker container.
#

# Run with --worker to start a DAI multinode worker.

set -e

if [ "x$1" != "x" -a "x$1" != "x--worker" ]; then
    d=$1
    cd $d
    shift
    export DAI_ENV_QUIET=1
    exec /opt/h2oai/dai/dai-env.sh "$@"
fi

if [ "x${RUN_DAI_LOG_DIR}" == "x" ]; then
    export RUN_DAI_LOG_DIR=/log/`date "+%Y%m%d-%H%M%S"`
fi
mkdir -p ${RUN_DAI_LOG_DIR}

version=`DAI_ENV_QUIET=1 /opt/h2oai/dai/dai-env.sh python -c 'import h2oaicore; print(h2oaicore.__version__)'`

echo "---------------------------------"
echo "Welcome to H2O.ai's Driverless AI"
echo "---------------------------------"
echo "     version: $version"
echo ""
echo "- Put data in the volume mounted at /data"
echo "- Logs are written to the volume mounted at ${RUN_DAI_LOG_DIR}"
echo "- Connect to Driverless AI on port 12345 inside the container"

if [ "x$1" != "x--worker" ]; then
    echo "- Connect to Jupyter notebook on port 8888 inside the container"

    (export HOME=/jupyter && \
     cd /jupyter && \
     /opt/h2oai/dai/dai-env.sh jupyter --paths >> ${RUN_DAI_LOG_DIR}/jupyter.log && \
     nohup /opt/h2oai/dai/dai-env.sh jupyter notebook --ip='0.0.0.0' --no-browser --allow-root >> ${RUN_DAI_LOG_DIR}/jupyter.log 2>&1 &)
fi

/opt/h2oai/dai/run-dai.sh "$@" 1> /dev/null

if [ "x${RUN_DAI_LOG_STDOUT}" != "x" ]; then
	touch ${RUN_DAI_LOG_DIR}/dai.log
	exec tail -f ${RUN_DAI_LOG_DIR}/dai.log
else
	exec /bin/sleep infinity
fi