// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/Token.sol";
import "../src/Exchange.sol";

contract ExchangeTest is Test {
    Token token;
    Exchange exchange;

    address buyer = address(1);
    address seller = address(2);

    function setUp() public {
        token = new Token("Token", "TKN");

        exchange = new Exchange(address(token));

        vm.deal(buyer, 100 ether);

        token.mint(seller, 1000 ether);

        // deposit ETH
        vm.prank(buyer);
        exchange.depositETH{value: 10 ether}();

        // deposit token
        vm.prank(seller);
        exchange.depositToken(100 ether);
    }

    function testOrderMatching() public {
        // buyer bids higher
        vm.prank(buyer);
        exchange.placeBuyOrder(1 ether, 5);

        // seller asks lower
        vm.prank(seller);
        exchange.placeSellOrder(0.5 ether, 5);

        // buyer should receive tokens
        assertEq(
            exchange.tokenBalance(buyer),
            5
        );

        // seller receives ETH
        assertEq(
            exchange.ethBalance(seller),
            2.5 ether
        );
    }

    function testPartialFill() public {
        vm.prank(buyer);
        exchange.placeBuyOrder(1 ether, 10);

        vm.prank(seller);
        exchange.placeSellOrder(1 ether, 5);

        assertEq(
            exchange.tokenBalance(buyer),
            5
        );
    }
}