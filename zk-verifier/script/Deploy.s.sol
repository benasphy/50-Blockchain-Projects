// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Verifier.sol";
import "../src/ZKApp.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Verifier verifier = new Verifier();
        new ZKApp(address(verifier));

        vm.stopBroadcast();
    }
}