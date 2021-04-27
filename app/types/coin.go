package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

const (
	// AttoDogs defines the default coin denomination used in DogsChain in:
	//
	// - Staking parameters: denomination used as stake in the dPoS chain
	// - Mint parameters: denomination minted due to fee distribution rewards
	// - Governance parameters: denomination used for spam prevention in proposal deposits
	// - Crisis parameters: constant fee denomination used for spam prevention to check broken invariant
	// - EVM parameters: denomination used for running EVM state transitions in DogsChain.
	AttoDogs string = "adogs"

	// BaseDenomUnit defines the base denomination unit for Photons.
	// 1 dogs = 1x10^{BaseDenomUnit} adogs
	BaseDenomUnit = 18
)

// NewPhotonCoin is a utility function that returns an "adogs" coin with the given sdk.Int amount.
// The function will panic if the provided amount is negative.
func NewPhotonCoin(amount sdk.Int) sdk.Coin {
	return sdk.NewCoin(AttoDogs, amount)
}

// NewPhotonDecCoin is a utility function that returns an "adogs" decimal coin with the given sdk.Int amount.
// The function will panic if the provided amount is negative.
func NewPhotonDecCoin(amount sdk.Int) sdk.DecCoin {
	return sdk.NewDecCoin(AttoDogs, amount)
}

// NewPhotonCoinInt64 is a utility function that returns an "adogs" coin with the given int64 amount.
// The function will panic if the provided amount is negative.
func NewPhotonCoinInt64(amount int64) sdk.Coin {
	return sdk.NewInt64Coin(AttoDogs, amount)
}
