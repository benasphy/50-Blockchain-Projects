// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Token {
    string public name = "Reputation Token";
    string public symbol = "REP";

    uint8 public decimals = 18;

    uint256 public totalSupply;

    mapping(address => uint256)
        public balanceOf;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 amount
    );

    function mint(
        address to,
        uint256 amount
    ) external {
        balanceOf[to] += amount;

        totalSupply += amount;

        emit Transfer(
            address(0),
            to,
            amount
        );
    }

    function transfer(
        address to,
        uint256 amount
    ) external {
        require(
            balanceOf[msg.sender] >= amount,
            "no balance"
        );

        balanceOf[msg.sender] -= amount;

        balanceOf[to] += amount;

        emit Transfer(
            msg.sender,
            to,
            amount
        );
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external {
        require(
            balanceOf[from] >= amount,
            "no balance"
        );

        balanceOf[from] -= amount;

        balanceOf[to] += amount;

        emit Transfer(
            from,
            to,
            amount
        );
    }
}