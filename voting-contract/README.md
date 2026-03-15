## Voting Contract

### Project Overview
Simple voting contract where the owner adds candidates and users can vote once for their chosen candidate.

### Key Features
- Owner adds candidates
- Each address can vote only once
- Emits events for candidate addition and voting

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy and interact: Add candidates, cast votes

### Directory Structure
- `src/Voting.sol` — Voting contract
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
