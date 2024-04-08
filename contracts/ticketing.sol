// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventTicketing {
    // Define a structure to represent a ticket
    struct Ticket {
        uint256 eventId;
        address owner;
        bool isValid;
    }

    // Define a structure to represent an event
    struct Event {
        uint256 id;
        string name;
        uint256 totalTickets;
        uint256 ticketPrice;
        uint256 ticketsSold;
    }

    // Mapping to store events
    mapping(uint256 => Event) public events;

    // Mapping to store tickets for each event
    mapping(uint256 => Ticket[]) public eventTickets;

    // Event to log ticket purchase
    event TicketPurchased(uint256 indexed eventId, address indexed purchaser);

    // Function to create a new event
    function createEvent(uint256 _id, string memory _name, uint256 _totalTickets, uint256 _ticketPrice) external {
        require(events[_id].id == 0, "Event ID already exists");
        events[_id] = Event(_id, _name, _totalTickets, _ticketPrice, 0);
    }

    // Function to purchase a ticket for an event
    function purchaseTicket(uint256 _eventId) external payable {
        require(events[_eventId].id != 0, "Event does not exist");
        require(events[_eventId].ticketsSold < events[_eventId].totalTickets, "No tickets available");
        require(msg.value >= events[_eventId].ticketPrice, "Insufficient funds");
        
        events[_eventId].ticketsSold++;
        Ticket memory newTicket = Ticket(_eventId, msg.sender, true);
        eventTickets[_eventId].push(newTicket);
        
        emit TicketPurchased(_eventId, msg.sender);
    }

    // Function to verify if a ticket is valid
    function verifyTicket(uint256 _eventId, address _ticketOwner) external view returns (bool) {
        for (uint256 i = 0; i < eventTickets[_eventId].length; i++) {
            if (eventTickets[_eventId][i].owner == _ticketOwner && eventTickets[_eventId][i].isValid) {
                return true;
            }
        }
        return false;
    }
}
