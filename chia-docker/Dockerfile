FROM python:3.11-slim

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

#RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y gettext curl jq python3 ansible tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3-dev python3.11-venv python3.11-distutils apt nfs-common python-is-python3 vim tzdata nodejs && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs && apt-get clean

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        lsb-release sudo git

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y sudo tzdata curl netcat-traditional jq && \
        rm -rf /var/lib/apt/lists/* && \
        ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone && \
        dpkg-reconfigure -f noninteractive tzdata

RUN useradd -r -U -u 1000 chia \
&&  usermod -aG sudo chia \
&& install -o chia -g chia -m 755 -d /home/chia \
&& sed -i -e 's/ALL$/NOPASSWD:ALL/' /etc/sudoers
# Stupid ass sudo in the install.sh

WORKDIR /home/chia
USER 1000

ARG BRANCH=2.5.4-og-1.6.1
RUN echo "cloning ${BRANCH}, fucking do it"
# RUN git clone --branch ${BRANCH} https://github.com/aarcro/chia-blockchain.git \
# RUN git clone --single-branch --branch ${BRANCH} https://github.com/Chia-Network/chia-blockchain.git \
RUN git clone --single-branch --branch ${BRANCH} https://github.com/foxypool/chia-blockchain.git \
&& cd chia-blockchain \
&& git submodule update --init mozilla-ca \
&& chmod +x install.sh \
&& /usr/bin/sh ./install.sh

ENV PATH=/home/chia/chia-blockchain/venv/bin/:$PATH
WORKDIR /home/chia/chia-blockchain

# ADD --chown=1000:1000 ./satellite.config.yaml satellite.config.yaml
ADD --chown=chia:chia ./entrypoint.sh entrypoint.sh

ENTRYPOINT ["bash", "./entrypoint.sh"]
