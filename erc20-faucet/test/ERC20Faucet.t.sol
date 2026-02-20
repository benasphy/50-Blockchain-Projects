// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/FaucetToken.sol";
import "../src/ERC20Faucet.sol";

contract ERC20FaucetTest is Test {
    FaucetToken token;
    ERC20Faucet faucet;

    address alice = address(1);

    function setUp() public {
        token = new FaucetToken();
        faucet = new ERC20Faucet(address(token));

        token.setFaucet(address(faucet));
    }

    function testClaim() public {
        vm.prank(alice);
        faucet.claim();

        assertEq(token.balanceOf(alice), 100 ether);
    }

    function testCooldown() public {
        vm.prank(alice);
        faucet.claim();

        vm.prank(alice);
        vm.expectRevert();
        faucet.claim();
    }
}