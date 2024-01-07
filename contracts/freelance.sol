// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FreelanceJob {
    struct Job {
        uint256 id;
        string description;
        uint256 payment;
        address employer;
        address freelancer;
        bool isCompleted;
    }

    Job[] public jobs;
    mapping(uint256 => bool) public jobTaken;

    event JobPosted(uint256 jobId, address employer);
    event JobTaken(uint256 jobId, address freelancer);
    event JobCompleted(uint256 jobId, address freelancer);

    function postJob(string memory _description, uint256 _payment) public {
        uint256 jobId = jobs.length;
        jobs.push(Job(jobId, _description, _payment, msg.sender, address(0), false));
        emit JobPosted(jobId, msg.sender);
    }

    function takeJob(uint256 _jobId) public {
        Job storage job = jobs[_jobId];
        require(!jobTaken[_jobId], "Job already taken");
        require(job.employer != msg.sender, "Employer cannot take own job");

        job.freelancer = msg.sender;
        jobTaken[_jobId] = true;
        emit JobTaken(_jobId, msg.sender);
    }

    function completeJob(uint256 _jobId) public {
        Job storage job = jobs[_jobId];
        require(job.freelancer == msg.sender, "Only assigned freelancer can complete the job");
        require(!job.isCompleted, "Job already completed");

        job.isCompleted = true;
        payable(job.freelancer).transfer(job.payment);
        emit JobCompleted(_jobId, msg.sender);
    }

    // Additional functions for managing payments and disputes
}
