// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasStationPayment {
    address public owner;
    mapping(address => uint256) public balances;

    event PaymentMade(address customer, uint256 amount);
    event PaymentWithdrawn(address station, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function makePayment() public payable {
        require(msg.value > 0, "Payment must be greater than 0");
        balances[owner] += msg.value;
        emit PaymentMade(msg.sender, msg.value);
    }

    function withdrawPayment(address payable _station, uint256 _amount) public {
        require(msg.sender == owner, "Only owner can withdraw payments");
        require(_amount <= balances[owner], "Insufficient balance");
        balances[owner] -= _amount;
        _station.transfer(_amount);
        emit PaymentWithdrawn(_station, _amount);
    }

    // Additional functions for managing payments and gas station accounts
}
