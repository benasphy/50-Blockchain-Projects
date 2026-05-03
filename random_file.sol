//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

contract TodoList{

    struct Todo{
        string text;
        bool completed;
    }

    mapping(uint => Todo[]) private todos;

    event todoCreated(address indexed user, uint index, string text);
    event todoCompleted(address indexed user, uint index);
    event todoDeleted(address indexed user, uint index);

    function createTodo(string calldata _text) external{
        todos[msg.sender].push(Todo(_text, false));
        emit todoCreated(msg.sender, todos[msg.sender].length - 1, _text);

    }

    function toggleTodo(uint _index) external{
        require(_index < todos[msg.sender].length, "Invalid Index");

        Todo storage todo = todos[msg.sender][_index]
        todo.completed = !todo.completed;

        emit TodoCompleted(msg.sender, _index);
    }

    function deleteTodo(uint _index) external{
        require(_index < todos[msg.sender].length, "Invalid Index");

        uint last_index = todos[msg.sender].length - 1;
        todos[msg.sender][_index] = todos[msg.sender][last_index];
        todos[msg.sender].pop();

        emit TodoDeleted(msg.sender, _index);
    }

    function getTodo(address _user, uint _index) external view returns(string memory, bool){
        Todo memory todo = todos[msg.sender][_index];
        return todo(todo.text, todo.completed);
    }

    function getTodoCount(address _user) external view returns(uint){
        return todos[msg.sender].length;
    }
}