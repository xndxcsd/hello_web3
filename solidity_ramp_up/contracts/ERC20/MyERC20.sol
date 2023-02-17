// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./IERC20.sol";

contract MyERC20 is IERC20 {
    // total supply
    uint256 private supply;

    // balances of users
    mapping(address => uint256) public balances;

    string public name;
    string public symbol;

    mapping(address => mapping(address => uint256)) allowances;

    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    /**
     * @dev 返回代币总供给.
     */
    function totalSupply() external view override returns (uint256) {
        return supply;
    }

    /**
     * @dev 返回账户`account`所持有的代币数.
     */
    function balanceOf(
        address account
    ) external view override returns (uint256) {
        return balances[account];
    }

    /**
     * @dev 转账 `amount` 单位代币，从调用者账户到另一账户 `to`.
     *
     * 如果成功，返回 `true`.
     *
     * 释放 {Transfer} 事件.
     */
    function transfer(
        address to,
        uint256 amount
    ) external override returns (bool) {
        require(amount != 0, "amount is 0");
        require(balances[msg.sender] >= amount, "balance is not enough");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    /**
     * @dev 返回`owner`账户授权给`spender`账户的额度，默认为0。
     *
     * 当{approve} 或 {transferFrom} 被调用时，`allowance`会改变.
     */
    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {
        return allowances[owner][spender];
    }

    /**
     * @dev 调用者账户给`spender`账户授权 `amount`数量代币。
     *
     * 如果成功，返回 `true`.
     *
     * 释放 {Approval} 事件.
     */
    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool) {
        require(balances[msg.sender] >= amount, "balance is not enough");
        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    /**
     * @dev 通过授权机制，从`from`账户向`to`账户转账`amount`数量代币。转账的部分会从调用者的`allowance`中扣除。
     *
     * 如果成功，返回 `true`.
     *
     * 释放 {Transfer} 事件.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool) {
        require(allowances[from][msg.sender] >= amount, "balance is not enough");

        allowances[from][msg.sender] -= amount;
        balances[from] -= amount;
        balances[to] += amount;

        return true;
    }

    // @dev 铸造代币，从 `0` 地址转账给 调用者地址
    function mint(uint amount) external {
        balances[msg.sender] += amount;
        supply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }
}
