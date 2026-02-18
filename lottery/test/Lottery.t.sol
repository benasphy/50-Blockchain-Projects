// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Lottery.sol";

contract LotteryTest is Test {
    Lottery lottery;

    address player1 = address(0x1);
    address player2 = address(2);
    address player3 = address(3);

    function setUp() public {
        lottery = new Lottery();

        vm.deal(player1, 1 ether);
        vm.deal(player2, 1 ether);
        vm.deal(player3, 1 ether);
    }

    function testEnterLottery() public {
        vm.prank(player1);
        lottery.enter{value: 0.01 ether}();

        assertEq(lottery.getPlayers().length, 1);
    }

    function testPickWinner() public {
        vm.prank(player1);
        lottery.enter{value: 0.01 ether}();

        vm.prank(player2);
        lottery.enter{value: 0.01 ether}();

        vm.prank(player3);
        lottery.enter{value: 0.01 ether}();

        uint256 balanceBefore = address(player1).balance +
            address(player2).balance +
            address(player3).balance;

        lottery.pickWinner();

        uint256 balanceAfter = address(player1).balance +
            address(player2).balance +
            address(player3).balance;

        // ETH conserved
        assertEq(balanceAfter, balanceBefore);
        assertEq(lottery.getPlayers().length, 0);
    }
}
