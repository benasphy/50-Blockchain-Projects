// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BoxV1 {
    // MUST match proxy storage layout expectations
    uint256 public value;
    address public owner;

    // same slot as proxy
    bytes32 internal constant IMPLEMENTATION_SLOT =
        0x360894A13BA1A3210667C828492DB98DCA3E2076CC3735A920A3CA505D382BBC;

    function initialize(uint256 _value) public {
        require(owner == address(0), "already initialized");
        owner = msg.sender;
        value = _value;
    }

    function setValue(uint256 _value) public {
        value = _value;
    }

    function upgradeTo(address newImplementation) public {
        require(msg.sender == owner, "not owner");

        assembly {
            sstore(IMPLEMENTATION_SLOT, newImplementation)
        }
    }
}