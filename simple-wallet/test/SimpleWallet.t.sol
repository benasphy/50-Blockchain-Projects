// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {SimpleWallet} from "../src/SimpleWallet.sol";

contract SimpleWalletTest is Test {
    SimpleWallet wallet;

    address owner = address(this);
    address user = address(0xBEEF);

    function setUp() public {
        wallet = new SimpleWallet();
        vm.deal(user, 10 ether);
    }

    function testOwnerIsDeployer() public {
        assertEq(wallet.owner(), owner);
    }

    function testDeposit() public {
        vm.prank(user);
        wallet.deposit{value: 1 ether}();

        assertEq(wallet.getBalance(), 1 ether);
    }

    function testReceiveETH() public {
        vm.prank(user);
        (bool success, ) = address(wallet).call{value: 2 ether}("");
        require(success);

        assertEq(address(wallet).balance, 2 ether);
    }

    function testWithdraw() public {
        // deposit first
        vm.prank(user);
        wallet.deposit{value: 3 ether}();

        uint256 ownerBalanceBefore = owner.balance;

        wallet.withdraw(1 ether);

        assertEq(address(wallet).balance, 2 ether);
        assertEq(owner.balance, ownerBalanceBefore + 1 ether);
    }

    function testWithdrawFailsIfNotOwner() public {
        vm.prank(user);
        wallet.deposit{value: 1 ether}();

        vm.prank(user);
        vm.expectRevert("Not owner");
        wallet.withdraw(1 ether);
    }
}
