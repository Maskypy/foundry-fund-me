// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {
    address public immutable i_owner;
    
    modifier onlyOwner() {
        require(msg.sender == i_owner, " Sender is not owner!");
        _;
    }

    constructor() {
        i_owner = msg.sender;
    }
    // Functions to be implemented 
    function fund() public payable {}

    function withdraw() public onlyOwner {}


}
