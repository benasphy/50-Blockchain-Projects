## Simple Wallet

### Project Overview
A minimal ETH wallet contract for deposits and owner-only withdrawals.

### Key Features
- Deposit and withdraw ETH
- Only owner can withdraw
- Emits events for deposits and withdrawals

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy and interact: Deposit and withdraw ETH

### Directory Structure
- `src/SimpleWallet.sol` — Main wallet contract
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
