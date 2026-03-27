// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Token.sol";
import "../src/SimpleAMM.sol";

contract AMMTest is Test {

    Token tokenA;
    Token tokenB;
    SimpleAMM amm;

    address user = address(1);

    function setUp() public {

        tokenA = new Token("A", "A", 1_000_000 ether);
        tokenB = new Token("B", "B", 1_000_000 ether);

        amm = new SimpleAMM(address(tokenA), address(tokenB));

        tokenA.transfer(user, 1000 ether);
        tokenB.transfer(user, 1000 ether);

        vm.startPrank(user);
        tokenA.approve(address(amm), type(uint256).max);
        tokenB.approve(address(amm), type(uint256).max);
        vm.stopPrank();
    }

    function testAddLiquidity() public {

        vm.prank(user);
        amm.addLiquidity(100 ether, 100 ether);

        assertGt(amm.totalShares(), 0);
    }

    function testSwap() public {

        vm.startPrank(user);
        amm.addLiquidity(100 ether, 100 ether);

        amm.swapAforB(10 ether);
        vm.stopPrank();

        assertGt(tokenB.balanceOf(user), 0);
    }
}