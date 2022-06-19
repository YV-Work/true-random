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
        // downsizing trims higher bytes, changing bytes of timestamp are safe
        // 8B + 8B + 16B = 32B, not necessary, precaution layer
        bytes memory toKeccak = abi.encode(uint64(_number), uint64(block.timestamp), bytes16(_toEncode));
        return uint(keccak256(toKeccak));  // converting 32B data into 32B hash into 32B uint
    }

    function createNumberWithInput2(bytes memory _toEncode, uint _number) private view returns (uint256) {
        // downsizing trims higher bytes, changing bytes of timestamp are safe
        // 8B + 8B + 16B = 32B, not necessary, precaution layer
        // bytes memory toKeccak = abi.encode(uint64(_number), uint64(block.timestamp), bytes16(_toEncode));
        return uint(keccak256(abi.encode(uint64(_number), uint64(block.timestamp), bytes16(_toEncode))));  // converting 32B data into 32B hash into 32B uint
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
     * @dev Saves new value, this action is necessary to remove block.timestamp shift predictability
     * @return value of 'number'
     */
    function create() public returns (uint256) {
        number = createNumber(number);
        return number;
    }

    function create(bytes memory _bytesInput) public returns (uint256) {
        number = createNumberWithInput(_bytesInput, number);
        return number;
    }


    // gas 32909 ""
    function create(string memory _stringInput) public returns (uint256) { // gas 33716
        number = createNumberWithInput(bytes(_stringInput), number);
        return number;
    }

    // gas 32784 ""
    function create2(string memory _stringInput) public returns (uint256) { // gas 33591
        uint n = createNumberWithInput(bytes(_stringInput), number);
        number = n;
        return n;
    }

    // gas 32739 ""
    function create3(string memory _stringInput) public returns (uint256) { // gas 33546
        number = uint(keccak256(abi.encode(uint64(number), uint64(block.timestamp), bytes16(bytes(_stringInput)))));
        return number;
    }

    // gas 32830 ""
    function create4(string memory _stringInput) public returns (uint256) { // gas 33637
        uint n = uint(keccak256(abi.encode(uint64(number), uint64(block.timestamp), bytes16(bytes(_stringInput)))));
        number = n;
        return number;
    }

    // gas 28343
    function create(address _addressInput) public returns (uint256) {
        number = createNumberWithInput(abi.encode(_addressInput), number);
        return number;
    }

    // gas 28316
    function create2(address _addressInput) public returns (uint256) {
        uint n = uint(keccak256(abi.encode(uint64(number), uint64(block.timestamp), bytes16(abi.encode(_addressInput)))));
        number = n;
        return number;
    }

    // gas 28194 0x9D7f74d0C41E726EC95884E0e97Fa6129e3b5E99
    function create5(address _addressInput) public returns (uint256) {
        uint n = uint(keccak256(abi.encode(uint64(number), uint64(block.timestamp), bytes16(abi.encode(_addressInput)))));
        number = n;
        return n;
    }

    // gas 28304
    function create3(address _addressInput) public returns (uint256) {
        number = uint(keccak256(abi.encode(uint64(number), uint64(block.timestamp), bytes16(abi.encode(_addressInput)))));
        return number;
    }

    // gas 28235
    function create4(address _addressInput) public returns (uint256) {
        uint256 n = createNumberWithInput(abi.encode(_addressInput), number);
        number = n;
        return n;
    }

    function createPrivateForSender() public returns (uint256) {
        address _address = msg.sender;
        number = createNumber(numbers[_address]);
        numbers[_address] = number;
        return number;
    }

    function createPrivateForSender(bytes memory _bytesInput) public returns (uint256) {
        address _address = msg.sender;
        number = createNumberWithInput(_bytesInput, numbers[_address]);
        numbers[_address] = number;
        return number;
    }

    function createPublicForSender() public returns (uint256) {
        numbers[msg.sender] = create();
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
    function get(address _a) public view returns (uint256) { // gas 25312
        return uint(keccak256(abi.encode(uint64(number), uint64(block.timestamp), bytes16(abi.encode(_a)))));
    }

    // if perhaps sire wishes to send us the address instead?
    function get2(address _a) public view returns (uint256) { // gas 25330
        return createNumberWithInput(abi.encode(_a), number);
    }

    // if perhaps sire wishes to send us the address instead?
    function get3(address _a) public view returns (uint256) { // gas 25381
        return createNumberWithInput2(abi.encode(_a), number);
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

}
