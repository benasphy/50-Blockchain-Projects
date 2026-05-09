// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Token {
    string public name = "Bridge Token";
    string public symbol = "BTK";

    uint8 public decimals = 18;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
        totalSupply += amount;
    }

    function transfer(address to, uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "no balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external {
        require(balanceOf[from] >= amount, "no balance");

        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }
}