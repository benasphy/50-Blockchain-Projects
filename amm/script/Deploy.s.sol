// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Token.sol";
import "../src/SimpleAMM.sol";

contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        Token tokenA = new Token("TokenA", "TKA", 1_000_000 ether);
        Token tokenB = new Token("TokenB", "TKB", 1_000_000 ether);

        SimpleAMM amm = new SimpleAMM(address(tokenA), address(tokenB));

        vm.stopBroadcast();
    }
}