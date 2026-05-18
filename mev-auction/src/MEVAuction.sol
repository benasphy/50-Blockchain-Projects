// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MEVAuction {
    address public owner;

    uint256 public commitEnd;
    uint256 public revealEnd;

    bool public finalized;

    address public highestBidder;
    uint256 public highestBid;

    struct Commitment {
        bytes32 hash;
        uint256 deposit;

        bool revealed;
    }

    mapping(address => Commitment)
        public commitments;

    mapping(address => uint256)
        public refunds;

    event Committed(
        address indexed bidder
    );

    event Revealed(
        address indexed bidder,
        uint256 amount
    );

    event Finalized(
        address winner,
        uint256 amount
    );

    constructor(
        uint256 commitDuration,
        uint256 revealDuration
    ) {
        owner = msg.sender;

        commitEnd =
            block.timestamp +
            commitDuration;

        revealEnd =
            commitEnd +
            revealDuration;
    }

    // -----------------------------------
    // COMMIT PHASE
    // -----------------------------------

    function commitBid(
        bytes32 commitment
    ) external payable {
        require(
            block.timestamp < commitEnd,
            "commit ended"
        );

        require(
            commitments[msg.sender]
                .hash == bytes32(0),
            "already committed"
        );

        commitments[msg.sender] =
            Commitment({
                hash: commitment,
                deposit: msg.value,
                revealed: false
            });

        emit Committed(msg.sender);
    }

    // -----------------------------------
    // REVEAL PHASE
    // -----------------------------------

    function revealBid(
        uint256 amount,
        string calldata secret
    ) external {
        require(
            block.timestamp >= commitEnd,
            "reveal not started"
        );

        require(
            block.timestamp < revealEnd,
            "reveal ended"
        );

        Commitment storage c =
            commitments[msg.sender];

        require(!c.revealed);

        bytes32 computed =
            keccak256(
                abi.encodePacked(
                    amount,
                    secret
                )
            );

        require(
            computed == c.hash,
            "invalid reveal"
        );

        require(
            c.deposit >= amount,
            "deposit too low"
        );

        c.revealed = true;

        // update highest bid
        if (amount > highestBid) {
            // refund previous leader
            if (
                highestBidder !=
                address(0)
            ) {
                refunds[
                    highestBidder
                ] += highestBid;
            }

            highestBid = amount;

            highestBidder = msg.sender;
        } else {
            refunds[msg.sender] += amount;
        }

        emit Revealed(
            msg.sender,
            amount
        );
    }

    // -----------------------------------
    // FINALIZE
    // -----------------------------------

    function finalize() external {
        require(
            block.timestamp >= revealEnd,
            "not ended"
        );

        require(!finalized);

        finalized = true;

        emit Finalized(
            highestBidder,
            highestBid
        );
    }

    // -----------------------------------
    // WITHDRAW REFUNDS
    // -----------------------------------

    function withdrawRefund()
        external
    {
        uint256 amount =
            refunds[msg.sender];

        require(amount > 0);

        refunds[msg.sender] = 0;

        payable(msg.sender).transfer(
            amount
        );
    }

    // helper
    function generateCommitment(
        uint256 amount,
        string calldata secret
    ) external pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    amount,
                    secret
                )
            );
    }
}