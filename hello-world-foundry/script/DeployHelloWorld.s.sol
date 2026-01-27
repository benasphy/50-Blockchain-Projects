// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import "../src/HelloWorld.sol";

contract DeployHelloWorld is Script{
    function run() external{
        vm.startBroadcast();

        HelloWorld hello = new HelloWorld("Hello From Eduera");
        
        vm.stopBroadcast();
    }
}
