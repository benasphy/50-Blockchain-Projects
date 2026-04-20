// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract OverflowTest is Test {
    Token token;

    function setUp() public {
        token = new Token();
    }

    function testOverflow() public {
        token.mint(type(uint256).max);

        // overflow
        token.mint(1);

        assertEq(token.balances(address(this)), 0);
    }
}