FROM ubuntu:latest

EXPOSE 8744
EXPOSE 8777

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

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y curl gettext jq python3 tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3-dev python3.8-venv python3.8-distutils apt python-is-python3 vim tzdata

# Node 12 required, this installs the PPA
# https://www.techiediaries.com/ubuntu/install-nodejs-npm-on-ubuntu-20-04/
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y nodejs && apt-get clean

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN useradd -r -U -u 1000 chaingreen \
&&  usermod -aG sudo chaingreen \
&& install -o chaingreen -g chaingreen -m 755 -d /home/chaingreen/ \
&& install -o chaingreen -g chaingreen -m 755 -d /home/chaingreen/.local \
&& sed -i -e 's/ALL$/NOPASSWD:ALL/' /etc/sudoers
# Stupid ass sudo in the install.sh

VOLUME /home/chaingreen/.local
WORKDIR /home/chaingreen
USER 1000

RUN echo "cloning ${BRANCH} again 1.2.1"
RUN git clone --depth 1 --branch ${BRANCH} https://github.com/ChainGreenOrg/chaingreen-blockchain.git \
&& cd chaingreen-blockchain \
&& git submodule update --init mozilla-ca \
&& chmod +x install.sh \
&& /usr/bin/sh ./install.sh

USER 0
RUN npm install --global npm
RUN npm install --global chaingreen-dashboard-satellite ; echo "1.11 or some shit"

USER 1000

ENV PATH=/home/chaingreen/chaingreen-blockchain/venv/bin/:$PATH
WORKDIR /home/chaingreen/chaingreen-blockchain

ADD --chown=1000:1000 ./satellite.config.yaml satellite.config.yaml
ADD --chown=1000:1000 ./entrypoint.sh entrypoint.sh

ENTRYPOINT ["bash", "./entrypoint.sh"]
