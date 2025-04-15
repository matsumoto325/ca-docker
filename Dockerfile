FROM gcr.io/nii-ap-ops/base/datascience-notebook:main-lab4.x

USER root
RUN apt update \
    && apt install -y --no-install-recommends \
        python3-dev python3-pip python3-venv nodejs npm \
        wget git build-essential cmake vim emacs-nox \
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
