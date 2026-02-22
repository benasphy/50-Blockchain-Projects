// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20Minimal {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract TokenVesting {
    struct Vesting {
        uint256 total;
        uint256 released;
        uint64 start;
        uint64 cliff;
        uint64 duration;
        bool exists;
    }

    address public owner;
    IERC20Minimal public immutable token;

    mapping(address => Vesting) public vestings;

    event VestingCreated(address indexed beneficiary, uint256 amount);
    event TokensReleased(address indexed beneficiary, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _token) {
        owner = msg.sender;
        token = IERC20Minimal(_token);
    }

    function createVesting(
        address beneficiary,
        uint256 amount,
        uint64 start,
        uint64 cliffDuration,
        uint64 duration
    ) external onlyOwner {

        require(!vestings[beneficiary].exists, "Already exists");
        require(duration > 0, "Zero duration");
        require(amount > 0, "Zero amount");
        require(cliffDuration <= duration, "Cliff > duration");

        vestings[beneficiary] = Vesting({
            total: amount,
            released: 0,
            start: start,
            cliff: start + cliffDuration,
            duration: duration,
            exists: true
        });

        emit VestingCreated(beneficiary, amount);
    }

    function releasable(address beneficiary) public view returns (uint256) {
        Vesting memory v = vestings[beneficiary];

        if (!v.exists) return 0;
        if (block.timestamp < v.cliff) return 0;

        if (block.timestamp >= v.start + v.duration) {
            return v.total - v.released;
        }

        uint256 vested = (v.total * (block.timestamp - v.start)) / v.duration;
        return vested - v.released;
    }

    function release() external {
        Vesting storage v = vestings[msg.sender];
        require(v.exists, "No vesting");

        uint256 amount = releasable(msg.sender);
        require(amount > 0, "Nothing to release");

        v.released += amount;

        require(token.transfer(msg.sender, amount), "Transfer failed");

        emit TokensReleased(msg.sender, amount);
    }
}