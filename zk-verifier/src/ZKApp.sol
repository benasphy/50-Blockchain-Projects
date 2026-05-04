// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Verifier.sol";

contract ZKApp {
    Verifier public verifier;

    mapping(address => bool) public verified;

    constructor(address _verifier) {
        verifier = Verifier(_verifier);
    }

    function submitProof(
        Verifier.Proof memory proof,
        uint256[1] memory publicInputs
    ) external {
        bool ok = verifier.verifyProof(proof, publicInputs);
        require(ok, "invalid proof");

        verified[msg.sender] = true;
    }
}