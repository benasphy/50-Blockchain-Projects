# Auction

A simple **English auction** smart contract where users bid with ETH, outbid users can withdraw their funds, and the seller finalizes the auction after the deadline.

## Purpose

This project demonstrates a basic time-based auction flow in Solidity:
- place increasing bids
- safely track refundable overbid amounts
- finalize and transfer the winning bid to the seller

## Contracts

- `src/Auction.sol`
  - Stores seller, auction end time, highest bid, and highest bidder
  - `bid()` accepts only higher bids before the auction ends
  - `withdraw()` lets outbid bidders reclaim ETH from `pendingReturns`
  - `endAuction()` ends auction after deadline and pays seller

## Tests

- `test/Auction.t.sol` covers:
  - highest bid updates
  - outbid refund accounting
  - withdrawal flow
  - auction finalization after time warp

## Deploy

- Script: `script/DeployAuction.s.sol`
- Deploys an auction with `300` seconds duration.

## Foundry Commands

```bash
forge build
forge test
forge script script/DeployAuction.s.sol:DeployAuction --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```
