# How it works 

## TrueRandom.sol 
The following is a little more detailed explanation of how RNG functions are designed.

The PRNG generation is pretty simple:
```solidity
    /**
     * @dev RNG logic, is implemented directly in each public function to save ~300 gas
     * @param _toEncode - user provided salt to randomise RNG generation
     * @return newly generated random number
     */
    function getRNG(bytes calldata _toEncode) private view returns (uint256) {
        // downsizing trims higher bytes, changing bytes of timestamp are converted
        // 8B + 8B + 16B = 32B
        // trimming of props serves as precaution layer
        // also saves gas even on bytes to bytes16 conversion
        return uint(
            keccak256(
                abi.encode(
                    uint64(number),
                    uint64(block.timestamp),
                    bytes16(_toEncode)
                )
            )
        );  // converting 32B data into 32B hash into 32B uint
    }
```
Function is duplicated 5 times to take in each possible type of variable with direct conversion.
The function is duplicated 5 times to take in each possible type of variable with direct conversion.
Both `create` and `get` can accept:
- bytes
- string
- uint
- address
- no data

Conversions of address, string and bytes are different in order to maximise gas efficiency.
Direct conversion saves ~300 gas. Removing call to the joint hashing function saves an additional 10–150 gas.

Additional gas savings were achieved in the create function by assigning the RNG result to a new local variable and then setting state as said variable:
```solidity
    /**
     * @dev Generates new random num, should be called from smart contract
     * @return newly generated random number
     */
    function create(bytes calldata _bytesInput) override external returns (uint256) {
        uint n = uint(keccak256(abi.encode(uint64(number), uint64(block.timestamp), bytes16(_bytesInput))));
        number = n;
        return n;
    }
```
This setup saves an additional 30–120 gas over return from state variable.

## TrueRandomConst.sol

> Maximising the number of calls to the TrueRandom contract improves the system's robustness. 
> It is therefore critical to use a common RNG for all our operations.

TrueRandomConst.sol is designed to simplify TrueRandom integration on the network of your choice. 
Simply assign Interface to a new variable and set it to the Const address:
```solidity
import "./TrueRandomConst.sol";
import "./ITrueRandom.sol";

contract Example is TrueRandomConst {

    ITrueRandom rand;
    
    constructor() {
        rand = ITrueRandom(TrueRandomConst.HEDERA_TESTNET);
    }
}
```
You can, of course, avoid Const import by hardcoding TrueRandom.sol address. 