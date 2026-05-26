// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

contract ReputationSystem {
    Token public token;

    address public admin;

    struct User {
        uint256 stake;

        uint256 reputation;

        uint256 completedActions;

        bool registered;
    }

    mapping(address => User)
        public users;

    event Registered(
        address indexed user
    );

    event Staked(
        address indexed user,
        uint256 amount
    );

    event Unstaked(
        address indexed user,
        uint256 amount
    );

    event ReputationEarned(
        address indexed user,
        uint256 amount
    );

    event Slashed(
        address indexed user,
        uint256 slashAmount,
        uint256 reputationLoss
    );

    constructor(address _token) {
        token = Token(_token);

        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(
            msg.sender == admin,
            "not admin"
        );
        _;
    }

    // -----------------------------------
    // REGISTER
    // -----------------------------------

    function register() external {
        require(
            !users[msg.sender]
                .registered,
            "already registered"
        );

        users[msg.sender]
            .registered = true;

        emit Registered(msg.sender);
    }

    // -----------------------------------
    // STAKE
    // -----------------------------------

    function stake(
        uint256 amount
    ) external {
        User storage user =
            users[msg.sender];

        require(
            user.registered,
            "not registered"
        );

        token.transferFrom(
            msg.sender,
            address(this),
            amount
        );

        user.stake += amount;

        // initial reputation boost
        user.reputation += amount / 1e18;

        emit Staked(
            msg.sender,
            amount
        );
    }

    // -----------------------------------
    // UNSTAKE
    // -----------------------------------

    function unstake(
        uint256 amount
    ) external {
        User storage user =
            users[msg.sender];

        require(
            user.stake >= amount,
            "not enough stake"
        );

        user.stake -= amount;

        token.transfer(
            msg.sender,
            amount
        );

        emit Unstaked(
            msg.sender,
            amount
        );
    }

    // -----------------------------------
    // COMPLETE ACTION
    // -----------------------------------

    function completeAction()
        external
    {
        User storage user =
            users[msg.sender];

        require(
            user.registered,
            "not registered"
        );

        user.completedActions++;

        // reward reputation
        user.reputation += 10;

        emit ReputationEarned(
            msg.sender,
            10
        );
    }

    // -----------------------------------
    // SLASH USER
    // -----------------------------------

    function slash(
        address offender,
        uint256 slashAmount,
        uint256 reputationLoss
    ) external onlyAdmin {
        User storage user =
            users[offender];

        require(
            user.stake >= slashAmount,
            "too much slash"
        );

        user.stake -= slashAmount;

        if (
            reputationLoss >
            user.reputation
        ) {
            user.reputation = 0;
        } else {
            user.reputation -=
                reputationLoss;
        }

        emit Slashed(
            offender,
            slashAmount,
            reputationLoss
        );
    }

    // -----------------------------------
    // REPUTATION SCORE
    // -----------------------------------

    function reputationScore(
        address userAddr
    )
        external
        view
        returns (uint256)
    {
        User memory user =
            users[userAddr];

        // weighted reputation
        return
            user.reputation +
            (
                user.completedActions *
                    5
            );
    }
}