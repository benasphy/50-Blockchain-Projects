## NFT Collection

### Project Overview
An ERC721-like NFT collection contract with basic minting, transfer, and approval logic.

### Key Features
- Mint, transfer, and approve NFTs
- Track ownership and balances
- Emits standard ERC721 events

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy and interact: Mint and transfer NFTs

### Directory Structure
- `src/MyNFT.sol` — NFT collection contract
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
