// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GameAssets.sol";

contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        GameAssets assets =
            new GameAssets("ipfs://game-assets/");

        vm.stopBroadcast();
    }
}