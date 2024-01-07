// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WeddingRegistry {
    address public couple;
    mapping(string => bool) public gifts;
    mapping(string => address) public giftGivers;

    event GiftRegistered(string gift);
    event GiftGiven(string gift, address giver);

    constructor() {
        couple = msg.sender;
    }

    function registerGift(string memory _gift) public {
        require(msg.sender == couple, "Only couple can register a gift");
        gifts[_gift] = true;
        emit GiftRegistered(_gift);
    }

    function giveGift(string memory _gift) public {
        require(gifts[_gift], "Gift is not registered");
        require(giftGivers[_gift] == address(0), "Gift already given");
        giftGivers[_gift] = msg.sender;
        emit GiftGiven(_gift, msg.sender);
    }

    // Additional functions for managing the registry and gift status
}
