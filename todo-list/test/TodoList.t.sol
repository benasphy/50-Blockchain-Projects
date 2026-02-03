// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TodoList.sol";

contract TodoListTest is Test {
    TodoList todoList;

    address alice = address(0xA11CE);
    address bob   = address(0xB0B);

    function setUp() public {
        todoList = new TodoList();
    }

    function testCreateTodo() public {
        vm.prank(alice);
        todoList.createTodo("Learn Solidity");

        uint256 count = todoList.getTodoCount(alice);
        assertEq(count, 1);

        (string memory text, bool completed) = todoList.getTodo(alice, 0);
        assertEq(text, "Learn Solidity");
        assertFalse(completed);
    }

    function testToggleTodo() public {
        vm.startPrank(alice);
        todoList.createTodo("Write tests");
        todoList.toggleTodo(0);
        vm.stopPrank();

        (, bool completed) = todoList.getTodo(alice, 0);
        assertTrue(completed);
    }

    function testDeleteTodo() public {
        vm.startPrank(alice);
        todoList.createTodo("Task 1");
        todoList.createTodo("Task 2");
        todoList.deleteTodo(0);
        vm.stopPrank();

        uint256 count = todoList.getTodoCount(alice);
        assertEq(count, 1);
    }

    function testDifferentUsersHaveDifferentTodos() public {
        vm.prank(alice);
        todoList.createTodo("Alice task");

        vm.prank(bob);
        todoList.createTodo("Bob task");

        assertEq(todoList.getTodoCount(alice), 1);
        assertEq(todoList.getTodoCount(bob), 1);
    }

    function testInvalidIndexReverts() public {
        vm.prank(alice);
        vm.expectRevert("Invalid index");
        todoList.toggleTodo(0);
    }
}
