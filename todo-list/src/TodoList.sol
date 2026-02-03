// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Todo List on Blockchain
/// @notice Each user manages their own todos
contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }

    /// @notice Mapping user => list of todos
    mapping(address => Todo[]) private todos;

    /// EVENTS
    event TodoCreated(address indexed user, uint256 index, string text);
    event TodoCompleted(address indexed user, uint256 index);
    event TodoDeleted(address indexed user, uint256 index);

    /// CREATE TODO
    function createTodo(string calldata _text) external {
        todos[msg.sender].push(Todo(_text, false));
        emit TodoCreated(msg.sender, todos[msg.sender].length - 1, _text);
    }

    /// TOGGLE TODO COMPLETION
    function toggleTodo(uint256 _index) external {
        require(_index < todos[msg.sender].length, "Invalid index");

        Todo storage todo = todos[msg.sender][_index];
        todo.completed = !todo.completed;

        emit TodoCompleted(msg.sender, _index);
    }

    /// DELETE TODO (swap & pop)
    function deleteTodo(uint256 _index) external {
        require(_index < todos[msg.sender].length, "Invalid index");

        uint256 lastIndex = todos[msg.sender].length - 1;
        todos[msg.sender][_index] = todos[msg.sender][lastIndex];
        todos[msg.sender].pop();

        emit TodoDeleted(msg.sender, _index);
    }

    /// READ FUNCTIONS
    function getTodo(address _user, uint256 _index) external view returns (string memory, bool) {
        Todo memory todo = todos[_user][_index];
        return (todo.text, todo.completed);
    }

    function getTodoCount(address _user) external view returns (uint256) {
        return todos[_user].length;
    }
}
