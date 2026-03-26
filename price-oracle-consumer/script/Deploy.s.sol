// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/PriceConsumer.sol";

contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        // Example: Sepolia ETH/USD feed
        address feed = 0x694A1769357215DE4FAC081bf1f309aDC325306;

        PriceConsumer consumer = new PriceConsumer(feed);

        vm.stopBroadcast();
    }
}