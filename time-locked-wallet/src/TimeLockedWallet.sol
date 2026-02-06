// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Time Locked Wallet
/// @notice Locks ETH until a specific timestamp
contract TimeLockedWallet {
    address public owner;
    uint256 public unlockTime;

    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(uint256 _unlockTime) payable {
        require(_unlockTime > block.timestamp, "Unlock time must be future");

        owner = msg.sender;
        unlockTime = _unlockTime;
    }

    /// Allow contract to receive ETH
    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    /// Withdraw ETH after unlock time
    function withdraw() external onlyOwner {
        require(block.timestamp >= unlockTime, "Funds are locked");

        uint256 balance = address(this).balance;
        require(balance > 0, "No funds");

        emit Withdrawn(owner, balance);
        payable(owner).transfer(balance);
    }

    /// Helper function
    function timeLeft() external view returns (uint256) {
        if (block.timestamp >= unlockTime) {
            return 0;
        }
        return unlockTime - block.timestamp;
    }
}
