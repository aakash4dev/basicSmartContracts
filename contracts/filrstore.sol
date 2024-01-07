// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedFileStorage {
    struct File {
        string hash;
        address owner;
    }

    mapping(string => File) public files;

    function addFile(string memory _hash) public {
        require(files[_hash].owner == address(0), "File already exists");
        files[_hash] = File(_hash, msg.sender);
    }

    function transferOwnership(string memory _hash, address _newOwner) public {
        require(files[_hash].owner == msg.sender, "Not the owner of the file");
        files[_hash].owner = _newOwner;
    }
}
