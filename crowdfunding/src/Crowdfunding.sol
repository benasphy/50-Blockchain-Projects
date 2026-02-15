// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfunding {
    address public creator;
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalRaised;

    mapping(address => uint256) public contributions;

    bool public fundsWithdrawn;

    event ContributionReceived(address indexed contributor, uint256 amount);
    event FundsWithdrawn(uint256 amount);
    event RefundIssued(address indexed contributor, uint256 amount);

    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Campaign ended");
        _;
    }

    modifier afterDeadline() {
        require(block.timestamp >= deadline, "Campaign still active");
        _;
    }

    constructor(uint256 _goal, uint256 _durationInSeconds) {
        require(_goal > 0, "Goal must be greater than 0");

        creator = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _durationInSeconds;
    }

    /// Contribute ETH
    function contribute() external payable beforeDeadline {
        require(msg.value > 0, "Must send ETH");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;

        emit ContributionReceived(msg.sender, msg.value);
    }

    /// Creator withdraws if goal reached
    function withdrawFunds() external afterDeadline {
        require(msg.sender == creator, "Not creator");
        require(totalRaised >= goal, "Goal not reached");
        require(!fundsWithdrawn, "Already withdrawn");

        fundsWithdrawn = true;

        payable(creator).transfer(address(this).balance);

        emit FundsWithdrawn(totalRaised);
    }

    /// Contributors claim refund if goal NOT reached
    function claimRefund() external afterDeadline {
        require(totalRaised < goal, "Goal was reached");

        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No contribution");

        contributions[msg.sender] = 0;

        payable(msg.sender).transfer(amount);

        emit RefundIssued(msg.sender, amount);
    }

    function getTimeLeft() external view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }
}
