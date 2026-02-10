// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Lottery.sol";

contract DeployLottery is Script {
    function run() external {
        vm.startBroadcast();

        Lottery lottery = new Lottery();

        vm.stopBroadcast();
    }
}
