// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyERC20.sol";

contract DeployMyERC20 is Script {
    function run() external {
        vm.startBroadcast();

        new MyERC20("MyToken", "MTK", 18, 1_000_000 ether);

        vm.stopBroadcast();
    }
}
