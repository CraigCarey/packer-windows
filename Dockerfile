FROM ubuntu:22.04

WORKDIR /build/

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    sudo \
    lsb-release \
    openssh-server \
    wget \
    libssl-dev \
    ca-certificates \
    x11-xserver-utils \
    locales \
    gpg \
    sudo

# Configure user
ARG USER=developer
ARG UID=1000
ARG GID=1000

# Set up user
RUN set -eu; \
    groupadd --gid=${GID} ${USER}; \
    useradd -m ${USER} --uid=${UID} --gid=${GID} && echo "${USER}:pwd" | chpasswd; \
    usermod -aG sudo ${USER};

RUN sed -i '/en_GB.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ARG TZ="Europe/Belfast"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV LANG en_GB.UTF-8  
ENV LANGUAGE en_US:en
ENV LC_ALL en_GB.UTF-8

ENV USER ${USER}

# Enable remote debugging
RUN set -eu; \
    mkdir /var/run/sshd; \
    echo 'root:root' | chpasswd; \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd; \
    mkdir -p /var/run/sshd; \
    mkdir -p /root/.ssh; \
    chmod 700 /root/.ssh; \
    ssh-keygen -A; \
    echo "export DISPLAY=:0" >> /etc/profile

RUN set -eu; \
    wget https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list; \
    apt update && sudo install packer;

WORKDIR /home/${USER}/

# 22 for ssh server
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
