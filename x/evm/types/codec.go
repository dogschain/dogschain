package types

import (
	"github.com/cosmos/cosmos-sdk/codec"
)

// ModuleCdc defines the evm module's codec
var ModuleCdc = codec.New()

// RegisterCodec registers all the necessary types and interfaces for the
// evm module
func RegisterCodec(cdc *codec.Codec) {
	cdc.RegisterConcrete(MsgEthereumTx{}, "dogschain/MsgEthereumTx", nil)
	cdc.RegisterConcrete(MsgDogsChain{}, "dogschain/MsgDogsChain", nil)
	cdc.RegisterConcrete(TxData{}, "dogschain/TxData", nil)
	cdc.RegisterConcrete(ChainConfig{}, "dogschain/ChainConfig", nil)
}

func init() {
	RegisterCodec(ModuleCdc)
	codec.RegisterCrypto(ModuleCdc)
	ModuleCdc.Seal()
}
