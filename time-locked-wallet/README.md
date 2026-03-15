## Time Locked Wallet

### Project Overview
ETH wallet that locks funds until a specified unlock time, only owner can withdraw after unlock.

### Key Features
- Lock ETH until a future timestamp
- Only owner can withdraw after unlock
- Emits events for deposits and withdrawals

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy with unlock time, deposit and withdraw after unlock

### Directory Structure
- `src/TimeLockedWallet.sol` — Main wallet contract
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
