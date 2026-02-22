// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/TokenVesting.sol";

contract VestingTest is Test {

    MyToken token;
    TokenVesting vesting;

    address beneficiary = address(1);

    function setUp() public {
        token = new MyToken(1_000_000 ether);
        vesting = new TokenVesting(address(token));

        token.transfer(address(vesting), 1000 ether);

        vesting.createVesting(
            beneficiary,
            1000 ether,
            uint64(block.timestamp),
            30 days,
            365 days
        );
    }

    function testCliff() public {
        vm.warp(block.timestamp + 29 days);

        vm.prank(beneficiary);
        vm.expectRevert();
        vesting.release();
    }

    function testLinearRelease() public {
        vm.warp(block.timestamp + 60 days);

        vm.prank(beneficiary);
        vesting.release();

        assertGt(token.balanceOf(beneficiary), 0);
    }

    function testFullVesting() public {
        vm.warp(block.timestamp + 365 days);

        vm.prank(beneficiary);
        vesting.release();

        assertEq(token.balanceOf(beneficiary), 1000 ether);
    }
}