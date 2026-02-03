// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/TodoList.sol";

contract DeployTodo is Script {
    function run() external {
        vm.startBroadcast();

        TodoList todo = new TodoList();
        todo.createTodo("Deploy on Anvil");

        vm.stopBroadcast();
    }
}
