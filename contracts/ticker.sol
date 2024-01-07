// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventTicketing {
    address public organizer;
    uint public ticketPrice;
    uint public totalTickets;
    uint public totalSold;
    mapping(address => uint) public tickets;

    constructor(uint _ticketPrice, uint _totalTickets) {
        organizer = msg.sender;
        ticketPrice = _ticketPrice;
        totalTickets = _totalTickets;
    }

    function buyTicket(uint _amount) public payable {
        require(msg.value == (_amount * ticketPrice), "Incorrect amount of ETH");
        require((totalSold + _amount) <= totalTickets, "Not enough tickets available");
        tickets[msg.sender] += _amount;
        totalSold += _amount;
    }

    function transferTicket(address _to, uint _amount) public {
        require(tickets[msg.sender] >= _amount, "Not enough tickets to transfer");
        tickets[msg.sender] -= _amount;
        tickets[_to] += _amount;
    }
}
