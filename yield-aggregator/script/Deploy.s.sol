// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/Token.sol";
import "../src/Strategy.sol";
import "../src/Vault.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Token token = new Token();

        Strategy strategy =
            new Strategy(address(token));

        Vault vault = new Vault(
            address(token),
            address(strategy)
        );

        token.mint(msg.sender, 1000 ether);

        vm.stopBroadcast();
    }
}