// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/MerkleAirdrop.sol";

contract AirdropTest is Test {

    MyToken token;
    MerkleAirdrop airdrop;

    address user = address(1);

    // Precomputed values (example)
    bytes32 root;
    bytes32[] proof;

    function setUp() public {

        token = new MyToken(1_000_000 ether);

        // Simulate simple tree (single leaf case)
        root = keccak256(abi.encodePacked(user, 100 ether));

        airdrop = new MerkleAirdrop(address(token), root);

        token.transfer(address(airdrop), 100 ether);
    }

    function testClaim() public {

        vm.prank(user);
        airdrop.claim(100 ether, new bytes32);

        assertEq(token.balanceOf(user), 100 ether);
    }

    function testDoubleClaimFails() public {

        vm.startPrank(user);
        airdrop.claim(100 ether, new bytes32);

        vm.expectRevert();
        airdrop.claim(100 ether, new bytes32);
    }
}