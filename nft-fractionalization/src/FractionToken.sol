// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FractionToken {
    string public name;
    string public symbol;

    uint8 public decimals = 18;

    uint256 public totalSupply;

    address public vault;

    mapping(address => uint256)
        public balanceOf;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 amount
    );

    constructor(
        string memory _name,
        string memory _symbol
    ) {
        name = _name;
        symbol = _symbol;

        vault = msg.sender;
    }

    modifier onlyVault() {
        require(
            msg.sender == vault,
            "not vault"
        );
        _;
    }

    function mint(
        address to,
        uint256 amount
    ) external onlyVault {
        balanceOf[to] += amount;

        totalSupply += amount;

        emit Transfer(
            address(0),
            to,
            amount
        );
    }

    function burn(
        address from,
        uint256 amount
    ) external onlyVault {
        require(
            balanceOf[from] >= amount,
            "no balance"
        );

        balanceOf[from] -= amount;

        totalSupply -= amount;

        emit Transfer(
            from,
            address(0),
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
}