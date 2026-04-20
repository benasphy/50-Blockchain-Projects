# Smart Contract Security Lab (Foundry)

## Topics Covered
- Reentrancy Attack
- Integer Overflow/Underflow
- Front-running (MEV simulation)

## Contracts

### Vault
- Vulnerable to reentrancy

### Token
- Uses unchecked math → overflow possible

### Exchange
- Price manipulation → front-running

## Attacks

### Reentrancy
Attacker contract recursively withdraws funds.

### Overflow
Integer wraps around due to unchecked math.

### Front-running
Transaction ordering exploited.

## Run Tests

```bash
forge test