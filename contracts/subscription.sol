// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SubscriptionService {
    struct Subscription {
        uint256 id;
        address subscriber;
        uint256 startTime;
        uint256 endTime;
    }

    uint256 public subscriptionPrice;
    uint256 public subscriptionDuration; // in seconds
    Subscription[] public subscriptions;

    event NewSubscription(uint256 subscriptionId, address subscriber);
    event SubscriptionRenewed(uint256 subscriptionId, address subscriber);

    constructor(uint256 _price, uint256 _duration) {
        subscriptionPrice = _price;
        subscriptionDuration = _duration;
    }

    function subscribe() public payable {
        require(msg.value == subscriptionPrice, "Incorrect payment");
        uint256 subscriptionId = subscriptions.length;
        subscriptions.push(Subscription(subscriptionId, msg.sender, block.timestamp, block.timestamp + subscriptionDuration));
        emit NewSubscription(subscriptionId, msg.sender);
    }

    function renewSubscription(uint256 _subscriptionId) public payable {
        require(msg.value == subscriptionPrice, "Incorrect payment");
        Subscription storage subscription = subscriptions[_subscriptionId];
        require(subscription.subscriber == msg.sender, "Not the subscriber");
        subscription.endTime += subscriptionDuration;
        emit SubscriptionRenewed(_subscriptionId, msg.sender);
    }

    // Additional functions for subscription management
}
