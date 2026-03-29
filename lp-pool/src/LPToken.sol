// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LPToken {

    string public name = "LP Token";
    string public symbol = "LPT";
    uint8 public decimals = 18;

    uint256 public totalSupply;
    address public pool;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    modifier onlyPool() {
        require(msg.sender == pool, "Only pool");
        _;
    }

    constructor() {
        pool = msg.sender;
    }

    function mint(address to, uint256 amount) external onlyPool {
        totalSupply += amount;
        balanceOf[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) external onlyPool {
        require(balanceOf[from] >= amount, "Insufficient");

        balanceOf[from] -= amount;
        totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }
}