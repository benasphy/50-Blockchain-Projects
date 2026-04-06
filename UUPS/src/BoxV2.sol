// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./BoxV1.sol";

contract BoxV2 is BoxV1 {
    function increment() public {
        value += 1;
    }
}