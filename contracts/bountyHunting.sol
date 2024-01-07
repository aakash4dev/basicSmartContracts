// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BountyHunting {
    struct Bounty {
        uint256 id;
        string description;
        uint256 reward;
        address issuer;
        bool isClaimed;
    }

    Bounty[] public bounties;

    event BountyPosted(uint256 bountyId, uint256 reward, address issuer);
    event BountyClaimed(uint256 bountyId, address claimant);

    function postBounty(string memory _description, uint256 _reward) public payable {
        require(msg.value == _reward, "Reward must match the sent amount");
        uint256 bountyId = bounties.length;
        bounties.push(Bounty(bountyId, _description, _reward, msg.sender, false));
        emit BountyPosted(bountyId, _reward, msg.sender);
    }

    function claimBounty(uint256 _bountyId) public {
        Bounty storage bounty = bounties[_bountyId];
        require(!bounty.isClaimed, "Bounty already claimed");
        require(msg.sender != bounty.issuer, "Issuer cannot claim their own bounty");

        bounty.isClaimed = true;
        payable(msg.sender).transfer(bounty.reward);
        emit BountyClaimed(_bountyId, msg.sender);
    }

    // Additional functions for bounty management and verification
}
