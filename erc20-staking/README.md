## ERC20 Staking

### Project Overview
A staking system with a custom ERC20 token ("StakeToken") and a staking contract that rewards users for staking tokens.

### Key Features
- ERC20 token with minting on deployment
- Staking contract with reward logic
- Events for staking, withdrawal, and rewards

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy `StakeToken` and then `Staking` with the token address

### Directory Structure
- `src/StakeToken.sol` — ERC20 token contract
- `src/Staking.sol` — Staking logic
- `test/` — Staking and token tests
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
