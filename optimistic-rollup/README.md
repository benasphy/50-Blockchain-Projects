# Optimistic Rollup Simulator (Foundry)

## Concept

An optimistic rollup assumes submitted state is valid unless proven otherwise.

## Components

- Sequencer: submits state roots
- Users: deposit + transact off-chain
- Fraud Proof: verifies invalid transitions

## Flow

1. Users deposit funds
2. Sequencer computes off-chain state
3. Posts new state root
4. Anyone can challenge within period
5. Invalid batch is reverted

## Run

forge test

## Key Concepts

- State root commitment
- Off-chain execution
- Fraud proofs
- Challenge period

## Limitations

- No Merkle proofs
- No partial disputes
- Full state recomputation (inefficient)

## Real-world

- Optimism
- Arbitrum