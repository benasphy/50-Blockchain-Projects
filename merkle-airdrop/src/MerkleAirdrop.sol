// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract MerkleAirdrop {

    bytes32 public immutable merkleRoot;
    IERC20 public token;

    mapping(address => bool) public claimed;

    event Claimed(address indexed user, uint256 amount);

    constructor(address _token, bytes32 _root) {
        token = IERC20(_token);
        merkleRoot = _root;
    }

    function claim(uint256 amount, bytes32[] calldata proof) external {

        require(!claimed[msg.sender], "Already claimed");

        // Create leaf node
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));

        // Verify proof
        require(verify(proof, leaf), "Invalid proof");

        claimed[msg.sender] = true;

        require(token.transfer(msg.sender, amount), "Transfer failed");

        emit Claimed(msg.sender, amount);
    }

    // ---------------- Merkle Verification ----------------

    function verify(bytes32[] memory proof, bytes32 leaf)
        public
        view
        returns (bool)
    {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash < proofElement) {
                computedHash = keccak256(
                    abi.encodePacked(computedHash, proofElement)
                );
            } else {
                computedHash = keccak256(
                    abi.encodePacked(proofElement, computedHash)
                );
            }
        }

        return computedHash == merkleRoot;
    }
}