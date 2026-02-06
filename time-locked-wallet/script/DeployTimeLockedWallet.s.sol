// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/TimeLockedWallet.sol";

contract DeployTimeLockedWallet is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        uint256 unlockTime = block.timestamp + 1 days;

        TimeLockedWallet wallet =
            new TimeLockedWallet{value: 1 ether}(unlockTime);

        console.log("Wallet deployed at:", address(wallet));
        console.log("Unlock time:", unlockTime);

        vm.stopBroadcast();
    }
}
