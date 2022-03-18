FROM ubuntu:latest

# Node
EXPOSE 11444
# Farmer
EXPOSE 11447

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

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y gettext curl jq python3 ansible tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3-dev python3.8-venv python3.8-distutils apt nfs-common python-is-python3 vim tzdata && apt-get clean

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN useradd -r -U -u 1000 silicoin \
&&  usermod -aG sudo silicoin \
&& install -o silicoin -g silicoin -m 755 -d /home/silicoin/ \
&& install -o silicoin -g silicoin -m 755 -d /home/silicoin/.local \
&& sed -i -e 's/ALL$/NOPASSWD:ALL/' /etc/sudoers
# Stupid ass sudo in the install.sh

VOLUME /home/silicoin/.local
WORKDIR /home/silicoin
USER 1000

ARG BRANCH=v1.2.2
RUN echo "cloning ${BRANCH}"
RUN git clone --single-branch --branch ${BRANCH} https://github.com/silicoin-network/silicoin-blockchain.git \
&& cd silicoin-blockchain \
&& git submodule update --init mozilla-ca \
&& chmod +x install.sh \
&& /usr/bin/sh ./install.sh


ENV PATH=/home/silicoin/silicoin-blockchain/venv/bin/:$PATH
WORKDIR /home/silicoin/silicoin-blockchain

ADD --chown=1000:1000 ./entrypoint.sh entrypoint.sh

ENTRYPOINT ["bash", "./entrypoint.sh"]
