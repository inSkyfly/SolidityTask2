// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

/**
作业3：编写一个讨饭合约
任务目标
使用 Solidity 编写一个合约，允许用户向合约地址发送以太币。
记录每个捐赠者的地址和捐赠金额。
允许合约所有者提取所有捐赠的资金
 */

contract BeggingContract {
    address public owner;
    mapping(address => uint256) public donatorToAmount;
    uint256 private disploymentTimestamp;
    uint256 public lockTime;
    uint256 public totalDonations;

    event Donation(address indexed donator, uint256 amount);
    event Withdraw(address indexed owner, uint256 amount);

    constructor(uint256 _lockTime) {
        owner = msg.sender;
        disploymentTimestamp = block.timestamp;
        lockTime = _lockTime;
    }

    function donate() external payable windowOpen {
        require(msg.value > 0, "Donation amount must be greater than 0");
        donatorToAmount[msg.sender] += msg.value;
        totalDonations += msg.value;
        emit Donation(msg.sender, msg.value);
    }

    modifier windowOpen() {
        require(
            block.timestamp < disploymentTimestamp + lockTime,
            "Donation window is closed"
        );
        _;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "This function can only be called by owner"
        );
        _;
    }

    function withdraw() external onlyOwner returns (bool) {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "transfer failed");

        emit Withdraw(owner, balance);
        return true;
    }

    function getDonation(address donator) public view returns (uint256) {
        return donatorToAmount[donator];
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    //获取剩余时间
    function getRemainingTime() public view returns (uint256) {
        if (block.timestamp >= disploymentTimestamp + lockTime) {
            return 0;
        }
        return (disploymentTimestamp + lockTime) - block.timestamp;
    }
}
