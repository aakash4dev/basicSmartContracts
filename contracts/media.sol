// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedSocialMedia {
    struct Post {
        uint id;
        address author;
        string content;
        uint likes;
        uint timestamp;
    }

    Post[] public posts;
    mapping(address => uint[]) userPosts;
    mapping(uint => mapping(address => bool)) public likes;

    function createPost(string memory _content) public {
        uint postId = posts.length;
        posts.push(Post(postId, msg.sender, _content, 0, block.timestamp));
        userPosts[msg.sender].push(postId);
    }

    function likePost(uint _postId) public {
        require(!likes[_postId][msg.sender], "Already liked this post");
        likes[_postId][msg.sender] = true;
        posts[_postId].likes += 1;
    }
}
