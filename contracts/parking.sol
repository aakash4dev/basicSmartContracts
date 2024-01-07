// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ParkingSpaceRental {
    struct ParkingSpace {
        uint256 id;
        string location;
        address owner;
        bool isAvailable;
        uint256 rentalPrice;
    }

    mapping(uint256 => ParkingSpace) public parkingSpaces;

    event ParkingSpaceListed(uint256 id, uint256 rentalPrice);
    event ParkingSpaceRented(uint256 id, address renter);

    function listParkingSpace(uint256 _id, string memory _location, uint256 _rentalPrice) public {
        parkingSpaces[_id] = ParkingSpace(_id, _location, msg.sender, true, _rentalPrice);
        emit ParkingSpaceListed(_id, _rentalPrice);
    }

    function rentParkingSpace(uint256 _id) public payable {
        ParkingSpace storage space = parkingSpaces[_id];
        require(space.isAvailable, "Parking space is not available");
        require(msg.value == space.rentalPrice, "Incorrect rental price");
        space.isAvailable = false;
        emit ParkingSpaceRented(_id, msg.sender);
    }

    // Additional functions for managing parking space rentals
}
