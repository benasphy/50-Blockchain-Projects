// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/AAWallet.sol";
import "../src/MockTarget.sol";

contract AAWalletTest is Test {
    AAWallet wallet;

    MockTarget target;

    address owner;

    uint256 ownerPk;

    address guardian1 =
        address(100);

    address guardian2 =
        address(200);

    function setUp() public {
        ownerPk = 12345;

        owner =
            vm.addr(ownerPk);

        wallet =
            new AAWallet(owner);

        target =
            new MockTarget();

        vm.prank(owner);

        wallet.addGuardian(
            guardian1
        );

        vm.prank(owner);

        wallet.addGuardian(
            guardian2
        );
    }

    function testMetaTx()
        public
    {
        bytes memory callData =
            abi.encodeWithSelector(
                target.setNumber.selector,
                777
            );

        bytes32 hash =
            keccak256(
                abi.encodePacked(
                    address(wallet),
                    address(target),
                    0,
                    callData,
                    0
                )
            );

        (
            uint8 v,
            bytes32 r,
            bytes32 s
        ) = vm.sign(
            ownerPk,
            hash
        );

        wallet.execute(
            address(target),
            0,
            callData,
            v,
            r,
            s
        );

        assertEq(
            target.number(),
            777
        );
    }

    function testBatch()
        public
    {
        address[] memory targets =
            new address[](2);

        bytes[] memory calls =
            new bytes[](2);

        targets[0] =
            address(target);

        targets[1] =
            address(target);

        calls[0] =
            abi.encodeWithSelector(
                target.setNumber.selector,
                10
            );

        calls[1] =
            abi.encodeWithSelector(
                target.setNumber.selector,
                20
            );

        vm.prank(owner);

        wallet.executeBatch(
            targets,
            calls
        );

        assertEq(
            target.number(),
            20
        );
    }

    function testRecovery()
        public
    {
        address newOwner =
            address(999);

        vm.prank(guardian1);

        wallet.voteNewOwner(
            newOwner
        );

        vm.prank(guardian2);

        wallet.voteNewOwner(
            newOwner
        );

        assertEq(
            wallet.owner(),
            newOwner
        );
    }
}