// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReferralSystem {
    mapping(address => address) public referrals; // Referee => Referrer
    mapping(address => uint256) public rewards;

    event NewReferral(address indexed referrer, address indexed referee);
    event RewardPaid(address indexed referrer, uint256 reward);

    function refer(address _referee) public {
        require(referrals[_referee] == address(0), "Already referred");
        require(_referee != msg.sender, "Cannot refer yourself");

        referrals[_referee] = msg.sender;
        emit NewReferral(msg.sender, _referee);
    }

    function claimRewards() public {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to claim");

        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
        emit RewardPaid(msg.sender, reward);
    }

    // Additional functions to calculate and add rewards
}
