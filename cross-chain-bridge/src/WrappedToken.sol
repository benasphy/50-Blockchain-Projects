// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WrappedToken {
    string public name = "Wrapped Bridge Token";
    string public symbol = "wBTK";

    uint8 public decimals = 18;

    uint256 public totalSupply;

    address public bridge;

    mapping(address => uint256) public balanceOf;

    constructor() {
        bridge = msg.sender;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == bridge, "only bridge");

        balanceOf[to] += amount;
        totalSupply += amount;
    }

    function burn(address from, uint256 amount) external {
        require(msg.sender == bridge, "only bridge");

        balanceOf[from] -= amount;
        totalSupply -= amount;
    }
}