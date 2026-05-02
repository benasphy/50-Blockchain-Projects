# Layer-2 Payment Channel (Foundry)

## Concept

A payment channel allows two parties to transact off-chain and settle on-chain.

## Flow

1. Sender opens channel (deposit ETH)
2. Off-chain signed messages update balances
3. Receiver closes channel with latest signed state
4. Funds distributed accordingly

## Key Features

- Off-chain state transitions
- Signature verification (ECDSA)
- Challenge via expiration

## Run Tests

```bash
forge test