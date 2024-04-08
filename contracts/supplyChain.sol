// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    // Define a structure to represent a product
    struct Product {
        uint256 id;
        string name;
        address owner;
        uint256 timestamp;
    }

    // Mapping to store products
    mapping(uint256 => Product) public products;

    // Event to log product transfer
    event ProductTransfer(uint256 indexed productId, address indexed from, address indexed to, uint256 timestamp);

    // Function to create a new product
    function createProduct(uint256 _id, string memory _name) external {
        require(products[_id].id == 0, "Product ID already exists");
        products[_id] = Product(_id, _name, msg.sender, block.timestamp);
    }

    // Function to transfer ownership of a product
    function transferProduct(uint256 _id, address _to) external {
        require(products[_id].id != 0, "Product does not exist");
        require(products[_id].owner == msg.sender, "You are not the owner of this product");
        products[_id].owner = _to;
        products[_id].timestamp = block.timestamp;
        emit ProductTransfer(_id, msg.sender, _to, block.timestamp);
    }
}
