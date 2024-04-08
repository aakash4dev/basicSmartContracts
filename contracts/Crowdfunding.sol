// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    // Define a structure to represent a crowdfunding campaign
    struct Campaign {
        uint256 id;
        address creator;
        uint256 goal;
        uint256 raisedAmount;
        bool completed;
    }

    // Mapping to store campaigns
    mapping(uint256 => Campaign) public campaigns;

    // Event to log campaign creation
    event CampaignCreated(uint256 indexed campaignId, address indexed creator, uint256 goal);

    // Event to log fund transfer
    event FundsTransferred(uint256 indexed campaignId, address indexed contributor, uint256 amount);

    // Function to create a new campaign
    function createCampaign(uint256 _id, uint256 _goal) external {
        require(campaigns[_id].id == 0, "Campaign ID already exists");
        campaigns[_id] = Campaign(_id, msg.sender, _goal, 0, false);
        emit CampaignCreated(_id, msg.sender, _goal);
    }

    // Function to contribute funds to a campaign
    function contribute(uint256 _id) external payable {
        require(campaigns[_id].id != 0, "Campaign does not exist");
        require(!campaigns[_id].completed, "Campaign is already completed");
        campaigns[_id].raisedAmount += msg.value;
        emit FundsTransferred(_id, msg.sender, msg.value);
        if (campaigns[_id].raisedAmount >= campaigns[_id].goal) {
            campaigns[_id].completed = true;
        }
    }

    // Function to withdraw funds from a completed campaign
    function withdrawFunds(uint256 _id) external {
        require(campaigns[_id].id != 0, "Campaign does not exist");
        require(campaigns[_id].completed, "Campaign is not completed");
        require(campaigns[_id].creator == msg.sender, "You are not the creator of this campaign");
        payable(msg.sender).transfer(campaigns[_id].raisedAmount);
    }
}
