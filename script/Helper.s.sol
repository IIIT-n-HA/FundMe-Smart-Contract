// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggreggator.sol";

contract Helper is Script {
    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public active;

    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) active = getSepoliaEthConfig();
        else if (block.chainid == 1) active = getMainnetEthConfig();
        else active = getOrCreateAnvilEthConfig();
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ans = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return ans;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ans = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ans;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (active.priceFeed != address(0)) return active; // If we have already deployed a price feed. Else go for mock deployment
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL,
            INITIAL_PRICE
        );
        vm.stopBroadcast();
        NetworkConfig memory ans = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return ans;
    }
}
