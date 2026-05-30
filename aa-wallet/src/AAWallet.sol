// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AAWallet {
    address public owner;

    uint256 public nonce;

    mapping(address => bool)
        public guardians;

    uint256 public guardianVotes;

    mapping(address => bool)
        public voted;

    event Executed(
        address target,
        uint256 value
    );

    event OwnerChanged(
        address newOwner
    );

    constructor(address _owner) {
        owner = _owner;
    }

    receive() external payable {}

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "not owner"
        );
        _;
    }

    // -------------------------
    // Guardian Management
    // -------------------------

    function addGuardian(
        address guardian
    ) external onlyOwner {
        guardians[guardian] = true;
    }

    // -------------------------
    // Meta Transaction
    // -------------------------

    function execute(
        address target,
        uint256 value,
        bytes calldata data,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        bytes32 hash =
            keccak256(
                abi.encodePacked(
                    address(this),
                    target,
                    value,
                    data,
                    nonce
                )
            );

        address signer =
            ecrecover(
                hash,
                v,
                r,
                s
            );

        require(
            signer == owner,
            "invalid signature"
        );

        nonce++;

        (bool success, ) =
            target.call{value:value}(data);

        require(success);

        emit Executed(
            target,
            value
        );
    }

    // -------------------------
    // Batch Calls
    // -------------------------

    function executeBatch(
        address[] calldata targets,
        bytes[] calldata calls
    ) external onlyOwner {
        require(
            targets.length ==
            calls.length
        );

        for (
            uint256 i;
            i < targets.length;
            i++
        ) {
            (bool success, ) =
                targets[i].call(
                    calls[i]
                );

            require(success);
        }
    }

    // -------------------------
    // Social Recovery
    // -------------------------

    function voteNewOwner(
        address newOwner
    ) external {
        require(
            guardians[msg.sender],
            "not guardian"
        );

        require(
            !voted[msg.sender],
            "already voted"
        );

        voted[msg.sender] = true;

        guardianVotes++;

        if (guardianVotes >= 2) {
            owner = newOwner;

            guardianVotes = 0;

            emit OwnerChanged(
                newOwner
            );
        }
    }
}