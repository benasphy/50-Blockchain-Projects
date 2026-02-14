// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Auction.sol";

contract AuctionTest is Test {
    Auction auction;

    address bidder1 = address(1);
    address bidder2 = address(2);

    function setUp() public {
        auction = new Auction(60); // 60 sec auction

        vm.deal(bidder1, 10 ether);
        vm.deal(bidder2, 10 ether);
    }

    function testBidIncreases() public {
        vm.prank(bidder1);
        auction.bid{value: 1 ether}();

        assertEq(auction.highestBid(), 1 ether);
        assertEq(auction.highestBidder(), bidder1);
    }

    function testOutbidRefund() public {
        vm.prank(bidder1);
        auction.bid{value: 1 ether}();

        vm.prank(bidder2);
        auction.bid{value: 2 ether}();

        assertEq(auction.pendingReturns(bidder1), 1 ether);
    }

    function testWithdraw() public {
        vm.prank(bidder1);
        auction.bid{value: 1 ether}();

        vm.prank(bidder2);
        auction.bid{value: 2 ether}();

        vm.prank(bidder1);
        auction.withdraw();

        assertEq(auction.pendingReturns(bidder1), 0);
    }

    function testEndAuction() public {
        vm.prank(bidder1);
        auction.bid{value: 1 ether}();

        vm.warp(block.timestamp + 61);

        auction.endAuction();

        assertTrue(auction.ended());
    }
}
