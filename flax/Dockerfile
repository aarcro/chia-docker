FROM ubuntu:latest

EXPOSE 8555
EXPOSE 8444

ENV keys="generate"
ENV harvester="false"
ENV farmer="false"
ENV plots_dir="/plots"
ENV farmer_address="null"
ENV farmer_port="null"
ENV testnet="false"
ENV full_node_port="null"
ENV TZ="UTC"
ENV log_level="WARNING"
ARG BRANCH=latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y gettext curl jq python3 ansible tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3-dev python3.8-venv python3.8-distutils apt nfs-common python-is-python3 vim tzdata && apt-get clean

# Node 12 required, this installs the PPA
# https://www.techiediaries.com/ubuntu/install-nodejs-npm-on-ubuntu-20-04/
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y nodejs && apt-get clean

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN useradd -r -U -u 1000 flax \
&&  usermod -aG sudo flax \
&& install -o flax -g flax -m 755 -d /home/flax/ \
&& install -o flax -g flax -m 755 -d /home/flax/.local \
&& sed -i -e 's/ALL$/NOPASSWD:ALL/' /etc/sudoers
# Stupid ass sudo in the install.sh

VOLUME /home/flax/.local
WORKDIR /home/flax
USER 1000

RUN echo "cloning ${BRANCH} (0.1.6)"
RUN git clone --branch ${BRANCH} https://github.com/Flax-Network/flax-blockchain.git \
&& cd flax-blockchain \
&& git submodule update --init mozilla-ca \
&& chmod +x install.sh \
&& /usr/bin/sh ./install.sh

USER 0
RUN npm install --global npm
RUN echo "1.11 or something"
RUN npm install --global flax-dashboard-satellite

USER 1000

ENV PATH=/home/flax/flax-blockchain/venv/bin/:$PATH
WORKDIR /home/flax/flax-blockchain

ADD --chown=1000:1000 ./satellite.config.yaml satellite.config.yaml
ADD --chown=1000:1000 ./entrypoint.sh entrypoint.sh

ENTRYPOINT ["bash", "./entrypoint.sh"]
