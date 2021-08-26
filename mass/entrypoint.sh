if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ | sudo tee /etc/timezone
fi

export PATH=~/bin:${PATH}

if [[ ${mode} == "fractal" ]]; then
    # Fractal miner
    massminer -C fractal-config.json fractal -s ${miner_ip_port} &
else
    # Full node
    if [[ -n ${payout_address} ]]; then
      envsubst < miner-config.json > mc.json
      mv mc.json miner-config.json
    fi

    masswallet -C wallet-config.json 2>&1 > /dev/null &
    if [[ ${mode} == "collector" ]]; then
        massminer -C miner-config.json m2 -p 0.0.0.0:9690 &
    else
        massminer -C miner-config.json m2 &
    fi
fi


# Wait forever
echo "Going to sleep"
tail -f /dev/null
echo "Why ded?"
