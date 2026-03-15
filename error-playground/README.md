## Error Playground

### Project Overview
A playground contract to demonstrate error handling in Solidity, including require, revert, and custom errors.

### Key Features
- Examples of `require` and `revert`
- Custom error types
- Functions to trigger and handle errors

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Interact: Call functions to see different error behaviors

### Directory Structure
- `src/ErrorPlayground.sol` — Error demonstration contract
- `test/` — Error handling tests

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
