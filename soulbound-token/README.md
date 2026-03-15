## Soulbound Token

### Project Overview
An NFT-like contract for non-transferable (soulbound) tokens, useful for identity, reputation, or certifications.

### Key Features
- Mint and revoke non-transferable tokens
- Only issuer can mint/revoke
- Emits events for transfers and revocations

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy and interact: Only issuer can mint/revoke

### Directory Structure
- `src/SoulboundToken.sol` — Soulbound token contract
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
