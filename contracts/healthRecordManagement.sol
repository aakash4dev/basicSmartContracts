// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthRecordManagement {
    struct HealthRecord {
        uint256 id;
        string data; // Encrypted data
        address patient;
        bool isShared;
    }

    HealthRecord[] public healthRecords;
    mapping(uint256 => address) public recordAccess;

    function createRecord(string memory _data) public {
        uint256 recordId = healthRecords.length;
        healthRecords.push(HealthRecord(recordId, _data, msg.sender, false));
    }

    function shareRecord(uint256 _recordId, address _with) public {
        HealthRecord storage record = healthRecords[_recordId];
        require(msg.sender == record.patient, "Only the patient can share their record");
        record.isShared = true;
        recordAccess[_recordId] = _with;
    }

    function revokeAccess(uint256 _recordId) public {
        HealthRecord storage record = healthRecords[_recordId];
        require(msg.sender == record.patient, "Only the patient can revoke access");
        record.isShared = false;
        recordAccess[_recordId] = address(0);
    }
}
