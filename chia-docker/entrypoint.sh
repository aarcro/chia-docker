if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ | sudo tee /etc/timezone
fi

. ./activate

chia init

if [[ ${keys} == "generate" ]]; then
  echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
  chia keys generate
elif [[ ${keys} == "copy" ]]; then
  if [[ -z ${ca} ]]; then
    echo "A path to a copy of the farmer peer's ssl/ca required."
	exit
  else
  chia init -c ${ca}
  fi
else
  chia keys add -f ${keys}
fi

for p in ${plots_dir//:/ }; do
    mkdir -p ${p}
    if [[ ! "$(ls -A $p)" ]]; then
        echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
    fi
    chia plots add -d ${p}
done

sed -i 's/localhost/127.0.0.1/g' ~/.chia/mainnet/config/config.yaml

chia configure --set-log-level ${log_level}

if [[ ${farmer} == 'true' ]]; then
  chia start farmer-only
elif [[ ${harvester} == 'true' ]]; then
  if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
    echo "A farmer peer address, port, and ca path are required."
    exit
  else
    chia configure --set-farmer-peer ${farmer_address}:${farmer_port}
    chia start harvester
  fi
else
  chia start farmer
fi

if [[ ${testnet} == "true" ]]; then
  if [[ -z $full_node_port || $full_node_port == "null" ]]; then
    chia configure --set-fullnode-port 58444
  else
    chia configure --set-fullnode-port ${var.full_node_port}
  fi
fi

if [[ -n ${satellite_key} ]]; then
  mkdir -p ~/.config/chia-dashboard-satellite
  envsubst < satellite.config.yaml > ~/.config/chia-dashboard-satellite/config.yaml
  chia-dashboard-satellite > ~/chia-dashboard-satellite.log 2>&1 &
fi

tail -F ~/.chia/mainnet/log/debug.log
