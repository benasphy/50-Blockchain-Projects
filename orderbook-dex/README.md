# Decentralized Exchange (Order Book)

## Features

- On-chain order book
- Buy/sell limit orders
- Matching engine
- Trade settlement

## Concepts

- Order matching
- Partial fills
- Price priority
- Trade execution

## Flow

1. Deposit ETH/tokens
2. Place buy or sell order
3. Matching engine finds compatible orders
4. Trade settles automatically

## Matching Logic

BUY price >= SELL price

Trade executes at seller price.

## Run

forge test

## Real-world analogs

- dYdX (early versions)
- IDEX
- Centralized exchange engines