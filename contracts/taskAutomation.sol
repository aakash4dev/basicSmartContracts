// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaskAutomation {
    struct Task {
        uint256 id;
        string description;
        uint256 interval; // Time interval in seconds
        uint256 lastExecution;
        address owner;
    }

    Task[] public tasks;
    mapping(uint256 => bool) public activeTasks;

    event TaskCreated(uint256 taskId, address owner);
    event TaskExecuted(uint256 taskId, address owner);

    function createTask(string memory _description, uint256 _interval) public {
        uint256 taskId = tasks.length;
        tasks.push(Task(taskId, _description, _interval, block.timestamp, msg.sender));
        activeTasks[taskId] = true;
        emit TaskCreated(taskId, msg.sender);
    }

    function executeTask(uint256 _taskId) public {
        Task storage task = tasks[_taskId];
        require(activeTasks[_taskId], "Task is not active");
        require(block.timestamp >= task.lastExecution + task.interval, "Task interval not reached");
        require(msg.sender == task.owner, "Only owner can execute the task");

        // Task logic goes here

        task.lastExecution = block.timestamp;
        emit TaskExecuted(_taskId, msg.sender);
    }

    // Additional functions to deactivate tasks or modify intervals
}
