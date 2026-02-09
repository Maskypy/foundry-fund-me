// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If we are on a local anvil chain, we want to use the mock price feed address
    // Otherwise, we will use the real price feed address
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // Check if we have a price feed address already
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        // Deploy the mocks
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();

        return NetworkConfig({
            priceFeed: address(mockPriceFeed) // Return the address of the mock price feed
        });
    }
}
