// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/MEVAuction.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        new MEVAuction(
            1 days,
            1 days
        );

        vm.stopBroadcast();
    }
}