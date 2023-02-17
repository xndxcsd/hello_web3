// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

import "../ERC20/IERC20.sol";

// Faucet for MyERC20
contract Faucet {

    // label the address which has requested
    mapping (address => bool) private requested;

    // MyERC20 contract address
    address private tokenContract;

    // unit amount for the faucet
    uint256 private unitAmount = 10;

    // event for a user request the token
    event SendToken(address indexed receiver, uint256 indexed amount);

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }
    

    function requestTokens() external {
        require(requested[msg.sender] == false, "requested for this amount");

        IERC20 myERC20 = IERC20(tokenContract);
        require(myERC20.balanceOf(address(this)) >= unitAmount, "balance of the faucet is not enough");

        myERC20.transfer(msg.sender, unitAmount);

        emit SendToken(msg.sender, unitAmount);
    }

}