// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/Token.sol";
import "../src/Exchange.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Token token = new Token(
            "Exchange Token",
            "EXT"
        );

        Exchange exchange = new Exchange(
            address(token)
        );

        vm.stopBroadcast();
    }
}