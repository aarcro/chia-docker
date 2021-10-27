FROM ubuntu:latest

# Node
EXPOSE 1999
# Farmer
EXPOSE 1692

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

# Node 12 required, this installs the PPA
# https://www.techiediaries.com/ubuntu/install-nodejs-npm-on-ubuntu-20-04/
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y nodejs && apt-get clean

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN useradd -r -U -u 1000 staicoin \
&&  usermod -aG sudo staicoin \
&& install -o staicoin -g staicoin -m 755 -d /home/staicoin/ \
&& install -o staicoin -g staicoin -m 755 -d /home/staicoin/.local \
&& sed -i -e 's/ALL$/NOPASSWD:ALL/' /etc/sudoers
# Stupid ass sudo in the install.sh

VOLUME /home/staicoin/.local
WORKDIR /home/staicoin
USER 1000

ARG BRANCH=1.0.3
RUN echo "cloning ${BRANCH}"
RUN git clone --single-branch --branch ${BRANCH} https://github.com/STATION-I/staicoin-blockchain.git \
&& cd staicoin-blockchain \
&& git submodule update --init mozilla-ca \
&& chmod +x install.sh \
&& /usr/bin/sh ./install.sh


ENV PATH=/home/staicoin/staicoin-blockchain/venv/bin/:$PATH
WORKDIR /home/staicoin/staicoin-blockchain

ADD --chown=1000:1000 ./entrypoint.sh entrypoint.sh

ENTRYPOINT ["bash", "./entrypoint.sh"]
