// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library StateLib {
    struct State {
        mapping(address => uint256) balances;
    }

    struct Tx {
        address from;
        address to;
        uint256 amount;
    }

    function applyTx(
        State storage s,
        Tx memory t
    ) internal {
        require(s.balances[t.from] >= t.amount, "insufficient");

        s.balances[t.from] -= t.amount;
        s.balances[t.to] += t.amount;
    }

    // simulate hash (state root)
    function getRoot(State storage s, address[] memory users)
        internal
        view
        returns (bytes32)
    {
        bytes memory data;

        for (uint256 i = 0; i < users.length; i++) {
            data = abi.encodePacked(data, users[i], s.balances[users[i]]);
        }

        return keccak256(data);
    }
}