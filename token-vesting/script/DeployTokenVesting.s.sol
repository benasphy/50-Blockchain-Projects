// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyToken.sol";
import "../src/TokenVesting.sol";

contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        // Deploy token with 1M supply
        MyToken token = new MyToken(1_000_000 ether);

        // Deploy vesting contract
        TokenVesting vesting = new TokenVesting(address(token));

        // Fund vesting contract
        token.transfer(address(vesting), 100_000 ether);

        vm.stopBroadcast();
    }
}