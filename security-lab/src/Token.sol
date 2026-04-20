// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Token {
    mapping(address => uint256) public balances;

    function mint(uint256 amount) public {
        // ❌ unsafe (simulate pre-0.8 behavior)
        unchecked {
            balances[msg.sender] += amount;
        }
    }

    function transfer(address to, uint256 amount) public {
        unchecked {
            balances[msg.sender] -= amount;
            balances[to] += amount;
        }
    }
}