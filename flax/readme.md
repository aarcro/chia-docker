# Flax fork

Old busted: docker attach to the full node and paste/type 24 words at startup (Or do your own config thing)

New hottness: docker volume for ~/.local => `docker-compose exec fullnode keys add` once, saved forever.

Create all the ~/.flax directories first, or docker will create them as root before dropping privs

If you don't want to use UID 1000, update some stuff
