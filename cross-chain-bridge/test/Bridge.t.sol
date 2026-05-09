// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/Token.sol";
import "../src/WrappedToken.sol";
import "../src/BridgeA.sol";
import "../src/BridgeB.sol";

contract BridgeTest is Test {
    Token token;
    WrappedToken wrapped;

    BridgeA bridgeA;
    BridgeB bridgeB;

    address user = address(1);

    function setUp() public {
        token = new Token();

        wrapped = new WrappedToken();

        bridgeA = new BridgeA(address(token));

        bridgeB = new BridgeB(address(wrapped));

        token.mint(user, 100 ether);
    }

    function testBridgeFlow() public {
        vm.startPrank(user);

        // lock on chain A
        bridgeA.lock(10 ether);

        vm.stopPrank();

        // relayer mints on chain B
        bridgeB.mint(user, 10 ether, 0);

        assertEq(wrapped.balanceOf(user), 10 ether);
    }

    function testReplayProtection() public {
        bridgeB.mint(user, 5 ether, 1);

        vm.expectRevert();

        // same nonce again
        bridgeB.mint(user, 5 ether, 1);
    }
}