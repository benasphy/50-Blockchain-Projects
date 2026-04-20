// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Exchange {
    uint256 public price = 1 ether;

    function setPrice(uint256 newPrice) public {
        price = newPrice;
    }

    function buy() external payable {
        require(msg.value >= price, "not enough ETH");

        // naive logic → front-run possible
    }
}