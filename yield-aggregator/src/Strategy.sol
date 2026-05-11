// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

contract Strategy {
    Token public token;

    address public vault;

    uint256 public totalManaged;

    constructor(address _token) {
        token = Token(_token);
        vault = msg.sender;
    }

    modifier onlyVault() {
        require(msg.sender == vault, "not vault");
        _;
    }

    function deposit(uint256 amount) external onlyVault {
        totalManaged += amount;
    }

    function withdraw(uint256 amount)
        external
        onlyVault
    {
        require(totalManaged >= amount);

        totalManaged -= amount;

        token.transfer(vault, amount);
    }

    // simulate farming profits
    function simulateYield(uint256 amount) external {
        token.mint(address(this), amount);

        totalManaged += amount;
    }

    function balance() external view returns (uint256) {
        return totalManaged;
    }
}