## MultiSig Wallet

### Project Overview
A multi-signature wallet contract requiring multiple owner confirmations to execute transactions.

### Key Features
- Multiple owners and required confirmations
- Submit, confirm, and execute transactions
- Prevents duplicate confirmations and unauthorized actions

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy and interact: Owners submit and confirm transactions

### Directory Structure
- `src/MultiSigWallet.sol` — Main multisig wallet contract
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
