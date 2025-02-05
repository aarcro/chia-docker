if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ | sudo tee /etc/timezone
fi

. ./activate

stai init

if [[ ${keys} == "generate" ]]; then
  echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
  stai keys generate
elif [[ ${keys} == "prompt" ]]; then
  echo "Input your keys"
  stai keys add
elif [[ ${keys} == "none" ]]; then
  echo "using keychain for keys"
elif [[ ${keys} == "copy" ]]; then
  if [[ -z ${ca} ]]; then
    echo "A path to a copy of the farmer peer's ssl/ca required."
	exit
  else
  stai init -c ${ca}
  fi
else
  stai keys add -f ${keys}
fi

for p in ${plots_dir//:/ }; do
    mkdir -p ${p}
    if [[ ! "$(ls -A $p)" ]]; then
        echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
    fi
    stai plots add -d ${p}
done

sed -i 's/localhost/127.0.0.1/g' ~/.stai/mainnet/config/config.yaml

stai configure --set-log-level ${log_level}

if [[ ${farmer} == 'true' ]]; then
  stai start farmer-only
elif [[ ${harvester} == 'true' ]]; then
  if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
    echo "A farmer peer address, port, and ca path are required."
    exit
  else
    stai configure --set-farmer-peer ${farmer_address}:${farmer_port}
    stai start harvester
  fi
else
  stai start farmer
fi

if [[ ${testnet} == "true" ]]; then
  if [[ -z $full_node_port || $full_node_port == "null" ]]; then
    stai configure --set-fullnode-port 58444
  else
    stai configure --set-fullnode-port ${var.full_node_port}
  fi
fi

# Wait forever
echo "Going to sleep"
tail -f /dev/null
echo "Why ded?"
