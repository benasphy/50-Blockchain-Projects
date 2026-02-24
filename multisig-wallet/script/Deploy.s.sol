// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MultiSigWallet.sol";

contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        address;
        owners[0] = msg.sender;
        owners[1] = vm.addr(1);
        owners[2] = vm.addr(2);

        MultiSigWallet wallet = new MultiSigWallet(owners, 2);

        vm.stopBroadcast();
    }
}