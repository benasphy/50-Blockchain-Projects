// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Verifier.sol";
import "../src/ZKApp.sol";

contract ZKTest is Test {
    Verifier verifier;
    ZKApp app;

    function setUp() public {
        verifier = new Verifier();
        app = new ZKApp(address(verifier));
    }

    function testValidProof() public {
        // x = 7 → y = 49
        Verifier.Proof memory proof = Verifier.Proof({
            a: 7,
            b: 0
        });

        uint256[1] memory inputs = [uint256(49)];

        app.submitProof(proof, inputs);

        assertTrue(app.verified(address(this)));
    }

    function testInvalidProof() public {
        Verifier.Proof memory proof = Verifier.Proof({
            a: 5,
            b: 0
        });

        uint256[1] memory inputs = [uint256(49)];

        vm.expectRevert();
        app.submitProof(proof, inputs);
    }
}