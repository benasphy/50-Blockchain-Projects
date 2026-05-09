// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/BridgeB.sol";

contract Relay is Script {
    function run() external {
        vm.startBroadcast();

        BridgeB bridge = BridgeB(
            vm.envAddress("BRIDGE_B")
        );

        address user = vm.envAddress("USER");

        uint256 amount = vm.envUint("AMOUNT");
        uint256 nonce = vm.envUint("NONCE");

        bridge.mint(user, amount, nonce);

        vm.stopBroadcast();
    }
}