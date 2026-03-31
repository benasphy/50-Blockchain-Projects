// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address user) external view returns (uint256);
}

interface IFlashBorrower {
    function executeOperation(uint256 amount, uint256 fee) external;
}

contract FlashLoanPool {

    IERC20 public token;

    uint256 public constant FEE_BPS = 5; // 0.05%
    uint256 public constant DENOM = 10000;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function flashLoan(uint256 amount) external {

        uint256 balanceBefore = token.balanceOf(address(this));
        require(balanceBefore >= amount, "Not enough liquidity");

        uint256 fee = (amount * FEE_BPS) / DENOM;

        // Send funds
        token.transfer(msg.sender, amount);

        // Callback
        IFlashBorrower(msg.sender).executeOperation(amount, fee);

        uint256 balanceAfter = token.balanceOf(address(this));

        require(
            balanceAfter >= balanceBefore + fee,
            "Flash loan not repaid"
        );
    }
}