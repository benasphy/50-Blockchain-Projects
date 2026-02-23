// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GovToken.sol";
import "../src/DAO.sol";

contract DAOTest is Test {

    GovToken token;
    DAO dao;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        token = new GovToken(1_000_000 ether);
        dao = new DAO(address(token));

        token.transfer(alice, 500 ether);
        token.transfer(bob, 200 ether);
    }

    function testGovernanceFlow() public {

        vm.prank(alice);
        dao.createProposal("Increase treasury budget");

        vm.prank(alice);
        dao.vote(1, true);

        vm.prank(bob);
        dao.vote(1, true);

        vm.warp(block.timestamp + 4 days);

        dao.execute(1);

        (,,,,uint256 forVotes,,bool executed) = dao.proposals(1);

        assertTrue(executed);
        assertEq(forVotes, 700 ether);
    }
}