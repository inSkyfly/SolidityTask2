/**
作业 1：ERC20 代币
任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
合约包含以下标准 ERC20 功能：
balanceOf：查询账户余额。
transfer：转账。
approve 和 transferFrom：授权和代扣转账。
使用 event 记录转账和授权操作。
提供 mint 函数，允许合约所有者增发代币。
提示：
使用 mapping 存储账户余额和授权信息。
使用 event 定义 Transfer 和 Approval 事件。
部署到sepolia 测试网，导入到自己的钱包
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract MyERC20 {
    string public tokenName;
    string public tokenSymbol;
    uint8 public decimals;
    uint256 public totalSupply;

    address public owner;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    constructor(uint256 initalSupply) {
        tokenName = "MyToken";
        tokenSymbol = "MIT";
        decimals = 18;
        owner = msg.sender;

        _mint(msg.sender, initalSupply);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Mint to zero address");
        _mint(to, amount);
    }

    function _mint(address to, uint256 amount) private {
        require(balanceOf[to] == 0, "you already minted");
        balanceOf[to] = amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    function balanceOf1(address account) public view returns (uint256) {
        return balanceOf[account];
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        require(from != address(0), "transfer from zero address");
        require(to != address(0), "transfer to zero address");
        require(balanceOf[from] >= amount, "Insufficient balanceOf");
        require(
            allowance[from][msg.sender] >= amount,
            "Insufficient allowance"
        );

        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Transfer to zero address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "Approve to zero address");

        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function burn(uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient amount");

        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
        return true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call be this function ");
        _;
    }
}



