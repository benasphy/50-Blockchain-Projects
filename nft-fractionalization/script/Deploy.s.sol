// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/MockNFT.sol";
import "../src/FractionVault.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        MockNFT nft =
            new MockNFT();

        FractionVault vault =
            new FractionVault(
                address(nft)
            );

        vm.stopBroadcast();
    }
}