// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AirlineFlightInsurance {
    struct InsurancePolicy {
        uint256 policyId;
        address passenger;
        uint256 flightId;
        uint256 insuranceAmount;
        bool isClaimed;
    }

    mapping(uint256 => InsurancePolicy) public policies;
    uint256 public nextPolicyId;

    event InsurancePurchased(uint256 policyId, uint256 flightId, address passenger);
    event InsuranceClaimed(uint256 policyId, uint256 amount);

    function purchaseInsurance(uint256 _flightId) public payable {
        uint256 policyId = nextPolicyId++;
        policies[policyId] = InsurancePolicy(policyId, msg.sender, _flightId, msg.value, false);
        emit InsurancePurchased(policyId, _flightId, msg.sender);
    }

    function claimInsurance(uint256 _policyId) public {
        InsurancePolicy storage policy = policies[_policyId];
        require(msg.sender == policy.passenger, "Only the insured passenger can claim");
        require(!policy.isClaimed, "Insurance already claimed");

        policy.isClaimed = true;
        payable(msg.sender).transfer(policy.insuranceAmount);
        emit InsuranceClaimed(_policyId, policy.insuranceAmount);
    }

    // Additional functions for managing insurance policies and claims
}
