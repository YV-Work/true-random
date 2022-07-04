// SPDX-License-Identifier: Apache-2.0

pragma solidity 0.8.8;

import "@yv-work/true-random-sol/contracts/ITrueRandom.sol";
import "@yv-work/true-random-sol/contracts/TrueRandomConst.sol";

/**
 * @title TrueRandom usage example
 * @dev This contract utilizes true RNG capabilities
 * to create fair and unpredictable NPCs for some kind of game
 */
contract Example is TrueRandomConst {

    ITrueRandom rand;

    struct GameNPC {
        uint8 stamina;
        uint8 dexterity;
        uint8 intelligence;
        uint8 strength;
        bool isHostile;
        ClassNPC class;
    }

    enum ClassNPC {TANK, HEALER, DPS}

    GameNPC[] npcs;

    constructor() {
        rand = ITrueRandom(TrueRandomConst.HEDERA_TESTNET);
    }

    // switch TrueRandom.sol on newer version
    function connectRandomizer(address _a) public {
        // TODO add owner check
        rand = ITrueRandom(_a);
    }

    // while costly can be used to refresh with our own kind of input just to be sure that stored salt isn't malicious
    function refreshRNG() public {
        rand.create(msg.sender);
    }

    /**
    * if for some reason we want to create `public view` function, TrueRandom.get is needed
    * due to interaction with TrueRandom state in TrueRandom.create
    * such call is vulnerable to duplicate returns unless client salt is not updated externally
    * e.g. timestamp from JS sdk or some kind of iteration input
    */
    function createNPC(string memory _sdkInput) public view returns (GameNPC memory) {
        uint rng = rand.get(_sdkInput);
        // TrueRandom.sol generated source of properties
        uint8[6] memory props;
        for (uint i = 0; i < 6; i++) {
            props[i] = uint8(rng % 100);
            rng = rng / 100;
        }
        props[4] = props[4] % 2;
        // reducing to bool for isHostile
        props[5] = props[5] % 3;
        // reducing to enum length, should use better size var but whatever
        GameNPC memory npc = GameNPC({
            stamina : props[0],
            dexterity : props[1],
            intelligence : props[2],
            strength : props[3],
            isHostile : props[4] != 0,
            class : ClassNPC(props[5])
        });
        return npc;
    }

    /**
    * whenever state is being changed, it is recommended to use TrueRandom.create instead of TrueRandom.get
    * main difference being, due to interaction with TrueRandom state
    * multiple RNG rolls can be triggered within one block.timestamp without client salt change
    */
    function saveNPC() public returns (GameNPC memory) {
        uint rng = rand.create(msg.sender);
        // TrueRandom.sol generated source of properties
        uint8[6] memory props;
        for (uint i = 0; i < 6; i++) {
            props[i] = uint8(rng % 100);
            rng = rng / 100;
        }
        props[4] = props[4] % 2;
        // reducing to bool for isHostile
        props[5] = props[5] % 3;
        // reducing to enum length, should use better size var but whatever
        GameNPC memory newNPC = GameNPC({
            stamina : props[0],
            dexterity : props[1],
            intelligence : props[2],
            strength : props[3],
            isHostile : props[4] != 0,
            class : ClassNPC(props[5])
        });
        npcs.push(newNPC);
        return newNPC;
    }

    function getNPCs() public view returns (GameNPC[] memory) {
        return npcs;
    }
}
