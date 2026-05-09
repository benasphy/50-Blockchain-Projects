# Simplified Cross-Chain Bridge (Foundry)

## Concepts

- Cross-chain message passing
- Relayers
- Lock & mint bridge model
- Replay protection

## Architecture

Chain A:
- Lock original tokens

Relayer:
- Observes lock event

Chain B:
- Mint wrapped tokens

## Flow

1. User locks tokens on Chain A
2. Relayer watches event
3. Relayer submits message to Chain B
4. Wrapped tokens minted

## Security Concepts

- Nonce replay protection
- Trusted relayer model
- Event-based messaging

## Run

forge test

## Real-world analogs

- Wormhole
- LayerZero
- Axelar

## Limitations

- Centralized relayer
- No cryptographic proof verification
- No validator network