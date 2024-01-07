// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarbonCreditTrading {
    struct CarbonCredit {
        uint256 id;
        address issuer;
        uint256 amount;
        uint256 pricePerUnit; // Set price per unit of carbon credit
    }

    CarbonCredit[] public credits;
    mapping(uint256 => address) public creditOwners;

    function issueCredits(uint256 _amount, uint256 _pricePerUnit) public {
        uint256 creditId = credits.length;
        credits.push(CarbonCredit(creditId, msg.sender, _amount, _pricePerUnit));
        creditOwners[creditId] = msg.sender;
    }

    function buyCredits(uint256 _creditId, uint256 _amount) public payable {
        CarbonCredit storage credit = credits[_creditId];
        require(_amount <= credit.amount, "Not enough credits available");
        require(msg.value == _amount * credit.pricePerUnit, "Incorrect payment amount");

        credit.amount -= _amount;
        // Transfer payment to the issuer and credits to the buyer
        payable(credit.issuer).transfer(msg.value);
        // Logic to transfer credit ownership to buyer
    }
}
