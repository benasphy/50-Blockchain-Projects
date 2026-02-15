// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Crowdfunding.sol";

contract DeployCrowdfunding is Script {
    function run() external {
        vm.startBroadcast();

        Crowdfunding campaign = new Crowdfunding(
            10 ether,  // funding goal
            7 days     // duration
        );

        vm.stopBroadcast();
    }
}
