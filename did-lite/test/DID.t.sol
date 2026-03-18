// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DIDRegistry.sol";

contract DIDTest is Test {

    DIDRegistry registry;

    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        registry = new DIDRegistry();
    }

    function testRegisterDID() public {

        vm.prank(alice);
        registry.register("ipfs://alice");

        (address owner,,bool exists) = registry.dids(alice);

        assertEq(owner, alice);
        assertTrue(exists);
    }

    function testDelegate() public {

        vm.prank(alice);
        registry.register("ipfs://alice");

        vm.prank(alice);
        registry.addDelegate(bob);

        assertTrue(registry.isDelegate(alice, bob));
    }

    function testCredentialFlow() public {

        vm.prank(alice);
        registry.register("ipfs://alice");

        vm.prank(bob);
        registry.register("ipfs://bob");

        vm.prank(alice);
        uint256 id = registry.issueCredential(bob, "KYC Verified");

        bool valid = registry.verifyCredential(id);
        assertTrue(valid);

        vm.prank(alice);
        registry.revokeCredential(id);

        bool stillValid = registry.verifyCredential(id);
        assertFalse(stillValid);
    }
}