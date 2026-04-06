// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Proxy.sol";
import "../src/BoxV1.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        BoxV1 impl = new BoxV1();

        bytes memory data = abi.encodeWithSelector(
            BoxV1.initialize.selector,
            100
        );

        Proxy proxy = new Proxy(address(impl), data);

        vm.stopBroadcast();
    }
}