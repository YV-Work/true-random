// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.8;

abstract contract TrueRandomConst {

    address internal constant HEDERA_TESTNET = address(0x000000000000000000000000000000000000386df6);
        // TrueRandom.sol on Hedera testnet (0.0.3698166)
    address internal constant HEDERA_PREVIEWNET = address(0x000000000000000000000000000000000000009cd3);
        // TrueRandom.sol on Hedera previewnet (0.0.40147)
    address internal constant HEDERA_MAINNET = address(0x0000000000000000000000000000000000000fe4bf);
        // TrueRandom.sol on Hedera mainnet (0.0.1041599, might be redeployed after review)
    address internal constant ETHEREUM_RINKEBY = address(0x0c8B611F6BAa9EE031ff04D85BcdE65feF8b8869);
    address internal constant ETHEREUM_SEPOLIA = address(0x0);
    address internal constant ETHEREUM_GOERLI = address(0x0);
    address internal constant ETHEREUM_MAINNET = address(0x0);
        // To be deployed after review
}