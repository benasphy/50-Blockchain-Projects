// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

contract PredictionMarket {
    Token public token;

    address public oracle;

    uint256 public nextMarketId;

    enum Outcome {
        UNRESOLVED,
        YES,
        NO
    }

    struct Market {
        uint256 id;

        string question;

        uint256 endTime;

        bool resolved;

        Outcome outcome;

        uint256 totalYesShares;
        uint256 totalNoShares;

        uint256 totalPool;
    }

    mapping(uint256 => Market)
        public markets;

    mapping(uint256 => mapping(address => uint256))
        public yesShares;

    mapping(uint256 => mapping(address => uint256))
        public noShares;

    mapping(uint256 => mapping(address => bool))
        public claimed;

    event MarketCreated(
        uint256 indexed marketId,
        string question
    );

    event SharesPurchased(
        uint256 indexed marketId,
        address indexed user,
        bool yes,
        uint256 amount
    );

    event MarketResolved(
        uint256 indexed marketId,
        Outcome outcome
    );

    constructor(address _token) {
        token = Token(_token);

        oracle = msg.sender;
    }

    // -----------------------------------
    // CREATE MARKET
    // -----------------------------------

    function createMarket(
        string calldata question,
        uint256 duration
    ) external {
        markets[nextMarketId] = Market({
            id: nextMarketId,
            question: question,
            endTime:
                block.timestamp + duration,
            resolved: false,
            outcome: Outcome.UNRESOLVED,
            totalYesShares: 0,
            totalNoShares: 0,
            totalPool: 0
        });

        emit MarketCreated(
            nextMarketId,
            question
        );

        nextMarketId++;
    }

    // -----------------------------------
    // BUY SHARES
    // -----------------------------------

    function buyYesShares(
        uint256 marketId,
        uint256 amount
    ) external {
        Market storage m =
            markets[marketId];

        require(
            block.timestamp <
                m.endTime,
            "market closed"
        );

        token.transferFrom(
            msg.sender,
            address(this),
            amount
        );

        yesShares[marketId][
            msg.sender
        ] += amount;

        m.totalYesShares += amount;

        m.totalPool += amount;

        emit SharesPurchased(
            marketId,
            msg.sender,
            true,
            amount
        );
    }

    function buyNoShares(
        uint256 marketId,
        uint256 amount
    ) external {
        Market storage m =
            markets[marketId];

        require(
            block.timestamp <
                m.endTime,
            "market closed"
        );

        token.transferFrom(
            msg.sender,
            address(this),
            amount
        );

        noShares[marketId][
            msg.sender
        ] += amount;

        m.totalNoShares += amount;

        m.totalPool += amount;

        emit SharesPurchased(
            marketId,
            msg.sender,
            false,
            amount
        );
    }

    // -----------------------------------
    // RESOLVE MARKET
    // -----------------------------------

    function resolveMarket(
        uint256 marketId,
        Outcome outcome
    ) external {
        require(
            msg.sender == oracle,
            "not oracle"
        );

        Market storage m =
            markets[marketId];

        require(!m.resolved);

        require(
            block.timestamp >=
                m.endTime,
            "market active"
        );

        require(
            outcome !=
                Outcome.UNRESOLVED
        );

        m.resolved = true;

        m.outcome = outcome;

        emit MarketResolved(
            marketId,
            outcome
        );
    }

    // -----------------------------------
    // CLAIM WINNINGS
    // -----------------------------------

    function claim(
        uint256 marketId
    ) external {
        Market storage m =
            markets[marketId];

        require(m.resolved);

        require(
            !claimed[marketId][
                msg.sender
            ],
            "already claimed"
        );

        uint256 winnerShares;
        uint256 totalWinnerShares;

        if (m.outcome == Outcome.YES) {
            winnerShares =
                yesShares[marketId][
                    msg.sender
                ];

            totalWinnerShares =
                m.totalYesShares;
        } else {
            winnerShares =
                noShares[marketId][
                    msg.sender
                ];

            totalWinnerShares =
                m.totalNoShares;
        }

        require(
            winnerShares > 0,
            "not winner"
        );

        uint256 payout =
            (winnerShares *
                m.totalPool) /
            totalWinnerShares;

        claimed[marketId][
            msg.sender
        ] = true;

        token.transfer(
            msg.sender,
            payout
        );
    }
}