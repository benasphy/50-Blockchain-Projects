// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/Token.sol";
import "../src/InsurancePool.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Token token = new Token();

        InsurancePool pool =
            new InsurancePool(address(token));

        token.mint(msg.sender, 1_000_000 ether);

        vm.stopBroadcast();
    }
}