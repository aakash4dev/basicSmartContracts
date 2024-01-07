// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProductWarranty {
    struct Warranty {
        uint256 id;
        address owner;
        uint256 purchaseDate;
        uint256 warrantyPeriod; // in days
    }

    mapping(uint256 => Warranty) public warranties;

    event WarrantyRegistered(uint256 id, address owner);
    event WarrantyTransferred(uint256 id, address newOwner);

    function registerWarranty(uint256 _id, uint256 _warrantyPeriod) public {
        warranties[_id] = Warranty(_id, msg.sender, block.timestamp, _warrantyPeriod);
        emit WarrantyRegistered(_id, msg.sender);
    }

    function transferWarranty(uint256 _id, address _newOwner) public {
        Warranty storage warranty = warranties[_id];
        require(msg.sender == warranty.owner, "Only the owner can transfer the warranty");
        warranty.owner = _newOwner;
        emit WarrantyTransferred(_id, _newOwner);
    }

    // Additional functions for verifying warranty validity
}
