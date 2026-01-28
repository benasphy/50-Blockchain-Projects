// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    Counter Contract
    - Increment
    - Decrement
    - Overflow / Underflow protection
    - Modifiers
*/

contract Counter {
    uint256 private counter;
    address public owner;

    /// Modifier: Only owner can modify the counter
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /// Modifier: Prevent underflow
    modifier nonZero() {
        require(counter > 0, "Counter is zero");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// ➕ Increment counter safely
    function increment() external onlyOwner {
        /*
            Solidity >= 0.8 automatically checks overflow.
            If counter == type(uint256).max → revert
        */
        counter += 1;
    }

    /// ➖ Decrement counter safely
    function decrement() external onlyOwner nonZero {
        counter -= 1;
    }

    /// 👀 Read counter
    function getCounter() external view returns (uint256) {
        return counter;
    }
}
