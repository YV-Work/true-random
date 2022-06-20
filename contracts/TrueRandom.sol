// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";


/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
//0x022366c32c51a0278922c465947921b6bf3610ac
contract TrueRandomResearch {

    uint256 private number;
    uint64 private previous;
    mapping(address => uint) private numbers;

    function createNumberWithInput(bytes memory _toEncode, uint _number) private view returns (uint256) {
        // downsizing trims higher bytes, changing bytes of timestamp are converted
        // 8B + 8B + 16B = 32B, not necessary
        // trimming functions as precaution layer, also saves gas
        return uint(
            keccak256(
                abi.encode(
                    uint64(_number),
                    uint64(block.timestamp),
                    bytes16(_toEncode)
                )
            )
        );  // converting 32B data into 32B hash into 32B uint
    }

    function createNumber(uint _number) private view returns (uint256) {
        // downsizing trims higher bytes, changing bytes of timestamp are safe
        // 16B + 16B = 32B, not necessary, precaution layer
        bytes memory toKeccak = abi.encode(uint128(_number), uint128(block.timestamp));
        return uint(keccak256(toKeccak));  // converting 32B data into 32B hash into 32B uint
    }

    /**
     * @dev Saves new value, this action is necessary to remove block.timestamp shift predictability
     * @return value of randomly generated uint256 'number'
     */
    function generateNewPrivateNumberForAddress(bytes memory _uInput, address _address) private returns (uint256) {
        number = createNumberWithInput(_uInput, numbers[_address]);
        numbers[_address] = number;
        return number;
    }

    function generateNewPublicNumberForAddress(bytes memory _uInput, address _address) private returns (uint256) {
        number = createNumberWithInput(_uInput, number);
        numbers[_address] = number;
        return number;
    }

    /**
     * @dev Generates new random num, should be called from smart contract
     * @return newly generated random number
     */
    function create() public returns (uint256) {
        uint256 n = createNumber(number);
        number = n;
        return n;
    }

    /**
     * @dev Generates new random num, should be called from smart contract
     * @return newly generated random number
     */
    function create(bytes memory _bytesInput) public returns (uint256) {
        uint256 n = createNumberWithInput(_bytesInput, number);
        number = n;
        return n;
    }

    /**
     * @dev Generates new random num, should be called from smart contract
     * @return newly generated random number
     */
    function create(string memory _stringInput) public returns (uint256) { // gas 33591
        uint256 n = createNumberWithInput(bytes(_stringInput), number);
        number = n;
        return n;
    }

    /**
     * @dev Generates new random num, should be called from smart contract
     * @return newly generated random number
     */
    function create(address _addressInput) public returns (uint256) {
        uint256 n = createNumberWithInput(abi.encode(_addressInput), number);
        number = n;
        return n;
    }

    function createPrivateForSender(bytes memory _bytesInput) public returns (uint256) {
        address _address = msg.sender;
        number = createNumberWithInput(_bytesInput, numbers[_address]);
        numbers[_address] = number;
        return number;
    }

    function createPublicForSender(bytes memory _bytesInput) public returns (uint256) {
        numbers[msg.sender] = create(_bytesInput);
        return number;
    }

    // default
    function get() public view returns (uint256) {
        return createNumber(number);
    }

    // special for everyone
    function get(bytes memory _b) public view returns (uint256) {
        return createNumberWithInput(_b, number);
    }

    function get(string memory _s) public view returns (uint256) {
        return createNumberWithInput(bytes(_s), number);
    }

    // if perhaps sire wishes to send us the address instead?
    function get(address _a) public view returns (uint256) { // gas 25330
        return createNumberWithInput(abi.encode(_a), number);
    }

    // default for special users
    function getForSender() public view returns (uint256) {
        return createNumber(numbers[msg.sender]);
    }

    // rest for special users
    function getForSender(bytes memory _b) public view returns (uint256) {
        return createNumberWithInput(_b, numbers[msg.sender]);
    }

    function getForSender(string memory _s) public view returns (uint256) {
        return createNumberWithInput(bytes(_s), numbers[msg.sender]);
    }

    // if perhaps sire wishes to send us the address instead?
    function getForSender(address _a) public view returns (uint256) {
        return createNumberWithInput(abi.encode(_a), numbers[msg.sender]);
    }

    function convert() public view returns (bytes memory) {
        return abi.encode(msg.sender);
    }

}
