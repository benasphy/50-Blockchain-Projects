// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EventLogger {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Example 1: Basic event
    event UserRegistered(address indexed user, string name);

    // Example 2: Multiple indexed parameters
    event StatusUpdated(
        address indexed user,
        uint256 indexed timestamp,
        string status
    );

    // Example 3: ETH deposit log
    event Deposit(
        address indexed sender,
        uint256 amount,
        uint256 indexed timestamp
    );

    function registerUser(string calldata name) external {
        emit UserRegistered(msg.sender, name);
    }

    function updateStatus(string calldata status) external {
        emit StatusUpdated(msg.sender, block.timestamp, status);
    }

    function deposit() external payable {
        require(msg.value > 0, "Send ETH");

        emit Deposit(msg.sender, msg.value, block.timestamp);
    }
}
