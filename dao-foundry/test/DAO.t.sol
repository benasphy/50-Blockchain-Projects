// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GovToken.sol";
import "../src/DAO.sol";
import "../src/Treasury.sol";

contract DAOTest is Test {
    GovToken token;
    DAO dao;
    Treasury treasury;

    address user = address(1);

    function setUp() public {
        token = new GovToken();
        dao = new DAO(address(token));
        treasury = new Treasury(address(dao));

        dao.setTreasury(address(treasury));

        token.mint(user, 100 ether);

        vm.deal(address(treasury), 10 ether);
    }

    function testFullFlow() public {
        vm.startPrank(user);

        // proposal: send ETH
        uint256 id = dao.propose(
            user,
            1 ether,
            "",
            "Send ETH"
        );

        dao.vote(id, true);

        vm.warp(block.timestamp + 4 days);

        dao.execute(id);

        vm.stopPrank();

        assertEq(user.balance, 1 ether);
    }
}