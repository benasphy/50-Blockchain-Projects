// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Voting.sol";

contract VotingTest is Test {
    Voting voting;

    address owner = address(0x1);
    address alice = address(0x2);
    address bob   = address(0x3);

    function setUp() public {
        vm.prank(owner);
        voting = new Voting();

        vm.prank(owner);
        voting.addCandidate("Alice");

        vm.prank(owner);
        voting.addCandidate("Bob");
    }

    function testVoteSuccessfully() public {
        vm.prank(alice);
        voting.vote(0);

        (, uint256 votes) = voting.getCandidate(0);
        assertEq(votes, 1);
    }

    function testPreventDoubleVoting() public {
        vm.startPrank(alice);
        voting.vote(0);

        vm.expectRevert("Already voted");
        voting.vote(1);
        vm.stopPrank();
    }

    function testDifferentUsersCanVote() public {
        vm.prank(alice);
        voting.vote(0);

        vm.prank(bob);
        voting.vote(1);

        (, uint256 votesA) = voting.getCandidate(0);
        (, uint256 votesB) = voting.getCandidate(1);

        assertEq(votesA, 1);
        assertEq(votesB, 1);
    }

    function testInvalidCandidateReverts() public {
        vm.prank(alice);
        vm.expectRevert("Invalid candidate");
        voting.vote(10);
    }
}
