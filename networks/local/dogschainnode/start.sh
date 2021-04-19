#!/usr/bin/env sh

##
## Input parameters
##
ID=${ID:-0}
LOG=${LOG:-dogschaind.log}

##
## Run binary with all parameters
##
export DOGSCHAINDHOME="/dogschaind/node${ID}/dogschaind"

if [ -d "$(dirname "${DOGSCHAINDHOME}"/"${LOG}")" ]; then
  dogschaind --chain-id dogschain-1 --home "${DOGSCHAINDHOME}" "$@" | tee "${DOGSCHAINDHOME}/${LOG}"
else
  dogschaind --chain-id dogschain-1 --home "${DOGSCHAINDHOME}" "$@"
fi