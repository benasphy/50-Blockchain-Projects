// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/Token.sol";
import "../src/Strategy.sol";
import "../src/Vault.sol";

contract VaultTest is Test {
    Token token;

    Strategy strategy;

    Vault vault;

    address alice = address(1);

    function setUp() public {
        token = new Token();

        strategy = new Strategy(address(token));

        vault = new Vault(
            address(token),
            address(strategy)
        );

        token.mint(alice, 1000 ether);
    }

    function testDeposit() public {
        vm.prank(alice);

        vault.deposit(100 ether);

        assertEq(
            vault.shares(alice),
            100 ether
        );
    }

    function testYieldGrowth() public {
        vm.startPrank(alice);

        vault.deposit(100 ether);

        vm.stopPrank();

        // strategy earns yield
        strategy.simulateYield(50 ether);

        uint256 sharePrice =
            vault.sharePrice();

        assertGt(sharePrice, 1e18);
    }

    function testWithdrawWithProfit()
        public
    {
        vm.startPrank(alice);

        vault.deposit(100 ether);

        vm.stopPrank();

        strategy.simulateYield(100 ether);

        uint256 shares =
            vault.shares(alice);

        vm.prank(alice);

        vault.withdraw(shares);

        // user should gain profit
        assertGt(
            token.balanceOf(alice),
            1000 ether
        );
    }
}