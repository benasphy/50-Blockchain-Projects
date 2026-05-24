// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/MockNFT.sol";
import "../src/FractionVault.sol";
import "../src/FractionToken.sol";

contract FractionTest is Test {
    MockNFT nft;

    FractionVault vault;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        nft = new MockNFT();

        vault =
            new FractionVault(
                address(nft)
            );

        vm.deal(alice, 100 ether);
    }

    function testFractionalization()
        public
    {
        vm.startPrank(alice);

        uint256 tokenId =
            nft.mint(alice);

        nft.approve(
            address(vault),
            tokenId
        );

        vault.fractionalize(
            tokenId,
            1000 ether,
            "Fraction Token",
            "F-NFT"
        );

        FractionToken token =
            FractionToken(
                vault
                    .fractionalTokenAddress()
            );

        assertEq(
            token.balanceOf(alice),
            1000 ether
        );

        assertEq(
            nft.ownerOf(tokenId),
            address(vault)
        );

        vm.stopPrank();
    }

    function testRedeemNFT()
        public
    {
        vm.startPrank(alice);

        uint256 tokenId =
            nft.mint(alice);

        nft.approve(
            address(vault),
            tokenId
        );

        vault.fractionalize(
            tokenId,
            1000 ether,
            "Fraction Token",
            "F-NFT"
        );

        vault.redeem();

        assertEq(
            nft.ownerOf(tokenId),
            alice
        );

        vm.stopPrank();
    }

    function testCannotRedeemPartial()
        public
    {
        vm.startPrank(alice);

        uint256 tokenId =
            nft.mint(alice);

        nft.approve(
            address(vault),
            tokenId
        );

        vault.fractionalize(
            tokenId,
            1000 ether,
            "Fraction Token",
            "F-NFT"
        );

        FractionToken token =
            FractionToken(
                vault
                    .fractionalTokenAddress()
            );

        token.transfer(
            bob,
            500 ether
        );

        vm.expectRevert();

        vault.redeem();

        vm.stopPrank();
    }
}