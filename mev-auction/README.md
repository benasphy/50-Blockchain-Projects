# MEV-Aware Auction System

## Features

- Commit-reveal auction
- Front-running resistance
- Sealed bids
- Refund system
- Winner settlement

## Concepts

- MEV mitigation
- Hidden bids
- Transaction ordering attacks
- Auction fairness

## Flow

1. Commit phase:
   submit hash(bid + secret)

2. Reveal phase:
   reveal bid and secret

3. Finalization:
   highest revealed bid wins

## Security Benefits

- Prevents mempool bid sniping
- Hides bids during commit phase
- Reduces front-running

## Run

forge test

## Real-world relevance

- Flashbots auctions
- Sealed NFT auctions
- MEV-resistant systems

## Limitations

- No zk privacy
- No encrypted mempool
- Manual reveal required