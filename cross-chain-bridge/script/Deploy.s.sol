// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/Token.sol";
import "../src/WrappedToken.sol";
import "../src/BridgeA.sol";
import "../src/BridgeB.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Token token = new Token();

        WrappedToken wrapped = new WrappedToken();

        BridgeA bridgeA = new BridgeA(address(token));

        BridgeB bridgeB = new BridgeB(address(wrapped));

        token.mint(msg.sender, 1000 ether);

        vm.stopBroadcast();
    }
}