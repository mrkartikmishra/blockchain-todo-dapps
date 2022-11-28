// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract TodoContract {
    event AddTodo(address receiient, uint256 todoId);
    event DeleteTodo(uint256 todoId, bool isDeleted);

    struct Todo {
        uint256 id;
        string todoText;
        bool isDeleted;
    }

    Todo[] private todos;

    mapping(uint256 => address) todoToOwner;

    function addTodo(string memory todoText, bool isDeleted) external {
        uint256 todoId = todos.length;
        todos.push(Todo(todoId, todoText, isDeleted));
        todoToOwner[todoId] = msg.sender;
        emit AddTodo(msg.sender, todoId);
    }

    function deleteTodo(uint256 todoId, bool isDeleted) external {
        if (todoToOwner[todoId] == msg.sender) {
            todos[todoId].isDeleted = isDeleted;
            emit DeleteTodo(todoId, isDeleted);
        }
    }

    function fetchMyTodos() external view returns (Todo[] memory) {
        Todo[] memory result = new Todo[](todos.length);

        uint256 counter = 0;

        for (uint256 i = 0; i < todos.length; i++) {
            if (todoToOwner[i] == msg.sender && todos[i].isDeleted == false) {
                result[counter] = todos[i];
                counter++;
            }
        }

        return result;
    }
}
