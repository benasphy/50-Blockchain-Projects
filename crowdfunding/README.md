# Crowdfunding

A simple **ETH crowdfunding campaign** contract with deadline-based funding, creator withdrawal on success, and contributor refunds on failure.

## Purpose

This project demonstrates a common campaign lifecycle:
- contributors fund before deadline
- creator withdraws if funding goal is met
- contributors claim refunds if goal is not met

## Contracts

- `src/Crowdfunding.sol`
  - Campaign parameters: `goal`, `deadline`, `creator`
  - `contribute()` accepts ETH before deadline
  - `withdrawFunds()` lets creator withdraw after deadline if goal reached
  - `claimRefund()` lets contributors withdraw if goal not reached
  - `getTimeLeft()` helper for remaining campaign time

## Tests

- `test/Crowdfunding.t.sol` covers:
  - contribution tracking
  - successful campaign withdrawal
  - refund flow for failed campaign

## Deploy

- Script: `script/DeployCrowdfunding.s.sol`
- Deploys with default values in script (`10 ether` goal, `7 days` duration).

## Foundry Commands

```bash
forge build
forge test
forge script script/DeployCrowdfunding.s.sol:DeployCrowdfunding --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```
