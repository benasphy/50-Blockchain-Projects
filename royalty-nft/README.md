## Royalty NFT

### Project Overview
NFT contract with royalty support and a marketplace for trading NFTs with royalty payments to creators.

### Key Features
- ERC721-like NFT with royalty info
- Marketplace contract for listing and buying NFTs
- Royalty payments on sales

### How to Use
1. Build: `forge build`
2. Test: `forge test`
3. Deploy NFT and marketplace, mint and trade NFTs

### Directory Structure
- `src/RoyaltyNFT.sol` — NFT contract with royalty support
- `src/RoyaltyMarketplace.sol` — Marketplace contract
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
