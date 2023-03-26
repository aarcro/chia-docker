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

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y gettext curl jq python3 ansible tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3-dev python3.8-venv python3.8-distutils apt nfs-common python-is-python3 vim tzdata nodejs && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs && apt-get clean

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN useradd -r -U -u 1000 chia \
&&  usermod -aG sudo chia \
&& install -o chia -g chia -m 755 -d /home/chia \
&& sed -i -e 's/ALL$/NOPASSWD:ALL/' /etc/sudoers
# Stupid ass sudo in the install.sh

WORKDIR /home/chia
USER 1000

ARG BRANCH=1.7.1-og-1.2.0
RUN echo "cloning ${BRANCH}"
# RUN git clone --branch ${BRANCH} https://github.com/aarcro/chia-blockchain.git \
# RUN git clone --single-branch --branch ${BRANCH} https://github.com/Chia-Network/chia-blockchain.git \
RUN git clone --single-branch --branch ${BRANCH} https://github.com/foxypool/chia-blockchain.git \
&& cd chia-blockchain \
&& git submodule update --init mozilla-ca \
&& chmod +x install.sh \
&& /usr/bin/sh ./install.sh

USER 0
RUN npm install --global npm
RUN echo "Moar satellite"
RUN npm install --global chia-dashboard-satellite

USER 1000

ENV PATH=/home/chia/chia-blockchain/venv/bin/:$PATH
WORKDIR /home/chia/chia-blockchain

ADD --chown=1000:1000 ./satellite.config.yaml satellite.config.yaml
ADD --chown=1000:1000 ./entrypoint.sh entrypoint.sh

ENTRYPOINT ["bash", "./entrypoint.sh"]
