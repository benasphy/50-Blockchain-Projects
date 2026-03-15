## Todo List

### Project Overview
On-chain todo list contract where each user manages their own todos.

### Key Features
- Add, complete, and delete todos
- Each user has their own todo list
- Emits events for todo actions

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy and interact: Manage your todos on-chain

### Directory Structure
- `src/TodoList.sol` — Todo list contract
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
