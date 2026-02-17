// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ErrorPlayground.sol";

contract ErrorPlaygroundTest is Test {
    ErrorPlayground playground;

    address user = address(1);

    function setUp() public {
        playground = new ErrorPlayground();
        vm.deal(user, 1 ether);
    }

    // -------------------------
    // REQUIRE TESTS
    // -------------------------

    function testDepositRequireFail() public {
        vm.expectRevert("Must send ETH");
        playground.deposit();
    }

    function testOnlyOwnerFail() public {
        vm.prank(user);
        vm.expectRevert("Not owner");
        playground.onlyOwnerAction();
    }

    // -------------------------
    // REVERT TESTS
    // -------------------------

    function testCustomErrorUnauthorized() public {
        vm.prank(user);
        vm.expectRevert(
            abi.encodeWithSelector(
                ErrorPlayground.Unauthorized.selector,
                user
            )
        );

        playground.restrictedAction();
    }

    function testCustomErrorValueTooSmall() public {
        vm.prank(user);
        vm.expectRevert(
            abi.encodeWithSelector(
                ErrorPlayground.ValueTooSmall.selector,
                0,
                1 ether
            )
        );

        playground.minimumValue{value: 0}(1 ether);
    }

    // -------------------------
    // ASSERT TEST
    // -------------------------

    function testAssertFail() public {
        vm.expectRevert(); // Panic error
        playground.breakInvariant();
    }
}
