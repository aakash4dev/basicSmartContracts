// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityDonation {
    address public owner;
    uint256 public totalDonations;

    event DonationReceived(address donor, uint256 amount);
    event FundsWithdrawn(address recipient, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function donate() public payable {
        require(msg.value > 0, "Donation must be greater than 0");
        totalDonations += msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }

    function withdrawFunds(address payable _recipient, uint256 _amount) public {
        require(msg.sender == owner, "Only owner can withdraw funds");
        require(_amount <= address(this).balance, "Insufficient balance");
        _recipient.transfer(_amount);
        emit FundsWithdrawn(_recipient, _amount);
    }

    // Additional functions for managing donations and transparency
}
