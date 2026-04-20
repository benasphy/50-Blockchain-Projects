// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Exchange.sol";

contract FrontRunTest is Test {
    Exchange ex;

    address user = address(1);
    address attacker = address(2);

    function setUp() public {
        ex = new Exchange();

        vm.deal(user, 10 ether);
        vm.deal(attacker, 10 ether);
    }

    function testFrontRun() public {
        // user sees price = 1 ETH
        vm.prank(user);
        ex.buy{value: 1 ether}();

        // attacker front-runs
        vm.prank(attacker);
        ex.setPrice(2 ether);

        // user's tx would now fail or be worse
    }
}