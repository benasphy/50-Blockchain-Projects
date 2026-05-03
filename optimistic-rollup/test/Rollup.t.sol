// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Rollup.sol";
import "../src/StateLib.sol";

contract RollupTest is Test {
    Rollup rollup;

    address user1 = address(1);
    address user2 = address(2);

    function setUp() public {
        rollup = new Rollup();

        vm.deal(user1, 10 ether);

        vm.prank(user1);
        rollup.deposit{value: 10 ether}();
    }

    function testFraudProof() public {
        // fake incorrect root submitted
        bytes32 fakeRoot = keccak256("fake");

        rollup.submitBatch(fakeRoot);

        // real tx
        StateLib.Tx[] memory txs = new StateLib.Tx[](1);
        txs[0] = StateLib.Tx({
            from: user1,
            to: user2,
            amount: 5 ether
        });

        address[] memory users = new address[](2);
        users[0] = user1;
        users[1] = user2;

        // challenge
        rollup.challengeBatch(
            0,
            users,
            txs,
            bytes32(0)
        );

        // batch should be removed
        (bytes32 root) = rollup.latestBatch();
        assertEq(root, bytes32(0));
    }
}