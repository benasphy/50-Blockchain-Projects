// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title SimpleWallet
 * @author Benjamin
 * @notice A minimal ETH wallet to learn payable, msg.sender, msg.value
 */
contract SimpleWallet {
    address public owner;

    event Deposit(address indexed sender, uint256 amount);
    event Withdraw(address indexed receiver, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Deposit ETH into the wallet
     * payable → allows receiving ETH
     */
    function deposit() external payable {
        require(msg.value > 0, "Send some ETH");
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @notice Withdraw ETH from the wallet
     */
    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");

        // recommended way to send ETH
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "ETH transfer failed");

        emit Withdraw(owner, amount);
    }

    /**
     * @notice Get wallet ETH balance
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice Allow direct ETH transfers (without calling deposit)
     */
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}
