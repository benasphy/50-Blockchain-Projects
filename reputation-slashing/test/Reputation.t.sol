// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/Token.sol";
import "../src/ReputationSystem.sol";

contract ReputationTest is Test {
    Token token;

    ReputationSystem system;

    address alice = address(1);

    function setUp() public {
        token = new Token();

        system =
            new ReputationSystem(
                address(token)
            );

        token.mint(
            alice,
            1000 ether
        );
    }

    function testRegisterAndStake()
        public
    {
        vm.startPrank(alice);

        system.register();

        system.stake(
            100 ether
        );

        (
            uint256 stake,
            uint256 reputation,
            ,
            bool registered
        ) = system.users(alice);

        assertTrue(registered);

        assertEq(
            stake,
            100 ether
        );

        assertGt(reputation, 0);

        vm.stopPrank();
    }

    function testEarnReputation()
        public
    {
        vm.startPrank(alice);

        system.register();

        system.completeAction();

        uint256 score =
            system.reputationScore(
                alice
            );

        assertGt(score, 0);

        vm.stopPrank();
    }

    function testSlashing()
        public
    {
        vm.startPrank(alice);

        system.register();

        system.stake(
            100 ether
        );

        vm.stopPrank();

        system.slash(
            alice,
            50 ether,
            20
        );

        (
            uint256 stake,
            uint256 reputation,
            ,

        ) = system.users(alice);

        assertEq(
            stake,
            50 ether
        );

        assertLt(reputation, 100);
    }

    function testCannotOverSlash()
        public
    {
        vm.startPrank(alice);

        system.register();

        system.stake(
            100 ether
        );

        vm.stopPrank();

        vm.expectRevert();

        system.slash(
            alice,
            1000 ether,
            10
        );
    }
}