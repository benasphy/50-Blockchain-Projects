// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./GovToken.sol";

contract DAO {
    GovToken public token;
    address public treasury;

    uint256 public proposalCount;

    struct Proposal {
        address proposer;
        address target;
        uint256 value;
        bytes data;
        string description;

        uint256 votesFor;
        uint256 votesAgainst;

        uint256 deadline;
        bool executed;

        mapping(address => bool) hasVoted;
    }

    mapping(uint256 => Proposal) public proposals;

    uint256 public constant VOTING_DURATION = 3 days;

    constructor(address _token) {
        token = GovToken(_token);
    }

    function setTreasury(address _treasury) external {
        require(treasury == address(0), "already set");
        treasury = _treasury;
    }

    function propose(
        address target,
        uint256 value,
        bytes calldata data,
        string calldata description
    ) external returns (uint256) {
        require(token.balanceOf(msg.sender) > 0, "no power");

        proposalCount++;

        Proposal storage p = proposals[proposalCount];
        p.proposer = msg.sender;
        p.target = target;
        p.value = value;
        p.data = data;
        p.description = description;
        p.deadline = block.timestamp + VOTING_DURATION;

        return proposalCount;
    }

    function vote(uint256 id, bool support) external {
        Proposal storage p = proposals[id];

        require(block.timestamp < p.deadline, "ended");
        require(!p.hasVoted[msg.sender], "already voted");

        uint256 power = token.balanceOf(msg.sender);
        require(power > 0, "no voting power");

        p.hasVoted[msg.sender] = true;

        if (support) {
            p.votesFor += power;
        } else {
            p.votesAgainst += power;
        }
    }

    function execute(uint256 id) external {
        Proposal storage p = proposals[id];

        require(block.timestamp >= p.deadline, "not ended");
        require(!p.executed, "already executed");
        require(p.votesFor > p.votesAgainst, "not passed");

        p.executed = true;

        (bool success, ) = treasury.call(
            abi.encodeWithSignature(
                "execute(address,uint256,bytes)",
                p.target,
                p.value,
                p.data
            )
        );

        require(success, "execution failed");
    }
}