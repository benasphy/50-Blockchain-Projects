// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Ownable.sol";

/// @title Example contract with restricted function
contract MyContract is Ownable {
    uint256 public value;

    /// @notice Sets value, only owner can call
    function setValue(uint256 _value) external onlyOwner {
        value = _value;
    }
}
