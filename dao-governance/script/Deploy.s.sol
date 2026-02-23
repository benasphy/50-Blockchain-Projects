// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/GovToken.sol";
import "../src/DAO.sol";

contract Deploy is Script {

    function run() external {

        vm.startBroadcast();

        GovToken token = new GovToken(1_000_000 ether);

        DAO dao = new DAO(address(token));

        vm.stopBroadcast();
    }
}