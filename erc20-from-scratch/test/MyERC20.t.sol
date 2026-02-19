// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyERC20.sol";

contract MyERC20Test is Test {
    MyERC20 token;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        token = new MyERC20("MyToken", "MTK", 18, 1000 ether);
    }

    function testInitialSupply() public {
        assertEq(token.totalSupply(), 1000 ether);
        assertEq(token.balanceOf(address(this)), 1000 ether);
    }

    function testTransfer() public {
        token.transfer(alice, 100 ether);

        assertEq(token.balanceOf(alice), 100 ether);
        assertEq(token.balanceOf(address(this)), 900 ether);
    }

    function testApproveAndTransferFrom() public {
        token.transfer(alice, 200 ether);

        vm.prank(alice);
        token.approve(bob, 100 ether);

        vm.prank(bob);
        token.transferFrom(alice, bob, 50 ether);

        assertEq(token.balanceOf(bob), 50 ether);
        assertEq(token.allowance(alice, bob), 50 ether);
    }
}
