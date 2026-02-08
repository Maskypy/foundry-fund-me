// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    modifier onlyOwner() {
        require(msg.sender == i_owner, " Sender is not owner!");
        _;
    }

    constructor() {
        i_owner = msg.sender;
    }

    // Functions to be implemented
    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
    function withdraw() public onlyOwner {}
}
