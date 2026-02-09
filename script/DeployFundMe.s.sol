//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external {
        HelperConfig helperConfig = new HelperConfig();
        address priceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast(); // Broadcast transactions to the network
        new FundMe(priceFeed);
        vm.stopBroadcast(); // Stop broadcasting transactions
    }
}
