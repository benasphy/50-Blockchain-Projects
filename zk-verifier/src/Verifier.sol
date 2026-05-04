// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Verifier {
    // simplified "proof"
    struct Proof {
        uint256 a;
        uint256 b;
    }

    // fake verify (in real case → pairing check)
    function verifyProof(
        Proof memory proof,
        uint256[1] memory publicInputs
    ) public pure returns (bool) {
        uint256 y = publicInputs[0];

        // pretend proof encodes x
        uint256 x = proof.a;

        return x * x == y;
    }
}