// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyNFT.sol";

contract MyNFTTest is Test {

    MyNFT nft;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        nft = new MyNFT();

        // Mint 1 NFT to Alice
        nft.mint(alice, "https://metadata/1.json");
    }

    function testMint() public {
        uint256 supply = nft.totalSupply();
        assertEq(supply, 1);

        address owner = nft.ownerOf(1);
        assertEq(owner, alice);

        string memory uri = nft.tokenURI(1);
        assertEq(uri, "https://metadata/1.json");
    }

    function testTransfer() public {
        vm.prank(alice);
        nft.transferFrom(alice, bob, 1);

        assertEq(nft.ownerOf(1), bob);
        assertEq(nft.balanceOf(alice), 0);
        assertEq(nft.balanceOf(bob), 1);
    }

    function testApproval() public {
        vm.prank(alice);
        nft.approve(bob, 1);

        address approved = nft.getApproved(1);
        assertEq(approved, bob);

        vm.prank(bob);
        nft.transferFrom(alice, bob, 1);

        assertEq(nft.ownerOf(1), bob);
    }
}