FROM python:3.9-slim
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook jupyterlab

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3-dev python3-pip python3-venv nodejs npm \
        wget git build-essential cmake vim emacs-nox \
        libssl-dev \ 
        && rm -rf /var/lib/apt/lists/*

RUN mv /etc/ssl/openssl.cnf /etc/ssl/openssl.cnf.org \
    && cat /etc/ssl/openssl.cnf.org \
    | sed -e '/^basicConstraints /a \\nkeyUsage = digitalSignature, cRLSign, keyCertSign\nextendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection, timeStamping, anyExtendedKeyUsage\n' \
    | tee /etc/ssl/openssl.cnf

RUN echo c.NotebookApp.terminado_settings = {'shell_command': ['/bin/bash']} \
    >> /usr/local/lib/python3.9/site-packages/notebook_shim/tests/confs/jupyter_notebook_config.py

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}
