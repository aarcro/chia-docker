if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ | sudo tee /etc/timezone
fi

if [[ -n ${payout_address} ]]; then
  envsubst < miner-config.json > mc.json
  mv mc.json miner-config.json
fi

export PATH=~/bin:${PATH}
masswallet -C wallet-config.json 2>&1 > /dev/null &
massminer -C miner-config.json m2 &

# Wait forever
echo "Going to sleep"
tail -f /dev/null
echo "Why ded?"
