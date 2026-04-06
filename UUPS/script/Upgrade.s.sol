// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/BoxV1.sol";
import "../src/BoxV2.sol";

contract Upgrade is Script {
    function run() external {
        vm.startBroadcast();

        address proxyAddress = vm.envAddress("PROXY_ADDRESS");

        BoxV2 newImpl = new BoxV2();

        BoxV1(proxyAddress).upgradeTo(address(newImpl));

        vm.stopBroadcast();
    }
}