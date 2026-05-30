// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockTarget {
    uint256 public number;

    event Updated(uint256 value);

    function setNumber(
        uint256 value
    ) external {
        number = value;

        emit Updated(value);
    }
}