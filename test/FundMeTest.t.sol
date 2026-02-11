//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 1e18; // 1 ETH

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}(); // Fund with 1 ETH
        _;
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE); // Give USER 10 ETH to use in tests
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(FundMe.FundMe__NotEnoughETH.selector);
        fundMe.fund(); // Call fund without sending any ETH, should revert
    }

    function testFundUpdatesFundersData() public funded {
        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_VALUE); // Check that the mapping is updated
        assertEq(fundMe.getFunder(0), USER); // Check that the funder is added to the array
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert(FundMe.FundMe__NotOwner.selector);
        vm.prank(USER); // Set msg.sender to USER
        fundMe.withdraw(); // Attempt to withdraw as USER, should revert
    }

    function testWithdrawWithSingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingcontractBalance = address(fundMe).balance;
        // Act
        vm.prank(fundMe.getOwner()); // Set msg.sender to the owner
        fundMe.withdraw();
        // Assert
        uint256 finalOwnerBalance = fundMe.getOwner().balance;
        uint256 finalContractBalance = address(fundMe).balance;
        assertEq(finalContractBalance, 0);
        assertEq(finalOwnerBalance, startingOwnerBalance + startingcontractBalance);
    }

    function testWithdrawWithMultipleFunders() public {
        // Arrange
        uint256 numberOfFunders = 10;
        for (uint256 i = 0; i < numberOfFunders; i++) {
            address funder = address(uint160(i + 1)); // Create unique funder addresses
            hoax(funder, STARTING_BALANCE); // Give each funder 10 ETH
            fundMe.fund{value: SEND_VALUE}(); // Each funder sends 1 ETH
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingcontractBalance = address(fundMe).balance;
        // Act
        vm.prank(fundMe.getOwner()); // Set msg.sender to the owner
        fundMe.withdraw();
        // Assert
        uint256 finalOwnerBalance = fundMe.getOwner().balance;
        uint256 finalContractBalance = address(fundMe).balance;
        assertEq(finalContractBalance, 0);
        assertEq(finalOwnerBalance, startingOwnerBalance + startingcontractBalance);
    }
}
