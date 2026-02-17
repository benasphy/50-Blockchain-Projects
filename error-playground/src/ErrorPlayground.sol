// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ErrorPlayground {
    address public owner;
    uint256 public counter;

    constructor() {
        owner = msg.sender;
    }

    // -------------------------
    // 1️⃣ REQUIRE EXAMPLES
    // -------------------------

    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
    }

    function onlyOwnerAction() external view {
        require(msg.sender == owner, "Not owner");
    }

    // -------------------------
    // 2️⃣ REVERT EXAMPLES
    // -------------------------

    error Unauthorized(address caller);
    error ValueTooSmall(uint256 sent, uint256 required);

    function restrictedAction() external view {
        if (msg.sender != owner) {
            revert Unauthorized(msg.sender);
        }
    }

    function minimumValue(uint256 requiredAmount) external payable {
        if (msg.value < requiredAmount) {
            revert ValueTooSmall(msg.value, requiredAmount);
        }
    }

    // -------------------------
    // 3️⃣ ASSERT EXAMPLES
    // -------------------------

    function increment() external {
        counter += 1;

        // Invariant: counter should never be 0 after increment
        assert(counter > 0);
    }

    function breakInvariant() external {
        counter = 0;

        // This should NEVER logically happen after increment
        assert(counter != 0);
    }
}
