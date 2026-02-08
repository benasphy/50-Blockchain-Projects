// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter;

    uint256 public amount;
    bool public isReleased;
    bool public isRefunded;

    event Deposited(address indexed buyer, uint256 amount);
    event Released(address indexed seller, uint256 amount);
    event Refunded(address indexed buyer, uint256 amount);

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Not buyer");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Not arbiter");
        _;
    }

    constructor(address _seller, address _arbiter) payable {
        require(msg.value > 0, "Must deposit ETH");

        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
        amount = msg.value;

        emit Deposited(buyer, amount);
    }

    function releaseToSeller() external onlyBuyer {
        require(!isReleased && !isRefunded, "Already resolved");

        isReleased = true;
        payable(seller).transfer(amount);

        emit Released(seller, amount);
    }

    function refundToBuyer() external onlyArbiter {
        require(!isReleased && !isRefunded, "Already resolved");

        isRefunded = true;
        payable(buyer).transfer(amount);

        emit Refunded(buyer, amount);
    }
}
