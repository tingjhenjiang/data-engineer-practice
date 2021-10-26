FROM cluster-base

# -- Layer: JupyterHub
ARG NB_USERs="user1"
ARG NB_UID="1001"
ARG NB_GID="100"
ARG PYTHON_VERSION="3.7"

# Ref: https://github.com/jupyterhub/jupyterhub-the-hard-way/blob/HEAD/docs/installation-guide-hard.md
# https://hub.docker.com/r/jupyter/base-notebook/dockerfile
# https://hub.docker.com/r/rocker/rstudio/Dockerfile
# https://github.com/grst/rstudio-server-conda/blob/master/docker/init2.sh

RUN for USER in `echo "${NB_USERs}" | grep -o -e "[^;]*"` ; do \
        echo "+ handling user \"$USER\"" && \
        useradd -m -s /bin/bash -N -g $NB_GID $USER && \
        adduser $USER users && \
        ln -s ${SHARED_WORKSPACE} /home/$USER/workspace ; \
    done

RUN apt-get update -y && \
    apt-get install -y python3-pip python3-venv wget rustc build-essential libssl-dev libffi-dev python3-dev python3-setuptools vim curl && \
    python3 -m venv /opt/jupyterhub/ && \
    /opt/jupyterhub/bin/python3 -m pip install -U pip && \
    /opt/jupyterhub/bin/python3 -m pip install wheel && \
    /opt/jupyterhub/bin/python3 -m pip install jupyterhub jupyterlab && \
    /opt/jupyterhub/bin/python3 -m pip install ipywidgets && \
    apt-get install -y nodejs npm && \
    npm install -g configurable-http-proxy && \
    mkdir -p /opt/jupyterhub/etc/jupyterhub/ && \
    cd /opt/jupyterhub/etc/jupyterhub/ && \
    /opt/jupyterhub/bin/jupyterhub --generate-config && \
    echo "c.Spawner.default_url = '/lab'" >> /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get autoclean && \
    rm -Rf /tmp/*

RUN chmod 775 /opt/jupyterhub -R && chmod 771 ${SHARED_WORKSPACE} -R && \
    chgrp $NB_GID /opt/jupyterhub -R && chgrp $NB_GID ${SHARED_WORKSPACE} -R 

ENV PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/jupyterhub/bin:$PATH
ENV NB_GID=${NB_GID}
ENV PYTHON_VERSION=${PYTHON_VERSION}
# -- Runtime

VOLUME ${SHARED_WORKSPACE}
RUN chgrp $NB_GID ${SHARED_WORKSPACE} -R && chmod 771 ${SHARED_WORKSPACE} -R
CMD ["bash"]