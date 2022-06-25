// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface TrueRandomInterface{

    // create
    // create function is used to generate new number
    // more importantly it refreshes state salt
    // create should be used at least once in an hour to prevent any interference from miner or code executor
    // ideally, use create once per solidity computation session
    function create()
    external returns(uint256);
    function create(bytes memory _b)
    external returns(uint256);
    function create(string memory _s)
    external returns(uint256);
    function create(address _a)
    external returns(uint256);

    // get
    // unlike create, get uses state and user defined salt without any state manipulation
    // this means get set of functions can be called as view and therefore can be used with SDKs
    // use get AFTER initial create call reset state salt
    // roughly 1/6 cheaper than create operations
    function get()
    external view returns(uint256);
    function get(bytes memory _b)
    external view returns(uint256);
    function get(string memory _s) external view returns(uint256);
    function get(address _a)
    external view returns(uint256);
}