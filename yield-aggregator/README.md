# Yield Farming Aggregator

## Features

- Vault deposits
- Share accounting
- Yield farming strategy
- Profit distribution
- Withdrawals

## Architecture

Users
  ↓
Vault
  ↓
Strategy
  ↓
Yield Generation

## Key Concepts

- Shares represent ownership
- Yield increases share value
- Vault abstracts farming complexity

## Flow

1. Deposit assets
2. Receive vault shares
3. Strategy generates yield
4. Share price increases
5. Withdraw for profit

## Run

forge test

## Real-world analogs

- Yearn Finance
- Beefy Finance
- Harvest Finance

## Limitations

- Single strategy
- No strategy switching
- No fees
- No compounding logic