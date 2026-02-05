// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Simple Voting Contract
/// @notice Prevents double voting using mappings
contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    /// candidateId => Candidate
    mapping(uint256 => Candidate) public candidates;

    /// voter => hasVoted
    mapping(address => bool) public hasVoted;

    uint256 public candidatesCount;
    address public owner;

    event CandidateAdded(uint256 indexed candidateId, string name);
    event VoteCast(address indexed voter, uint256 indexed candidateId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// ADD CANDIDATE
    function addCandidate(string calldata _name) external onlyOwner {
        candidates[candidatesCount] = Candidate(_name, 0);
        emit CandidateAdded(candidatesCount, _name);
        candidatesCount++;
    }

    /// VOTE
    function vote(uint256 _candidateId) external {
        require(!hasVoted[msg.sender], "Already voted");
        require(_candidateId < candidatesCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit VoteCast(msg.sender, _candidateId);
    }

    /// READ RESULTS
    function getCandidate(uint256 _id) external view returns (string memory, uint256) {
        Candidate memory candidate = candidates[_id];
        return (candidate.name, candidate.voteCount);
    }
}
