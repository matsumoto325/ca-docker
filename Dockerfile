FROM python:3.9-slim
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook jupyterlab

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        vim \
        && rm -rf /var/lib/apt/lists/*

RUN mv /etc/ssl/openssl.cnf /etc/ssl/openssl.cnf.org \
    && cat /etc/ssl/openssl.cnf.org \
    | sed -e '/^basicConstraints /a \\nkeyUsage = digitalSignature, cRLSign, keyCertSign\nextendedKeyUsage = serverAuth, clientAuth, codeSigning, emailProtection, timeStamping, anyExtendedKeyUsage\n' \
    | tee /etc/ssl/openssl.cnf

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
