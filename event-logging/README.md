## Event Logging

### Project Overview
A contract focused on event logging patterns in Solidity, showing best practices for emitting and indexing events.

### Key Features
- Multiple event types with indexed parameters
- Functions to emit events for user actions and deposits

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Interact: Call functions to emit and observe events

### Directory Structure
- `src/EventLogger.sol` — Event logging contract
- `test/` — Event tests

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
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
