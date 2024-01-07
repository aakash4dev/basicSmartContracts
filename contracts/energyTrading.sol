// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnergyTrading {
    struct EnergyOffer {
        uint256 id;
        address seller;
        uint256 amount; // Amount of energy in kWh
        uint256 pricePerUnit;
    }

    EnergyOffer[] public offers;

    event OfferCreated(uint256 offerId, address seller, uint256 amount, uint256 pricePerUnit);
    event EnergyPurchased(uint256 offerId, address buyer, uint256 amount);

    function createOffer(uint256 _amount, uint256 _pricePerUnit) public {
        uint256 offerId = offers.length;
        offers.push(EnergyOffer(offerId, msg.sender, _amount, _pricePerUnit));
        emit OfferCreated(offerId, msg.sender, _amount, _pricePerUnit);
    }

    function purchaseEnergy(uint256 _offerId, uint256 _amount) public payable {
        EnergyOffer storage offer = offers[_offerId];
        require(_amount <= offer.amount, "Not enough energy available");
        require(msg.value == _amount * offer.pricePerUnit, "Incorrect payment amount");

        offer.amount -= _amount;
        payable(offer.seller).transfer(msg.value);
        emit EnergyPurchased(_offerId, msg.sender, _amount);
    }

    // Additional functions for managing energy offers and transactions
}
