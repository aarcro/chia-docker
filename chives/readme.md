# Chives fork

Old busted: docker attach to the full node and paste/type 24 words at startup (Or do your own config thing)

New hottness: docker volume for ~/.local => `docker-compose exec fullnode keys add` once, saved forever.

Create all the ~/.chives directories first, or docker will create them as root before dropping privs

If you don't want to use UID 1000, update some stuff


## Donations

* MASS: ms1qqz5sy0w8e70m0np4a0hxs43a2m79e3j6pjq80qjmga7a7c2dlxsjqmtg3vp
* Chia: xch12fuem9mnds0w6zycdqjqu7ltc96s7sly7mudrjx5gnnfx47dkpnsvl09nl
* Flax: xfx1y0sl4f6x2z22xrlwj59ypq865lyqatdzx7erxx6wmmmhfccyacpqd9udz4
* Chaingreen: cgn1y0sl4f6x2z22xrlwj59ypq865lyqatdzx7erxx6wmmmhfccyacpqmegne4
