// test/FlashLoan.t.sol
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Token.sol";
import "../src/FlashLoanPool.sol";
import "../src/FlashBorrower.sol";

contract FlashLoanTest is Test {

    Token token;
    FlashLoanPool pool;
    FlashBorrower borrower;

    function setUp() public {

        token = new Token("T", "T", 1_000_000 ether);
        pool = new FlashLoanPool(address(token));
        borrower = new FlashBorrower(address(token), address(pool));

        token.transfer(address(pool), 500_000 ether);

        // Give borrower some tokens for fee repayment
        token.transfer(address(borrower), 1000 ether);
    }

    function testFlashLoan() public {

        borrower.startFlashLoan(100 ether);

        assertGt(token.balanceOf(address(pool)), 500_000 ether);
    }

    function testFailFlashLoanNotRepaid() public {

        // Create malicious borrower
        BadBorrower bad = new BadBorrower(address(token), address(pool));

        vm.expectRevert();
        bad.startFlashLoan(100 ether);
    }
}

contract BadBorrower {

    IERC20 token;
    FlashLoanPool pool;

    constructor(address _token, address _pool) {
        token = IERC20(_token);
        pool = FlashLoanPool(_pool);
    }

    function startFlashLoan(uint256 amount) external {
        pool.flashLoan(amount);
    }

    function executeOperation(uint256, uint256) external {
        // DO NOT repay
    }
}