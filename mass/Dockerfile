FROM ubuntu:latest

# Node
EXPOSE 43453
# Wallet
EXPOSE 43454

ENV plots_dir="/plots"
ENV TZ="UTC"
ENV log_level="WARNING"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y gettext less curl jq tar bash ca-certificates openssl unzip wget sudo acl apt vim tzdata && apt-get clean

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN useradd -r -U -u 1000 mass \
&&  usermod -aG sudo mass \
&& install -o mass -g mass -m 755 -d /home/mass/ \
&& install -o mass -g mass -m 755 -d /home/mass/bin \
&& install -o mass -g mass -m 755 -d /home/mass/.local \
&& sed -i -e 's/ALL$/NOPASSWD:ALL/' /etc/sudoers

VOLUME /home/mass/.local
WORKDIR /home/mass
USER 1000

ENV PATH=/home/mass/bin/:$PATH
WORKDIR /home/mass/
ADD --chown=1000:1000 ./bin/* bin/
ADD --chown=1000:1000 ./wallet-config.json .
ADD --chown=1000:1000 ./miner-config.json .
ADD --chown=1000:1000 ./entrypoint.sh .

ENTRYPOINT ["bash", "./entrypoint.sh"]
