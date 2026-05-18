// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/MEVAuction.sol";

contract AuctionTest is Test {
    MEVAuction auction;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        auction =
            new MEVAuction(
                1 days,
                1 days
            );

        vm.deal(alice, 100 ether);
        vm.deal(bob, 100 ether);
    }

    function testCommitRevealAuction()
        public
    {
        bytes32 aliceCommit =
            keccak256(
                abi.encodePacked(
                    10 ether,
                    "alice-secret"
                )
            );

        bytes32 bobCommit =
            keccak256(
                abi.encodePacked(
                    20 ether,
                    "bob-secret"
                )
            );

        // commit phase
        vm.prank(alice);

        auction.commitBid{
            value: 10 ether
        }(aliceCommit);

        vm.prank(bob);

        auction.commitBid{
            value: 20 ether
        }(bobCommit);

        // move to reveal
        vm.warp(
            block.timestamp + 2 days
        );

        vm.prank(alice);

        auction.revealBid(
            10 ether,
            "alice-secret"
        );

        vm.prank(bob);

        auction.revealBid(
            20 ether,
            "bob-secret"
        );

        // finalize
        vm.warp(
            block.timestamp + 2 days
        );

        auction.finalize();

        assertEq(
            auction.highestBidder(),
            bob
        );
    }

    function testInvalidRevealFails()
        public
    {
        bytes32 commit =
            keccak256(
                abi.encodePacked(
                    10 ether,
                    "secret"
                )
            );

        vm.prank(alice);

        auction.commitBid{
            value: 10 ether
        }(commit);

        vm.warp(
            block.timestamp + 2 days
        );

        vm.prank(alice);

        vm.expectRevert();

        auction.revealBid(
            10 ether,
            "wrong-secret"
        );
    }
}