// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/RoyaltyNFT.sol";
import "../src/RoyaltyMarketplace.sol";

contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        RoyaltyNFT nft = new RoyaltyNFT();
        RoyaltyMarketplace market = new RoyaltyMarketplace(address(nft));

        vm.stopBroadcast();
    }
}