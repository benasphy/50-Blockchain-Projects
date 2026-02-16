// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/EventLogger.sol";

contract DeployEventLogger is Script {
    function run() external {
        vm.startBroadcast();

        EventLogger logger = new EventLogger();

        vm.stopBroadcast();
    }
}
