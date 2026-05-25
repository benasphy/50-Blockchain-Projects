// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/Token.sol";
import "../src/PredictionMarket.sol";

contract PredictionTest is Test {
    Token token;

    PredictionMarket market;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        token = new Token();

        market =
            new PredictionMarket(
                address(token)
            );

        token.mint(alice, 1000 ether);

        token.mint(bob, 1000 ether);
    }

    function testPredictionFlow()
        public
    {
        market.createMarket(
            "Will ETH hit 10k?",
            1 days
        );

        vm.prank(alice);

        market.buyYesShares(
            0,
            100 ether
        );

        vm.prank(bob);

        market.buyNoShares(
            0,
            100 ether
        );

        vm.warp(
            block.timestamp + 2 days
        );

        market.resolveMarket(
            0,
            PredictionMarket
                .Outcome
                .YES
        );

        uint256 before =
            token.balanceOf(alice);

        vm.prank(alice);

        market.claim(0);

        uint256 afterBal =
            token.balanceOf(alice);

        assertGt(afterBal, before);
    }

    function testLoserCannotClaim()
        public
    {
        market.createMarket(
            "Will ETH hit 10k?",
            1 days
        );

        vm.prank(alice);

        market.buyYesShares(
            0,
            100 ether
        );

        vm.prank(bob);

        market.buyNoShares(
            0,
            100 ether
        );

        vm.warp(
            block.timestamp + 2 days
        );

        market.resolveMarket(
            0,
            PredictionMarket
                .Outcome
                .YES
        );

        vm.prank(bob);

        vm.expectRevert();

        market.claim(0);
    }
}