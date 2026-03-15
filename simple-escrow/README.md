## Simple Escrow

### Project Overview
An escrow contract for secure ETH transactions between buyer and seller, with an arbiter for dispute resolution.

### Key Features
- Buyer deposits ETH, seller receives on release
- Arbiter can resolve disputes
- Emits events for deposit, release, and refund

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy and interact: Buyer deposits, seller/arbiter releases or refunds

### Directory Structure
- `src/Escrow.sol` — Main escrow contract
- `test/` — Test cases
- `script/` — Deployment scripts

---

## Foundry Quick Reference

See [Foundry Book](https://book.getfoundry.sh/) for full documentation.

Build:
```shell
forge build
```
Test:
```shell
forge test
```
Format:
```shell
forge fmt
```
Gas Snapshots:
```shell
forge snapshot
```
Anvil (local node):
```shell
anvil
```
Deploy:
```shell
forge script ...
```
