// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
error FundMe__NotOwner();
error FundMe__NotEnoughETH();

contract FundMe {
    using PriceConverter for uint256;
    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;
    address[] public funders;
    AggregatorV3Interface private s_priceFeed;
    mapping(address => uint256) public addressToAmountFunded;

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    constructor(address priceFeed) {
        // Set the price feed address
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    function fund() public payable {
        if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD) {
            revert FundMe__NotEnoughETH();
        }
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
    // Functions to be implemented
    function withdraw() public onlyOwner {}
}
