# DAO Governance

A lightweight **token-weighted DAO voting system** with proposal creation, on-chain voting, and execution checks based on majority and quorum.

## Purpose

This project demonstrates core governance mechanics:
- proposal lifecycle (create → vote → execute)
- vote weight based on ERC20-style token balances
- quorum + majority checks before execution

## Contracts

- `src/GovToken.sol`
	- Minimal governance token with transfer support
	- Initial supply is minted to deployer

- `src/DAO.sol`
	- `createProposal(description)` creates a new proposal
	- `vote(proposalId, support)` records weighted votes from token holders
	- `execute(proposalId)` executes only if voting ended, proposal passed, and quorum met

## Default Governance Parameters

- Voting duration: `3 days`
- Quorum: `100 ether` vote weight

## Tests

- `test/DAO.t.sol` covers end-to-end governance flow:
	- create proposal
	- cast weighted votes
	- warp time past voting period
	- execute successful proposal

## Deploy

- Script: `script/Deploy.s.sol`
- Deploys:
	1. `GovToken` with `1,000,000 ether` supply
	2. `DAO` linked to token address

## Foundry Commands

```bash
forge build
forge test
forge script script/Deploy.s.sol:Deploy --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```
