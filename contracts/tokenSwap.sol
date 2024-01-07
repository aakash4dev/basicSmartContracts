// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract TokenSwap {
    address public tokenA;
    address public tokenB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function swap(address fromToken, address toToken, uint256 amount) public {
        require(fromToken == tokenA || fromToken == tokenB, "Invalid fromToken");
        require(toToken == tokenA || toToken == tokenB, "Invalid toToken");
        require(fromToken != toToken, "fromToken and toToken cannot be the same");

        IERC20(fromToken).transferFrom(msg.sender, address(this), amount);
        IERC20(toToken).transfer(msg.sender, amount); // Add exchange logic based on rates
    }
}
