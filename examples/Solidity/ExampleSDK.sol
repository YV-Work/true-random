// SPDX-License-Identifier: Apache-2.0

pragma solidity 0.8.8;

import "@yv-work/true-random-sol/contracts/ITrueRandom.sol";
import "@yv-work/true-random-sol/contracts/TrueRandomConst.sol";

/**
 * @title TrueRandom usage example
 * @dev This contract is repurposed Storage.sol example
 * ExampleSDK showcases combination of on-chain generation with off-chain (hashgraph SDK) usage
 * should be used if an output needs to come out of blockchain but is needed to be parsed through SDK
 */
contract ExampleSDK is TrueRandomConst {

    ITrueRandom rand;
    uint rng;

    constructor() {
        rand = ITrueRandom(TrueRandomConst.HEDERA_TESTNET);
        // based on deployable network, choose appropriate constant
        // more useful for clients and reviewers than developers
    }

    /**
     * @dev Store value in variable
     */
    function setRNG() public {
        rng = rand.create();
    }

    /**
     * @dev Get value from variable
     */
    function getRNG() public view returns (uint ) {
        return rng;
    }

}
