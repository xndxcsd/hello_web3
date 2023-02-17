// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

import "../ERC20/IERC20.sol";

contract Airdrop {

    function drop(address tokenAddress, address[] calldata addresses, uint256[] calldata amounts) external {
        require(addresses.length == amounts.length, "lengths of addresses and amounts are not equal");

        IERC20 myToken = IERC20(tokenAddress);
        uint256 sum = getSum(amounts);

        require(myToken.allowance(msg.sender, address(this)) >= sum, "approved amounts are not enough");

        for (uint i = 0; i < addresses.length; i++) {
            myToken.transferFrom(msg.sender, addresses[i], amounts[i]);
        }
    }

    function getSum(uint256[] calldata amounts) pure internal returns (uint256) {

        uint256 sum = 0;
        for (uint i = 0; i < amounts.length; i++) {
            sum += amounts[i];
        }
        return sum;
    }
}