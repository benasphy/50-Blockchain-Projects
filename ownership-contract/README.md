## Ownership Contract

### Project Overview
Demonstrates ownership and access control patterns in Solidity using an Ownable contract.

### Key Features
- Ownable contract for access restriction
- Example contract with owner-only functions
- Ownership transfer logic

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy and interact: Only owner can call restricted functions

### Directory Structure
- `src/Ownable.sol` — Ownable base contract
- `src/MyContract.sol` — Example contract using Ownable
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
