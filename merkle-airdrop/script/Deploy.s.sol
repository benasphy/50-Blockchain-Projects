// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyToken.sol";
import "../src/MerkleAirdrop.sol";

contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        MyToken token = new MyToken(1_000_000 ether);

        // Replace with actual Merkle root (generated off-chain)
        bytes32 root = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

        MerkleAirdrop airdrop = new MerkleAirdrop(address(token), root);

        // Fund contract
        token.transfer(address(airdrop), 100_000 ether);

        vm.stopBroadcast();
    }
}