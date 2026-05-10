// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

contract Exchange {
    Token public token;

    constructor(address _token) {
        token = Token(_token);
    }

    enum Side {
        BUY,
        SELL
    }

    struct Order {
        uint256 id;
        address trader;
        Side side;

        uint256 price;
        uint256 amount;

        uint256 filled;
    }

    uint256 public nextOrderId;

    Order[] public buyOrders;
    Order[] public sellOrders;

    mapping(address => uint256) public ethBalance;
    mapping(address => uint256) public tokenBalance;

    event DepositETH(address indexed user, uint256 amount);
    event DepositToken(address indexed user, uint256 amount);

    event OrderPlaced(
        uint256 id,
        address trader,
        Side side,
        uint256 price,
        uint256 amount
    );

    event Trade(
        address buyer,
        address seller,
        uint256 price,
        uint256 amount
    );

    // -----------------------------------
    // DEPOSITS
    // -----------------------------------

    function depositETH() external payable {
        ethBalance[msg.sender] += msg.value;

        emit DepositETH(msg.sender, msg.value);
    }

    function depositToken(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);

        tokenBalance[msg.sender] += amount;

        emit DepositToken(msg.sender, amount);
    }

    // -----------------------------------
    // PLACE ORDER
    // -----------------------------------

    function placeBuyOrder(
        uint256 price,
        uint256 amount
    ) external {
        uint256 cost = price * amount;

        require(ethBalance[msg.sender] >= cost, "not enough ETH");

        Order memory order = Order({
            id: nextOrderId++,
            trader: msg.sender,
            side: Side.BUY,
            price: price,
            amount: amount,
            filled: 0
        });

        buyOrders.push(order);

        emit OrderPlaced(
            order.id,
            msg.sender,
            Side.BUY,
            price,
            amount
        );

        matchOrders();
    }

    function placeSellOrder(
        uint256 price,
        uint256 amount
    ) external {
        require(
            tokenBalance[msg.sender] >= amount,
            "not enough tokens"
        );

        Order memory order = Order({
            id: nextOrderId++,
            trader: msg.sender,
            side: Side.SELL,
            price: price,
            amount: amount,
            filled: 0
        });

        sellOrders.push(order);

        emit OrderPlaced(
            order.id,
            msg.sender,
            Side.SELL,
            price,
            amount
        );

        matchOrders();
    }

    // -----------------------------------
    // MATCHING ENGINE
    // -----------------------------------

    function matchOrders() internal {
        for (uint256 i = 0; i < buyOrders.length; i++) {
            Order storage buy = buyOrders[i];

            if (buy.filled == buy.amount) continue;

            for (uint256 j = 0; j < sellOrders.length; j++) {
                Order storage sell = sellOrders[j];

                if (sell.filled == sell.amount) continue;

                // match condition
                if (buy.price >= sell.price) {
                    uint256 remainingBuy =
                        buy.amount - buy.filled;

                    uint256 remainingSell =
                        sell.amount - sell.filled;

                    uint256 tradeAmount =
                        remainingBuy < remainingSell
                            ? remainingBuy
                            : remainingSell;

                    uint256 tradeCost =
                        tradeAmount * sell.price;

                    // transfer balances
                    ethBalance[buy.trader] -= tradeCost;
                    ethBalance[sell.trader] += tradeCost;

                    tokenBalance[sell.trader] -= tradeAmount;
                    tokenBalance[buy.trader] += tradeAmount;

                    buy.filled += tradeAmount;
                    sell.filled += tradeAmount;

                    emit Trade(
                        buy.trader,
                        sell.trader,
                        sell.price,
                        tradeAmount
                    );
                }
            }
        }
    }
}