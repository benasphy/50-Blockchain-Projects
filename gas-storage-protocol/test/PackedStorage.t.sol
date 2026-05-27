// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/PackedStorage.sol";

contract PackedStorageTest is Test {
    PackedStorage storageContract;

    address alice = address(1);

    function setUp() public {
        storageContract =
            new PackedStorage();
    }

    function testPackedUserStorage()
        public
    {
        storageContract.setUser(
            alice,
            true,
            false,
            500,
            10000,
            7
        );

        assertTrue(
            storageContract.isActive(
                alice
            )
        );

        assertEq(
            storageContract.reputation(
                alice
            ),
            500
        );

        assertEq(
            storageContract.balance(
                alice
            ),
            10000
        );

        assertEq(
            storageContract.level(
                alice
            ),
            7
        );
    }

    function testBitmapPermissions()
        public
    {
        storageContract
            .grantPermission(3);

        bool has =
            storageContract
                .hasPermission(3);

        assertTrue(has);

        storageContract
            .revokePermission(3);

        bool afterRevoke =
            storageContract
                .hasPermission(3);

        assertFalse(afterRevoke);
    }

    function testRawStorageRead()
        public
    {
        storageContract.setUser(
            alice,
            true,
            false,
            999,
            55555,
            10
        );

        uint256 raw =
            storageContract
                .rawStorage(alice);

        assertGt(raw, 0);
    }
}