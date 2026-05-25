# Decentralized Prediction Market

## Features

- Binary prediction markets
- YES/NO outcome shares
- Oracle resolution
- Winner payouts
- Shared liquidity pool

## Architecture

Create Market
      ↓
Buy YES/NO shares
      ↓
Oracle resolves outcome
      ↓
Winning side claims payout

## Key Concepts

- Conditional outcomes
- Market-based forecasting
- Oracle settlement
- Shared payout pool

## Flow

1. Create market
2. Users buy YES/NO shares
3. Market closes
4. Oracle resolves outcome
5. Winners claim rewards

## Run

forge test

## Real-world analogs

- Polymarket
- Augur
- Gnosis Conditional Tokens

## Limitations

- Centralized oracle
- Binary outcomes only
- No AMM pricing
- No dynamic odds