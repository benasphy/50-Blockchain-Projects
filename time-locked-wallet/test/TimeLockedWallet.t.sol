// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TimeLockedWallet.sol";

contract TimeLockedWalletTest is Test {
    TimeLockedWallet wallet;

    address owner = address(0x1);
    address alice = address(0x2);

    uint256 unlockTime;

    function setUp() public {
        unlockTime = block.timestamp + 7 days;

        vm.prank(owner);
        wallet = new TimeLockedWallet{value: 1 ether}(unlockTime);
    }

    function testCannotWithdrawBeforeUnlock() public {
        vm.prank(owner);
        vm.expectRevert("Funds are locked");
        wallet.withdraw();
    }

    function testWithdrawAfterUnlock() public {
        // fast-forward time
        vm.warp(unlockTime + 1);

        uint256 ownerBalanceBefore = owner.balance;

        vm.prank(owner);
        wallet.withdraw();

        assertEq(owner.balance, ownerBalanceBefore + 1 ether);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.warp(unlockTime + 1);

        vm.prank(alice);
        vm.expectRevert("Not owner");
        wallet.withdraw();
    }

    function testTimeLeft() public {
        uint256 remaining = wallet.timeLeft();
        assertGt(remaining, 0);

        vm.warp(unlockTime);
        assertEq(wallet.timeLeft(), 0);
    }
}
