// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.8;

abstract contract TrueRandomConst {

    address internal constant HEDERA_TESTNET = address(0x000000000000000000000000000000000002ca43a1);
        // TrueRandom.sol on Hedera testnet (0.0.46810017)
    address internal constant HEDERA_PREVIEWNET = address(0x000000000000000000000000000000000000000f2a);
        // TrueRandom.sol on Hedera previewnet (0.0.3882)
    address internal constant HEDERA_MAINNET = address(0x0);
        // TrueRandom.sol on Hedera mainnet, To be deployed after review
    address internal constant ETHEREUM_RINKEBY = address(0x785C507E0E46c7562320677705975fff1b04F75D);
    address internal constant ETHEREUM_SEPOLIA = address(0x0);
    address internal constant ETHEREUM_GOERLI = address(0x0);
    address internal constant ETHEREUM_MAINNET = address(0x0);
        // To be deployed after review
}