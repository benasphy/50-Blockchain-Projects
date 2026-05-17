# On-chain Insurance Protocol

## Features

- Insurance liquidity pool
- LP shares
- Policy purchasing
- Premium collection
- Claims payout

## Architecture

Liquidity Providers
        ↓
Insurance Pool
        ↓
Users buy coverage
        ↓
Claims paid from pool

## Key Concepts

- Shared risk pool
- Capital solvency
- Premium pricing
- Coverage positions

## Flow

1. LP deposits liquidity
2. Users buy insurance
3. Premiums increase pool value
4. Claims reduce pool liquidity

## Run

forge test

## Real-world analogs

- Nexus Mutual
- InsurAce
- Cover Protocol

## Limitations

- No oracle verification
- No risk scoring
- No governance
- Manual claims