## NFT Marketplace

### Project Overview
A basic NFT marketplace for listing and trading NFTs. (Contract stubs provided for extension.)

### Key Features
- NFT contract for minting and transferring NFTs
- Marketplace contract for listing and buying NFTs (extend as needed)

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy and interact: Mint NFTs, list and buy on marketplace

### Directory Structure
- `src/MyNFT.sol` — NFT contract
- `src/NFTMarketplace.sol` — Marketplace contract (extendable)
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
