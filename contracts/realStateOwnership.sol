// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstateOwnership {
    struct Property {
        uint256 id;
        string location;
        address currentOwner;
    }

    mapping(uint256 => Property) public properties;

    event OwnershipTransferred(uint256 propertyId, address newOwner);

    function registerProperty(uint256 _id, string memory _location) public {
        Property storage newProperty = properties[_id];
        newProperty.id = _id;
        newProperty.location = _location;
        newProperty.currentOwner = msg.sender;
    }

    function transferOwnership(uint256 _propertyId, address _newOwner) public {
        Property storage property = properties[_propertyId];
        require(msg.sender == property.currentOwner, "Only the current owner can transfer ownership");
        property.currentOwner = _newOwner;
        emit OwnershipTransferred(_propertyId, _newOwner);
    }

    // Additional functions for property management
}
