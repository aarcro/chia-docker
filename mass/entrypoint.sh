if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ | sudo tee /etc/timezone
fi

# What do?
for p in ${plots_dir//:/ }; do
    mkdir -p ${p}
    if [[ ! "$(ls -A $p)" ]]; then
        echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
    fi
    echo "Plots are here: ${p}"
done

export PATH=~/bin:${PATH}
masswallet -C wallet-config.json 2>&1 | /dev/null &

# Wait forever
echo "Going to sleep"
tail -f /dev/null
echo "Why ded?"
