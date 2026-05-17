// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/Token.sol";
import "../src/InsurancePool.sol";

contract InsuranceTest is Test {
    Token token;

    InsurancePool pool;

    address lp = address(1);

    address user = address(2);

    function setUp() public {
        token = new Token();

        pool = new InsurancePool(
            address(token)
        );

        token.mint(lp, 10000 ether);

        token.mint(user, 1000 ether);
    }

    function testProvideLiquidity()
        public
    {
        vm.prank(lp);

        pool.provideLiquidity(
            5000 ether
        );

        assertEq(
            pool.totalLiquidity(),
            5000 ether
        );
    }

    function testBuyPolicy() public {
        vm.prank(lp);

        pool.provideLiquidity(
            5000 ether
        );

        vm.prank(user);

        pool.buyPolicy(
            1000 ether,
            30 days
        );

        (
            uint256 id,
            address holder,
            uint256 coverage,
            ,
            ,
            bool active,

        ) = pool.policies(0);

        assertEq(holder, user);

        assertEq(coverage, 1000 ether);

        assertTrue(active);
    }

    function testClaim() public {
        vm.prank(lp);

        pool.provideLiquidity(
            5000 ether
        );

        vm.prank(user);

        pool.buyPolicy(
            1000 ether,
            30 days
        );

        uint256 before =
            token.balanceOf(user);

        vm.prank(user);

        pool.submitClaim(0);

        uint256 afterBal =
            token.balanceOf(user);

        assertGt(afterBal, before);
    }

    function testLPProfitFromPremiums()
        public
    {
        vm.prank(lp);

        pool.provideLiquidity(
            5000 ether
        );

        uint256 before =
            pool.sharePrice();

        vm.prank(user);

        pool.buyPolicy(
            1000 ether,
            30 days
        );

        uint256 afterPrice =
            pool.sharePrice();

        assertGt(afterPrice, before);
    }
}