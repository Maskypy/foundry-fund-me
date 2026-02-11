// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    error FundMe__NotOwner();
    error FundMe__NotEnoughETH();
    error FundMe__CallFailed();

    using PriceConverter for uint256;
    address private immutable i_owner;
    address[] private s_funders;
    AggregatorV3Interface private s_priceFeed;
    mapping(address => uint256) private s_addressToAmountFunded;
    uint256 public constant MINIMUM_USD = 5e18;

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
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // Copy array to memory to save gas
        address[] memory memoryFunders = s_funders;
        // Loop through memory array instead of storage array to save gas
        for (uint256 i = 0; i < memoryFunders.length; i++) {
            address funder = memoryFunders[i];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess,) = payable(i_owner).call{value: address(this).balance}("");
        if (!callSuccess) {
            revert FundMe__CallFailed();
        }
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(address funder) external view returns (uint256) {
        return s_addressToAmountFunded[funder];
    }

    function getPriceFeed() external view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
