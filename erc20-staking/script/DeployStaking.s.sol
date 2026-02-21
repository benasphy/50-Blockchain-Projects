// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/StakeToken.sol";
import "../src/Staking.sol";

contract DeployStaking is Script {
    function run() external {
        vm.startBroadcast();

        // 1️⃣ Deploy Stake Token with initial supply
        StakeToken token = new StakeToken(1_000_000 ether);

        // 2️⃣ Deploy Staking contract
        Staking staking = new Staking(address(token));

        vm.stopBroadcast();
    }
}