// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter counter;
    address owner = address(this);
    address attacker = address(0xBEEF);

    function setUp() public {
        counter = new Counter();
    }

    function testInitialCounterIsZero() public {
        assertEq(counter.getCounter(), 0);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.getCounter(), 1);
    }

    function testDecrement() public {
        counter.increment();
        counter.decrement();
        assertEq(counter.getCounter(), 0);
    }

    function test_Revert_When_DecrementWhenZero() public {
        // This test PASSES only if decrement reverts
        counter.decrement();
    }

    function testOnlyOwnerCanIncrement() public {
        vm.prank(attacker);
        vm.expectRevert("Not owner");
        counter.increment();
    }

    function testOverflowReverts() public {
        // Set counter to max uint256
        vm.store(
            address(counter),
            bytes32(uint256(0)),
            bytes32(type(uint256).max)
        );

        vm.expectRevert();
        counter.increment();
    }
}
