//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, 10 ether); // Give USER 10 ETH to use in tests
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(FundMe.FundMe__NotEnoughETH.selector);
        fundMe.fund(); // Call fund without sending any ETH, should revert
    }

    function testFundUpdatesFundersData() public {
        vm.prank(USER); // Set the next call to be from USER
        fundMe.fund{value: 1e18}(); // Fund with 1 ETH
        assertEq(fundMe.addressToAmountFunded(USER), 1e18); // Check that the mapping is updated
        assertEq(fundMe.funders(0), USER); // Check that the funder is added to the array
    }
}
