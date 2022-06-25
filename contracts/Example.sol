pragma solidity ^0.8.0;

import "./TrueRandomInterface.sol";

/**
 * @title TrueRandom usage example
 * @dev This contract utilizes true RNG capabilities
 * to create fair and unpredictable NPCs for some kind of game
 */
contract Example {

    TrueRandomInterface rand;

    struct GameNPC {
        uint8 stamina;
        uint8 dexterity;
        uint8 intelligence;
        uint8 strength;
        bool isHostile;
        ClassNPC class;
    }

    enum ClassNPC {TANK, HEALER, DPS}

    constructor() {
    }

    // initialize TrueRandom.sol on currently used network
    function connectRandomizer(address _a) public {
        rand = TrueRandomInterface(_a);
    }

    // while costly can be used to refresh with our own kind of input just to be sure that stored salt isn't malicious
    function refreshRNG() public {
        rand.create(msg.sender);
    }

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
            inteligence : props[2],
            strength : props[3],
            isHostile : props[4] != 0,
            class : ClassNPC(props[5])
        });
        return npc;
    }
}
