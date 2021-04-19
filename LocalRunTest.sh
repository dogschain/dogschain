#!/bin/bash

KEY="dogschain-mainnet-buterin"
CHAINID="dogschain-8"
MONIKER="dogschain-mainnet-1"

# remove existing daemon and client
rm -rf ~/.dogschain*

export GOPROXY=http://goproxy.cn

if [[ "$(uname)" == "Darwin" ]]; then
    # Do something under Mac OS X platform
    # macOS 10.15
    LDFLAGS="" make install
else
    make install
fi

dogschaincli config keyring-backend test

# Set up config for CLI
dogschaincli config chain-id $CHAINID
dogschaincli config output json
dogschaincli config indent true
dogschaincli config trust-node true

# if $KEY exists it should be deleted
dogschaincli keys add $KEY

# Set moniker and chain-id for Lsbchain (Moniker can be anything, chain-id must be an integer)
dogschaind init $MONIKER --chain-id $CHAINID

# Change parameter token denominations to dogs
cat $HOME/.dogschaind/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="dogs"' > $HOME/.dogschaind/config/tmp_genesis.json && mv $HOME/.dogschaind/config/tmp_genesis.json $HOME/.dogschaind/config/genesis.json
cat $HOME/.dogschaind/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="dogs"' > $HOME/.dogschaind/config/tmp_genesis.json && mv $HOME/.dogschaind/config/tmp_genesis.json $HOME/.dogschaind/config/genesis.json
cat $HOME/.dogschaind/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="dogs"' > $HOME/.dogschaind/config/tmp_genesis.json && mv $HOME/.dogschaind/config/tmp_genesis.json $HOME/.dogschaind/config/genesis.json
cat $HOME/.dogschaind/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="dogs"' > $HOME/.dogschaind/config/tmp_genesis.json && mv $HOME/.dogschaind/config/tmp_genesis.json $HOME/.dogschaind/config/genesis.json

# increase block time (?)
cat $HOME/.dogschaind/config/genesis.json | jq '.consensus_params["block"]["time_iota_ms"]="30000"' > $HOME/.dogschaind/config/tmp_genesis.json && mv $HOME/.dogschaind/config/tmp_genesis.json $HOME/.dogschaind/config/genesis.json

if [[ $1 == "pending" ]]; then
    echo "pending mode on; block times will be set to 30s."
    # sed -i 's/create_empty_blocks_interval = "0s"/create_empty_blocks_interval = "30s"/g' $HOME/.dogschaind/config/config.toml
    sed -i 's/timeout_propose = "3s"/timeout_propose = "30s"/g' $HOME/.dogschaind/config/config.toml
    sed -i 's/timeout_propose_delta = "500ms"/timeout_propose_delta = "5s"/g' $HOME/.dogschaind/config/config.toml
    sed -i 's/timeout_prevote = "1s"/timeout_prevote = "10s"/g' $HOME/.dogschaind/config/config.toml
    sed -i 's/timeout_prevote_delta = "500ms"/timeout_prevote_delta = "5s"/g' $HOME/.dogschaind/config/config.toml
    sed -i 's/timeout_precommit = "1s"/timeout_precommit = "10s"/g' $HOME/.dogschaind/config/config.toml
    sed -i 's/timeout_precommit_delta = "500ms"/timeout_precommit_delta = "5s"/g' $HOME/.dogschaind/config/config.toml
    sed -i 's/timeout_commit = "5s"/timeout_commit = "150s"/g' $HOME/.dogschaind/config/config.toml
fi

# Allocate genesis accounts (cosmos formatted addresses)
dogschaind add-genesis-account $(dogschaincli keys show $KEY -a) 100000000000000000000dogs

# Sign genesis transaction
dogschaind gentx --name $KEY --amount=1000000000000000000dogs --keyring-backend test

# Collect genesis tx
dogschaind collect-gentxs

# Run this to ensure everything worked and that the genesis file is setup correctly
dogschaind validate-genesis

# Command to run the rest server in a different terminal/window
echo -e '\nrun the following command in a different terminal/window to run the REST server and JSON-RPC:'
echo -e "dogschaincli rest-server --laddr \"tcp://localhost:8545\" --wsport 8546 --unlock-key $KEY --chain-id $CHAINID --trace --rpc-api "web3,eth,net"\n"
dogschaincli keys unsafe-export-eth-key $KEY
# Start the node (remove the --pruning=nothing flag if historical queries are not needed)
dogschaind start --pruning=nothing --rpc.unsafe --log_level "main:info,state:info,mempool:info" --trace
