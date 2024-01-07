// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleVoting {
    mapping(address => bool) public voters;
    mapping(bytes32 => uint256) public votesReceived;
    bytes32[] public candidateList;

    event VoteCasted(bytes32 candidate, uint256 totalVotes);

    constructor(bytes32[] memory candidateNames) {
        candidateList = candidateNames;
    }

    function vote(bytes32 candidate) public {
        require(!voters[msg.sender], "Already voted");
        require(validCandidate(candidate), "Invalid candidate");
        voters[msg.sender] = true;
        votesReceived[candidate] += 1;
        emit VoteCasted(candidate, votesReceived[candidate]);
    }

    function totalVotesFor(bytes32 candidate) public view returns (uint256) {
        require(validCandidate(candidate), "Invalid candidate");
        return votesReceived[candidate];
    }

    function validCandidate(bytes32 candidate) view public returns (bool) {
        for(uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == candidate) {
                return true;
            }
        }
        return false;
    }
}
