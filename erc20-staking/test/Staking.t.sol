// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/StakeToken.sol";
import "../src/Staking.sol";

contract StakingTest is Test {
    StakeToken token;
    Staking staking;

    address alice = address(1);

    function setUp() public {
        token = new StakeToken(1_000_000 ether);
        staking = new Staking(address(token));

        token.transfer(alice, 1000 ether);

        vm.prank(alice);
        token.approve(address(staking), 1000 ether);
    }

    function testStakeAndEarn() public {
        vm.prank(alice);
        staking.stake(100 ether);

        vm.warp(block.timestamp + 10);

        uint256 reward = staking.earned(alice);
        assertGt(reward, 0);
    }
}