// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/RoyaltyNFT.sol";
import "../src/RoyaltyMarketplace.sol";

contract RoyaltyTest is Test {

    RoyaltyNFT nft;
    RoyaltyMarketplace market;

    address creator = address(1);
    address buyer = address(2);

    function setUp() public {
        nft = new RoyaltyNFT();
        market = new RoyaltyMarketplace(address(nft));

        vm.prank(creator);
        nft.mint(creator, 500); // 5%

        vm.deal(buyer, 10 ether);
    }

    function testRoyaltyPayment() public {

        vm.startPrank(creator);
        nft.approve(address(market), 1);
        market.list(1, 1 ether);
        vm.stopPrank();

        uint256 creatorBalanceBefore = creator.balance;

        vm.prank(buyer);
        market.buy{value: 1 ether}(1);

        uint256 royaltyExpected = (1 ether * 500) / 10000;

        assertEq(creator.balance, creatorBalanceBefore + royaltyExpected);
        assertEq(nft.ownerOf(1), buyer);
    }
}