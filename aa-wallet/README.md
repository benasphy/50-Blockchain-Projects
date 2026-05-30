# Account Abstraction Wallet

## Features

- Smart contract wallet
- Meta-transactions
- Signature validation
- Batch execution
- Social recovery
- Guardian system

## Concepts Learned

- Smart account architecture
- ECDSA signatures
- Nonce management
- Relayer pattern
- Account abstraction principles

## Flow

User signs message
        ↓
Relayer submits tx
        ↓
Wallet verifies signature
        ↓
Wallet executes call

## Run

```bash
forge test