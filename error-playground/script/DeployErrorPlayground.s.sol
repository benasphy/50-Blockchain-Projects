// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ErrorPlayground.sol";

contract DeployErrorPlayground is Script {
    function run() external {
        vm.startBroadcast();

        ErrorPlayground playground = new ErrorPlayground();

        vm.stopBroadcast();
    }
}
