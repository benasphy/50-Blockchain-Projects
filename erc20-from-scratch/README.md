## ERC20 From Scratch

### Project Overview
A minimal ERC20 token implementation from scratch, demonstrating the core logic of the ERC20 standard.

### Key Features
- Customizable name, symbol, decimals, and initial supply
- Standard ERC20 functions: transfer, approve, transferFrom, allowance
- Emits Transfer and Approval events

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy: Use the provided script or deploy manually

### Directory Structure
- `src/MyERC20.sol` — Main ERC20 contract
- `test/` — Test cases for ERC20 logic
- `script/` — Deployment scripts

---

## Foundry Quick Reference

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

See [Foundry Book](https://book.getfoundry.sh/) for full documentation.

### Common Commands

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
