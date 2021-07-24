# Mass miner

## Install from source

Go build: https://github.com/massnetorg/MassNet-miner.git
and build: https://github.com/massnetorg/MassNet-wallet.git
And copy the /bin/\* from both projects here

```
# This is untested - You'll have to install golang on your own.
cd ..
git clone https://github.com/massnetorg/MassNet-miner.git
cd MassNet-miner
make build
cp bin/* ../mass/bin
cd ..
git clone https://github.com/massnetorg/MassNet-wallet.git
cd MassNet-wallet
make build
cp bin/* ../mass/bin
```

If you don't want to use UID 1000, update some stuff in Dockerfile

Configure docker for you:

`cp sample.docker-compose.yml docker-compose.yml`

edit docker-compose to point to your plots, homedir, and mass wallet.

Run it:

`docker-compose up -d`

Check status:

`docker-compose exec fullnode massminercli getclientstatus`
`docker-compose exec fullnode masswalletcli getclientstatus`

Create a wallet (once your wallet is synced):

`docker-compose exec fullnode masswalletcli createwallet`

Find your address:

`docker-compose exec fullnode masswalletcli listaddresses`

Now go back and put it in your docker-compose, and restart the container.

Import your chia key if you want:

`docker-compose exec fullnode massminercli importchiakeystore .local/chia-miner-keystore.json -m`

Get a binding list:

`docker-compose exec fullnode masswalletcli getbindinglist binding_list.json`

Bind them:

`docker-compose exec fullnode masswalletcli batchbinding binding_list.json <your_mass_address_to_pay_from>`

Profit!

## Donations

* MASS: ms1qqz5sy0w8e70m0np4a0hxs43a2m79e3j6pjq80qjmga7a7c2dlxsjqmtg3vp
* Chia: xch12fuem9mnds0w6zycdqjqu7ltc96s7sly7mudrjx5gnnfx47dkpnsvl09nl
* Flax: xfx1y0sl4f6x2z22xrlwj59ypq865lyqatdzx7erxx6wmmmhfccyacpqd9udz4
* Chaingreen: cgn1y0sl4f6x2z22xrlwj59ypq865lyqatdzx7erxx6wmmmhfccyacpqmegne4
