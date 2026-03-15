## Gas Optimization Demo

### Project Overview
A demonstration of gas optimization techniques in Solidity, comparing inefficient and efficient patterns.

### Key Features
- Shows storage vs. memory usage
- Functions to illustrate gas costs of different approaches

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Review: Compare gas usage in test results

### Directory Structure
- `src/GasOptimizationDemo.sol` — Gas optimization examples
- `test/` — Gas usage tests

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
