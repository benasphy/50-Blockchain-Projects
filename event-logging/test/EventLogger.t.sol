// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EventLogger.sol";

contract EventLoggerTest is Test {
    EventLogger logger;

    address user = address(1);

    function setUp() public {
        logger = new EventLogger();
        vm.deal(user, 1 ether);
    }

    function testUserRegisteredEvent() public {
        vm.prank(user);

        vm.expectEmit(true, false, false, true);
        emit EventLogger.UserRegistered(user, "Alice");

        logger.registerUser("Alice");
    }

    function testDepositEvent() public {
        vm.prank(user);

        vm.expectEmit(true, false, true, true);
        emit EventLogger.Deposit(user, 1 ether, block.timestamp);

        logger.deposit{value: 1 ether}();
    }
}
