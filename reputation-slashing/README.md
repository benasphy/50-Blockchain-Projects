# Reputation System with Slashing

## Features

- User registration
- Token staking
- Reputation scoring
- Slashing penalties
- Action tracking

## Architecture

Users stake tokens
        ↓
Gain reputation
        ↓
Perform actions
        ↓
Bad behavior triggers slashing

## Key Concepts

- Economic security
- Reputation incentives
- Slashing penalties
- Sybil resistance

## Flow

1. Register
2. Stake tokens
3. Earn reputation through actions
4. Misbehavior causes slashing

## Run

forge test

## Real-world analogs

- EigenLayer
- Kleros
- Optimism governance

## Limitations

- Centralized slashing admin
- No decentralized arbitration
- No validator voting
- Simple reputation formula