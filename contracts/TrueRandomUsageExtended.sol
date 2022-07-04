// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
/**
-----***WARNING***-----
-CONTRACT IS UNDER DEV-
----***DONUT USE***----
*/


import "hardhat/console.sol";


/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
//
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
    function createNumberWithInput5(bytes calldata _toEncode, uint _number) private view returns (uint256) {
        // downsizing trims higher bytes, changing bytes of timestamp are safe
        // 8B + 8B + 16B = 32B, not necessary, precaution layer
        // bytes memory toKeccak = abi.encode(uint64(_number), uint64(block.timestamp), bytes16(_toEncode));
        return uint(keccak256(abi.encode(uint64(_number), uint64(block.timestamp), bytes16(_toEncode))));  // converting 32B data into 32B hash into 32B uint
    }
    function createNumberWithInput3(bytes memory _toEncode, uint _number) private view returns (uint256) {
        // downsizing trims higher bytes, changing bytes of timestamp are safe
        // 8B + 8B + 16B = 32B, not necessary, precaution layer
        uint64 _t = uint64(block.timestamp);
        uint64 _n = uint64(_number);
        bytes16 _b = bytes16(_toEncode);
        bytes memory toKeccak = abi.encode(_n, _t, _b);
        return uint(keccak256(toKeccak));  // converting 32B data into 32B hash into 32B uint
    }
    function createNumberWithInput4(bytes memory _toEncode, uint _number) private view returns (uint256) {
        // downsizing trims higher bytes, changing bytes of timestamp are safe
        // 8B + 8B + 16B = 32B, not necessary, precaution layer
        uint64 _t = uint64(block.timestamp);
        uint64 _n = uint64(_number);
        bytes16 _b = bytes16(_toEncode);
        // bytes memory toKeccak = ;
        return uint(keccak256(abi.encode(_n, _t, _b)));  // converting 32B data into 32B hash into 32B uint
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


    function create() public returns (uint256) {
        number = createNumber(number);
        return number;
    }

    // gas 28920 (33258)
    function create(bytes memory _bytesInput) public returns (uint256) {
        number = createNumberWithInput(_bytesInput, number);
        return number;
    }

    // gas 28906 (33242)
    function create2(bytes memory _bytesInput) public returns (uint256) {
        number = createNumberWithInput2(_bytesInput, number);
        return number;
    }

    // gas 28916 (33254)
    function create3(bytes memory _bytesInput) public returns (uint256) {
        number = createNumberWithInput3(_bytesInput, number);
        return number;
    }

    // gas 28925 (33264)
    function create4(bytes memory _bytesInput) public returns (uint256) {
        number = createNumberWithInput4(_bytesInput, number);
        return number;
    }
    // 0x0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4

    /**
     * create1 - 33065 (28752)
     * create2 - 32940 (28643)
     * create3 - 32997 (28693)
     * create4 - 32986 (28683)
     * create5 - 33001 (28696)
     * create6 - 32575 (28326)
     * create7 - 32309 (28094)
     * create8 - 32298 (28085)
     * create9 - 32248 (28041)
     */

    // gas 29718 (34176)
    // "s" 33065 gas (28752)
    function create(string memory _stringInput) public returns (uint256) { // gas 33716
        number = createNumberWithInput(bytes(_stringInput), number);
        return number;
    }

    // gas 29609 (34051)
    // "s" 32940 gas (28643)
    function create2(string memory _stringInput) public returns (uint256) { // gas 33591
        uint n = createNumberWithInput(bytes(_stringInput), number);
        number = n;
        return n;
    }

    // gas 29618 (34061)
    // "s" 33001 gas (28696)
    function create5(string memory _stringInput) public returns (uint256) { // gas 33591
        uint n = createNumberWithInput2(bytes(_stringInput), number);
        number = n;
        return n;
    }

    // "s" 32575 gas (28326)
    function create6(string calldata _stringInput) public returns (uint256) { // gas 33591
        uint n = createNumberWithInput2(bytes(_stringInput), number);
        number = n;
        return n;
    }

    // "s" 32309 gas (28094)
    function create7(string calldata _stringInput) public returns (uint256) { // gas 33591
        uint n = createNumberWithInput5(bytes(_stringInput), number);
        number = n;
        return n;
    }

    // "s" 32259 gas (28051)
    function create8(string calldata _stringInput) public returns (uint256) { // gas 33591
        number = uint(keccak256(abi.encode(uint64(number), uint64(block.timestamp), bytes16(bytes(_stringInput)))));
        return number;
    }

    // "s" 32309 gas (28094)
    function create9(string calldata _stringInput) public returns (uint256) { // gas 33591
        uint n = uint(keccak256(abi.encode(uint64(number), uint64(block.timestamp), bytes16(bytes(_stringInput)))));
        number = n;
        return n;
    }

    // ^^^ This makes no sense to me
    // somehow with different input params
    // we come to different gas results
    // must try different EVM

    // "s" 32997 gas (28693)
    function create3(string memory _stringInput) public returns (uint256) { // gas 33546
        number = uint(keccak256(abi.encode(uint64(number), uint64(block.timestamp), bytes16(bytes(_stringInput)))));
        return number;
    }

    // "s" 32986 gas (28683)
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

    function convert() public view returns (bytes memory) {
        return abi.encode(msg.sender);
    }

}
