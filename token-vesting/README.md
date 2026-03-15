## Token Vesting

### Project Overview
Token vesting contracts for locking tokens and releasing them over time to beneficiaries.

### Key Features
- ERC20 token contract
- Vesting contract with cliff and duration
- Only owner can create vestings
- Beneficiaries can claim vested tokens

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy token and vesting contracts, create vestings, claim tokens

### Directory Structure
- `src/MyToken.sol` — ERC20 token contract
- `src/TokenVesting.sol` — Vesting contract
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
