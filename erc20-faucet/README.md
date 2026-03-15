# ERC20 Faucet

A simple **ERC20 faucet system** where users can claim fixed token amounts on a cooldown interval.

## Purpose

This project demonstrates:
- a custom ERC20-like token implementation
- faucet-controlled minting
- rate limiting claims with per-user cooldown

## Contracts

- `src/FaucetToken.sol`
	- Minimal ERC20-like token (`name`, `symbol`, `decimals`, balances, allowances)
	- Includes `mint(to, amount)` restricted by `onlyFaucet`
	- Faucet authority can be moved using `setFaucet(address)`

- `src/ERC20Faucet.sol`
	- Holds faucet rules and token reference
	- `claim()` mints `dripAmount` for caller if cooldown has passed
	- Tracks claim timestamps with `lastClaimed`

## Default Faucet Parameters

- Drip amount: `100 ether` tokens
- Cooldown: `1 day`

## Tests

- `test/ERC20Faucet.t.sol` covers:
	- successful claim minting
	- claim blocked during cooldown period

## Deploy

- Script: `script/DeployFaucet.s.sol`
- Flow:
	1. Deploy `FaucetToken`
	2. Deploy `ERC20Faucet` with token address
	3. Assign faucet contract as token minter via `setFaucet`

## Foundry Commands

```bash
forge build
forge test
forge script script/DeployFaucet.s.sol:DeployFaucet --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```
