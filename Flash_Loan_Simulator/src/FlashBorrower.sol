// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

interface IFlashLoanPool {
    function flashLoan(uint256 amount) external;
}

contract FlashBorrower {

    IERC20 public token;
    IFlashLoanPool public pool;

    constructor(address _token, address _pool) {
        token = IERC20(_token);
        pool = IFlashLoanPool(_pool);
    }

    function startFlashLoan(uint256 amount) external {
        pool.flashLoan(amount);
    }

    function executeOperation(uint256 amount, uint256 fee) external {

        // ---------------- Arbitrage logic would go here ----------------
        // For now: do nothing

        // Repay loan + fee
        token.transfer(msg.sender, amount + fee);
    }
}