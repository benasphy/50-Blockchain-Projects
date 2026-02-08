// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Escrow.sol";

contract DeployEscrow is Script {
    function run() external {
        address seller = vm.envAddress("SELLER");
        address arbiter = vm.envAddress("ARBITER");

        vm.startBroadcast();

        Escrow escrow = new Escrow{value: 1 ether}(seller, arbiter);

        vm.stopBroadcast();
    }
}
