// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Auction.sol";

contract DeployAuction is Script {
    function run() external {
        vm.startBroadcast();

        Auction auction = new Auction(300); // 5 min auction

        vm.stopBroadcast();
    }
}
