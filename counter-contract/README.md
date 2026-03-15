# Counter Contract

A minimal **owner-controlled counter** smart contract with increment/decrement operations and built-in safety checks.

## Purpose

This project is for learning core Solidity basics:
- state variables and ownership
- modifiers (`onlyOwner`, non-zero check)
- overflow/underflow behavior in Solidity `^0.8.x`

## Contracts

- `src/Counter.sol`
  - `increment()` increases counter (owner only)
  - `decrement()` decreases counter (owner only, cannot go below zero)
  - `getCounter()` returns current value

## Tests

- `test/TestCounter.t.sol` covers:
  - initial state
  - increment/decrement behavior
  - owner-only restrictions
  - revert on underflow and overflow scenarios

## Deploy

- Script: `script/DeployCounter.s.sol`
- Deploys a new `Counter` instance.

## Foundry Commands

```bash
forge build
forge test
forge script script/DeployCounter.s.sol:DeployCounter --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```
