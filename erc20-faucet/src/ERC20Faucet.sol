// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FaucetToken.sol";

contract ERC20Faucet {
    FaucetToken public token;

    uint256 public dripAmount = 100 ether;
    uint256 public cooldown = 1 days;

    mapping(address => uint256) public lastClaimed;

    event TokensClaimed(address indexed user, uint256 amount);

    constructor(address _token) {
        token = FaucetToken(_token);
    }

    function claim() external {
        require(
            block.timestamp >= lastClaimed[msg.sender] + cooldown,
            "Wait before claiming again"
        );

        lastClaimed[msg.sender] = block.timestamp;

        token.mint(msg.sender, dripAmount);

        emit TokensClaimed(msg.sender, dripAmount);
    }
}