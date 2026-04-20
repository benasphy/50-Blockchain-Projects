// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Vault.sol";
import "../src/Token.sol";
import "../src/Exchange.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        new Vault();
        new Token();
        new Exchange();

        vm.stopBroadcast();
    }
}