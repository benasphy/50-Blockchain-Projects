// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IGovToken {
    function balanceOf(address user) external view returns (uint256);
}

contract DAO {

    struct Proposal {
        uint256 id;
        address proposer;
        string description;
        uint256 startTime;
        uint256 endTime;
        uint256 forVotes;
        uint256 againstVotes;
        bool executed;
    }

    IGovToken public token;
    uint256 public proposalCount;
    uint256 public votingDuration = 3 days;
    uint256 public quorum = 100 ether;

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 id, address proposer);
    event VoteCast(address voter, uint256 proposalId, bool support, uint256 weight);
    event ProposalExecuted(uint256 id);

    constructor(address _token) {
        token = IGovToken(_token);
    }

    function createProposal(string memory description) external {

        proposalCount++;

        proposals[proposalCount] = Proposal({
            id: proposalCount,
            proposer: msg.sender,
            description: description,
            startTime: block.timestamp,
            endTime: block.timestamp + votingDuration,
            forVotes: 0,
            againstVotes: 0,
            executed: false
        });

        emit ProposalCreated(proposalCount, msg.sender);
    }

    function vote(uint256 proposalId, bool support) external {

        Proposal storage proposal = proposals[proposalId];

        require(block.timestamp >= proposal.startTime, "Not started");
        require(block.timestamp <= proposal.endTime, "Voting ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        uint256 weight = token.balanceOf(msg.sender);
        require(weight > 0, "No voting power");

        if (support) {
            proposal.forVotes += weight;
        } else {
            proposal.againstVotes += weight;
        }

        hasVoted[proposalId][msg.sender] = true;

        emit VoteCast(msg.sender, proposalId, support, weight);
    }

    function execute(uint256 proposalId) external {

        Proposal storage proposal = proposals[proposalId];

        require(block.timestamp > proposal.endTime, "Still voting");
        require(!proposal.executed, "Already executed");

        require(proposal.forVotes > proposal.againstVotes, "Not passed");
        require(proposal.forVotes >= quorum, "Quorum not reached");

        proposal.executed = true;

        emit ProposalExecuted(proposalId);
    }
}