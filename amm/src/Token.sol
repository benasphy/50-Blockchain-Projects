// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Token {

    string public name;
    string public symbol;
    uint8 public decimals = 18;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor(string memory _name, string memory _symbol, uint256 supply) {
        name = _name;
        symbol = _symbol;
        totalSupply = supply;
        balanceOf[msg.sender] = supply;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }
}