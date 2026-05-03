// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./StateLib.sol";

contract Rollup {
    using StateLib for StateLib.State;

    struct Batch {
        bytes32 stateRoot;
        uint256 timestamp;
        bool challenged;
    }

    StateLib.State internal state;

    Batch[] public batches;

    uint256 public constant CHALLENGE_PERIOD = 1 days;

    address public sequencer;

    constructor() {
        sequencer = msg.sender;
    }

    // deposit funds to L2
    function deposit() external payable {
        state.balances[msg.sender] += msg.value;
    }

    function getBalance(address user) external view returns (uint256) {
        return state.balances[user];
    }

    // sequencer posts new state root
    function submitBatch(bytes32 newRoot) external {
        require(msg.sender == sequencer, "not sequencer");

        batches.push(
            Batch({
                stateRoot: newRoot,
                timestamp: block.timestamp,
                challenged: false
            })
        );
    }

    // fraud proof: prove invalid transition
    function challengeBatch(
        uint256 batchId,
        address[] calldata users,
        StateLib.Tx[] calldata txs,
        bytes32 expectedRoot
    ) external {
        Batch storage b = batches[batchId];

        require(block.timestamp < b.timestamp + CHALLENGE_PERIOD, "too late");
        require(!b.challenged, "already challenged");

        // recompute state
        StateLib.State storage s = state;

        for (uint256 i = 0; i < txs.length; i++) {
            s.applyTx(txs[i]);
        }

        bytes32 computed = s.getRoot(users);

        if (computed != b.stateRoot) {
            b.challenged = true;

            // revert batch (simple version: delete)
            delete batches[batchId];
        }
    }

    function latestBatch() external view returns (bytes32) {
        if (batches.length == 0) return bytes32(0);
        return batches[batches.length - 1].stateRoot;
    }
}