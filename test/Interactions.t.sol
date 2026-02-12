//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {FundMe} from "../src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../script/Interactions.s.sol";

contract InteractionTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
    }

    function testUserCanFundandWithdraw() external {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        address Funder = fundMe.getFunder(0);
        assertEq(Funder, msg.sender);

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        uint256 endingBalance = address(fundMe).balance;
        assertEq(endingBalance, 0);
    }
}
