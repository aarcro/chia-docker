if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ | sudo tee /etc/timezone
fi

. ./activate

hddcoin init

if [[ ${keys} == "generate" ]]; then
  echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
  hddcoin keys generate
elif [[ ${keys} == "copy" ]]; then
  if [[ -z ${ca} ]]; then
    echo "A path to a copy of the farmer peer's ssl/ca required."
	exit
  else
  hddcoin init -c ${ca}
  fi
else
  hddcoin keys add -f ${keys}
fi

for p in ${plots_dir//:/ }; do
    mkdir -p ${p}
    if [[ ! "$(ls -A $p)" ]]; then
        echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
    fi
    hddcoin plots add -d ${p}
done

sed -i 's/localhost/127.0.0.1/g' ~/.hddcoin/mainnet/config/config.yaml

hddcoin configure --set-log-level ${log_level}

if [[ ${farmer} == 'true' ]]; then
  hddcoin start farmer-only
elif [[ ${harvester} == 'true' ]]; then
  if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
    echo "A farmer peer address, port, and ca path are required."
    exit
  else
    hddcoin configure --set-farmer-peer ${farmer_address}:${farmer_port}
    hddcoin start harvester
  fi
else
  hddcoin start farmer
fi

# Wait forever
echo "Going to sleep"
tail -f /dev/null
echo "Why ded?"
