// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

contract BridgeA {
    Token public token;

    uint256 public nonce;

    event Locked(
        address indexed user,
        uint256 amount,
        uint256 nonce
    );

    constructor(address _token) {
        token = Token(_token);
    }

    function lock(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);

        emit Locked(msg.sender, amount, nonce);

        nonce++;
    }
}