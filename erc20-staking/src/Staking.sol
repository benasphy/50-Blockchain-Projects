// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./StakeToken.sol";

contract Staking {
    StakeToken public token;

    uint256 public rewardRate = 1e18; // 1 token per second
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    uint256 public totalStaked;

    mapping(address => uint256) public userStake;
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(address _token) {
        token = StakeToken(_token);
    }

    // -----------------------------
    // CORE REWARD LOGIC
    // -----------------------------

    function rewardPerToken() public view returns (uint256) {
        if (totalStaked == 0) {
            return rewardPerTokenStored;
        }

        return
            rewardPerTokenStored +
            ((block.timestamp - lastUpdateTime) * rewardRate * 1e18) /
            totalStaked;
    }

    function earned(address account) public view returns (uint256) {
        return
            (userStake[account] *
                (rewardPerToken() - userRewardPerTokenPaid[account])) /
            1e18 +
            rewards[account];
    }

    function updateReward(address account) internal {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
    }

    // -----------------------------
    // USER FUNCTIONS
    // -----------------------------

    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake 0");

        updateReward(msg.sender);

        totalStaked += amount;
        userStake[msg.sender] += amount;

        token.transferFrom(msg.sender, address(this), amount);

        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Cannot withdraw 0");
        require(userStake[msg.sender] >= amount, "Not enough stake");

        updateReward(msg.sender);

        totalStaked -= amount;
        userStake[msg.sender] -= amount;

        token.transfer(msg.sender, amount);

        emit Withdrawn(msg.sender, amount);
    }

    function claimReward() external {
        updateReward(msg.sender);

        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No reward");

        rewards[msg.sender] = 0;

        token.transfer(msg.sender, reward);

        emit RewardPaid(msg.sender, reward);
    }
}
