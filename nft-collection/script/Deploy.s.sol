// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyNFT.sol";

contract Deploy is Script {

    function run() external {
        vm.startBroadcast();

        MyNFT nft = new MyNFT();

        // Example minting to deployer
        nft.mint(msg.sender, "https://my-nft.io/metadata/1.json");

        vm.stopBroadcast();
    }
}