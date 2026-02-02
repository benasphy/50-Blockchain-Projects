// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyContract.sol";

contract Interact is Script {
    function run() external {
        vm.startBroadcast();

        MyContract myContract = new MyContract();
        myContract.setValue(777);

        vm.stopBroadcast();
    }
}
