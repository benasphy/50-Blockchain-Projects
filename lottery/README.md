## Lottery

### Project Overview
A simple lottery contract where users can enter by sending ETH, and a manager can pick a random winner to receive the pot.

### Key Features
- Enter lottery with minimum ETH
- Manager-only winner selection
- Emits events for entries and winner selection

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy and interact: Enter lottery, pick winner as manager

### Directory Structure
- `src/Lottery.sol` — Main lottery contract
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
