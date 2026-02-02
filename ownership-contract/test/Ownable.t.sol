// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyContract.sol";

contract OwnableTest is Test {
    MyContract myContract;
    address owner = address(0xABCD);
    address alice = address(0x1234);

    function setUp() public {
        // Deploy contract as owner
        vm.prank(owner);
        myContract = new MyContract();
    }

    function testOnlyOwnerCanSetValue() public {
        // Owner sets value
        vm.prank(owner);
        myContract.setValue(42);
        assertEq(myContract.value(), 42);

        // Non-owner fails
        vm.prank(alice);
        vm.expectRevert("Ownable: caller is not the owner");
        myContract.setValue(100);
    }

    function testTransferOwnership() public {
        // Transfer ownership to Alice
        vm.prank(owner);
        myContract.transferOwnership(alice);

        // New owner can set value
        vm.prank(alice);
        myContract.setValue(123);
        assertEq(myContract.value(), 123);

        // Old owner fails
        vm.prank(owner);
        vm.expectRevert("Ownable: caller is not the owner");
        myContract.setValue(999);
    }
}
