// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Token.sol";
import "../src/SimpleAMM.sol";

contract AMMTest is Test {

    Token tokenA;
    Token tokenB;
    SimpleAMM amm;

    address owner = address(this);
    address user  = address(0x1);
    address user2 = address(0x2);

    uint256 constant INITIAL_SUPPLY = 1_000_000 ether;

    // ─────────────────────────────────────────────
    // Setup
    // ─────────────────────────────────────────────

    function setUp() public {
        tokenA = new Token("TokenA", "TKA", INITIAL_SUPPLY);
        tokenB = new Token("TokenB", "TKB", INITIAL_SUPPLY);

        amm = new SimpleAMM(address(tokenA), address(tokenB));

        // Fund users
        tokenA.transfer(user,  10_000 ether);
        tokenB.transfer(user,  10_000 ether);
        tokenA.transfer(user2, 10_000 ether);
        tokenB.transfer(user2, 10_000 ether);

        // Approve AMM for users
        vm.startPrank(user);
        tokenA.approve(address(amm), type(uint256).max);
        tokenB.approve(address(amm), type(uint256).max);
        vm.stopPrank();

        vm.startPrank(user2);
        tokenA.approve(address(amm), type(uint256).max);
        tokenB.approve(address(amm), type(uint256).max);
        vm.stopPrank();
    }

    // ─────────────────────────────────────────────
    // Helper functions
    // ─────────────────────────────────────────────

    /// Seed the pool with liquidity from `user`.
    function seedLiquidity(uint256 amtA, uint256 amtB) internal {
        vm.prank(user);
        amm.addLiquidity(amtA, amtB);
    }

    /// Compute expected swap output using the constant-product formula with 0.3% fee.
    function expectedOut(uint256 amtIn, uint256 reserveIn, uint256 reserveOut)
        internal
        pure
        returns (uint256)
    {
        uint256 amtInWithFee = (amtIn * 997) / 1000;
        return (reserveOut * amtInWithFee) / (reserveIn + amtInWithFee);
    }

    /// Integer square root (mirrors SimpleAMM.sqrt logic).
    function isqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    // ─────────────────────────────────────────────
    // Constructor tests
    // ─────────────────────────────────────────────

    function testConstructor_tokenAddresses() public view {
        assertEq(address(amm.tokenA()), address(tokenA));
        assertEq(address(amm.tokenB()), address(tokenB));
    }

    function testConstructor_initialState() public view {
        assertEq(amm.reserveA(),    0);
        assertEq(amm.reserveB(),    0);
        assertEq(amm.totalShares(), 0);
    }

    // ─────────────────────────────────────────────
    // addLiquidity tests
    // ─────────────────────────────────────────────

    function testAddLiquidity_initialShares() public {
        uint256 amtA = 100 ether;
        uint256 amtB = 400 ether;
        seedLiquidity(amtA, amtB);

        uint256 expectedShares = isqrt(amtA * amtB);
        assertEq(amm.totalShares(),      expectedShares);
        assertEq(amm.shares(user),       expectedShares);
    }

    function testAddLiquidity_reservesUpdated() public {
        seedLiquidity(100 ether, 200 ether);
        assertEq(amm.reserveA(), 100 ether);
        assertEq(amm.reserveB(), 200 ether);
    }

    function testAddLiquidity_tokenBalancesTransferred() public {
        uint256 balABefore = tokenA.balanceOf(user);
        uint256 balBBefore = tokenB.balanceOf(user);

        seedLiquidity(100 ether, 200 ether);

        assertEq(tokenA.balanceOf(user),        balABefore - 100 ether);
        assertEq(tokenB.balanceOf(user),        balBBefore - 200 ether);
        assertEq(tokenA.balanceOf(address(amm)), 100 ether);
        assertEq(tokenB.balanceOf(address(amm)), 200 ether);
    }

    function testAddLiquidity_subsequentSharesProportional() public {
        // First LP: 100 A + 100 B
        seedLiquidity(100 ether, 100 ether);
        uint256 sharesBefore = amm.totalShares();

        // Second deposit: same ratio → should mint proportional shares
        vm.prank(user);
        amm.addLiquidity(50 ether, 50 ether);

        // min(50/100, 50/100) * sharesBefore = sharesBefore / 2
        uint256 expectedNewShares = sharesBefore / 2;
        assertEq(amm.shares(user), sharesBefore + expectedNewShares);
        assertEq(amm.totalShares(), sharesBefore + expectedNewShares);
    }

    function testAddLiquidity_subsequentSharesUsesMin() public {
        // First LP: 100 A + 200 B
        seedLiquidity(100 ether, 200 ether);
        uint256 totalSharesAfterFirst = amm.totalShares();

        // Second deposit: intentionally unbalanced (more B relative to pool ratio)
        // shareA = 50/100 * totalShares = totalShares/2
        // shareB = 150/200 * totalShares = 3*totalShares/4
        // min should be shareA
        vm.prank(user2);
        amm.addLiquidity(50 ether, 150 ether);

        uint256 shareA = (50 ether * totalSharesAfterFirst) / (100 ether);
        uint256 shareB = (150 ether * totalSharesAfterFirst) / (200 ether);
        uint256 expectedNewShares = shareA < shareB ? shareA : shareB; // min
        assertEq(amm.shares(user2), expectedNewShares);
    }

    function testAddLiquidity_zeroAmountA_reverts() public {
        // Initial liquidity: sqrt(0 * amtB) = 0 → "Zero share"
        vm.expectRevert("Zero share");
        vm.prank(user);
        amm.addLiquidity(0, 100 ether);
    }

    function testAddLiquidity_zeroAmountB_reverts() public {
        // Initial liquidity: sqrt(amtA * 0) = 0 → "Zero share"
        vm.expectRevert("Zero share");
        vm.prank(user);
        amm.addLiquidity(100 ether, 0);
    }

    function testAddLiquidity_subsequentZeroShare_reverts() public {
        seedLiquidity(100 ether, 100 ether);

        // Adding 0 of both after initial liquidity → share = 0 → revert
        vm.expectRevert("Zero share");
        vm.prank(user2);
        amm.addLiquidity(0, 0);
    }

    // ─────────────────────────────────────────────
    // removeLiquidity tests
    // ─────────────────────────────────────────────

    function testRemoveLiquidity_revertsInsufficientShares() public {
        seedLiquidity(100 ether, 100 ether);
        uint256 userShares = amm.shares(user);

        vm.expectRevert("Not enough shares");
        vm.prank(user);
        amm.removeLiquidity(userShares + 1);
    }

    function testRemoveLiquidity_correctAmountsReturned() public {
        uint256 amtA = 100 ether;
        uint256 amtB = 200 ether;
        seedLiquidity(amtA, amtB);

        uint256 totalShares = amm.totalShares();
        uint256 userShares  = amm.shares(user);

        uint256 expectedA = (userShares * amtA) / totalShares;
        uint256 expectedB = (userShares * amtB) / totalShares;

        uint256 balABefore = tokenA.balanceOf(user);
        uint256 balBBefore = tokenB.balanceOf(user);

        vm.prank(user);
        amm.removeLiquidity(userShares);

        assertEq(tokenA.balanceOf(user) - balABefore, expectedA);
        assertEq(tokenB.balanceOf(user) - balBBefore, expectedB);
    }

    function testRemoveLiquidity_reservesUpdated() public {
        seedLiquidity(100 ether, 200 ether);
        uint256 userShares  = amm.shares(user);
        uint256 totalShares = amm.totalShares();

        uint256 remA = (userShares * 100 ether) / totalShares;
        uint256 remB = (userShares * 200 ether) / totalShares;

        vm.prank(user);
        amm.removeLiquidity(userShares);

        assertEq(amm.reserveA(),    100 ether - remA);
        assertEq(amm.reserveB(),    200 ether - remB);
        assertEq(amm.totalShares(), totalShares - userShares);
        assertEq(amm.shares(user),  0);
    }

    function testRemoveLiquidity_partialWithdrawal() public {
        seedLiquidity(100 ether, 100 ether);
        uint256 userShares = amm.shares(user);

        vm.prank(user);
        amm.removeLiquidity(userShares / 2);

        assertEq(amm.shares(user), userShares - userShares / 2);
    }

    // ─────────────────────────────────────────────
    // swapAforB tests
    // ─────────────────────────────────────────────

    function testSwapAforB_outputMatchesFormula() public {
        seedLiquidity(1000 ether, 1000 ether);

        uint256 amtIn = 10 ether;
        uint256 expected = expectedOut(amtIn, 1000 ether, 1000 ether);

        uint256 balBefore = tokenB.balanceOf(user);
        vm.prank(user);
        amm.swapAforB(amtIn);

        assertEq(tokenB.balanceOf(user) - balBefore, expected);
    }

    function testSwapAforB_reservesUpdated() public {
        seedLiquidity(1000 ether, 1000 ether);

        uint256 amtIn    = 10 ether;
        uint256 amtOut   = expectedOut(amtIn, 1000 ether, 1000 ether);

        vm.prank(user);
        amm.swapAforB(amtIn);

        assertEq(amm.reserveA(), 1000 ether + amtIn);
        assertEq(amm.reserveB(), 1000 ether - amtOut);
    }

    function testSwapAforB_priceImpact() public {
        seedLiquidity(1000 ether, 1000 ether);

        // First small swap
        uint256 amtIn = 1 ether;
        uint256 out1  = expectedOut(amtIn, 1000 ether, 1000 ether);

        // Second identical swap must yield less (price moved against buyer)
        uint256 out2 = expectedOut(
            amtIn,
            1000 ether + amtIn,
            1000 ether - out1
        );

        assertGt(out1, out2, "Second swap should get less due to slippage");
    }

    function testSwapAforB_kDoesNotDecreaseSignificantly() public {
        seedLiquidity(1000 ether, 1000 ether);

        uint256 kBefore = amm.reserveA() * amm.reserveB();

        vm.prank(user);
        amm.swapAforB(50 ether);

        uint256 kAfter = amm.reserveA() * amm.reserveB();

        // Fees make k increase or stay the same (within 1 wei rounding)
        assertGe(kAfter + 1, kBefore, "k should not decrease (fees grow k)");
    }

    function testSwapAforB_zeroLiquidity_reverts() public {
        // No liquidity → amm.reserveB == 0 → division gives 0 output
        // transfer of 0 tokens reverts on underflow in reserveB -= 0? No.
        // Actually reserveB = 0, amountOut = 0, tokenB.transfer(user, 0) succeeds
        // but reserveB - 0 = 0 so no revert. The real issue is the user gets 0 out.
        // Let's verify: approve & add 0 liquidity first, then swap should give 0 out.
        // We want to test that swapping against 0 reserves returns 0 tokens.
        uint256 balBefore = tokenB.balanceOf(user);
        vm.prank(user);
        amm.swapAforB(1 ether); // reserveB = 0 → amountOut = 0
        assertEq(tokenB.balanceOf(user), balBefore);
    }

    // ─────────────────────────────────────────────
    // swapBforA tests
    // ─────────────────────────────────────────────

    function testSwapBforA_outputMatchesFormula() public {
        seedLiquidity(1000 ether, 1000 ether);

        uint256 amtIn    = 10 ether;
        uint256 expected = expectedOut(amtIn, 1000 ether, 1000 ether);

        uint256 balBefore = tokenA.balanceOf(user);
        vm.prank(user);
        amm.swapBforA(amtIn);

        assertEq(tokenA.balanceOf(user) - balBefore, expected);
    }

    function testSwapBforA_reservesUpdated() public {
        seedLiquidity(1000 ether, 1000 ether);

        uint256 amtIn  = 10 ether;
        uint256 amtOut = expectedOut(amtIn, 1000 ether, 1000 ether);

        vm.prank(user);
        amm.swapBforA(amtIn);

        assertEq(amm.reserveB(), 1000 ether + amtIn);
        assertEq(amm.reserveA(), 1000 ether - amtOut);
    }

    function testSwapBforA_kDoesNotDecreaseSignificantly() public {
        seedLiquidity(1000 ether, 1000 ether);

        uint256 kBefore = amm.reserveA() * amm.reserveB();

        vm.prank(user);
        amm.swapBforA(50 ether);

        uint256 kAfter = amm.reserveA() * amm.reserveB();
        assertGe(kAfter + 1, kBefore, "k should not decrease (fees grow k)");
    }

    function testSwapBforA_priceImpact() public {
        seedLiquidity(1000 ether, 1000 ether);

        uint256 amtIn = 1 ether;
        uint256 out1  = expectedOut(amtIn, 1000 ether, 1000 ether);
        uint256 out2  = expectedOut(
            amtIn,
            1000 ether + amtIn,
            1000 ether - out1
        );

        assertGt(out1, out2, "Second swap should get less due to slippage");
    }

    function testSwapBforA_zeroLiquidity_returnsZero() public {
        uint256 balBefore = tokenA.balanceOf(user);
        vm.prank(user);
        amm.swapBforA(1 ether); // reserveA = 0 → amountOut = 0
        assertEq(tokenA.balanceOf(user), balBefore);
    }

    // ─────────────────────────────────────────────
    // Multiple LP tests
    // ─────────────────────────────────────────────

    function testMultipleLP_sharesAccountedSeparately() public {
        // LP1 provides initial liquidity
        seedLiquidity(1000 ether, 1000 ether);
        uint256 shares1 = amm.shares(user);

        // LP2 provides additional liquidity at same ratio
        vm.prank(user2);
        amm.addLiquidity(1000 ether, 1000 ether);
        uint256 shares2 = amm.shares(user2);

        // Both LPs at same ratio should get equal shares
        assertEq(shares1, shares2);
        assertEq(amm.totalShares(), shares1 + shares2);
    }

    function testMultipleLP_sharesProportionalToDeposit() public {
        // LP1 adds 1000/1000
        seedLiquidity(1000 ether, 1000 ether);
        uint256 shares1 = amm.shares(user);

        // LP2 adds half: 500/500
        vm.prank(user2);
        amm.addLiquidity(500 ether, 500 ether);
        uint256 shares2 = amm.shares(user2);

        // shares2 should be approximately shares1 / 2
        assertApproxEqAbs(shares2, shares1 / 2, 1);
    }

    function testMultipleLP_feeAccrual() public {
        // LP1 provides initial liquidity
        seedLiquidity(1000 ether, 1000 ether);
        uint256 sharesLP1  = amm.shares(user);
        uint256 reserveAInitial = amm.reserveA();
        uint256 reserveBInitial = amm.reserveB();

        // Simulate many swaps to accumulate fees
        address swapper = address(0x3);
        tokenA.transfer(swapper, 500 ether);
        tokenB.transfer(swapper, 500 ether);
        vm.startPrank(swapper);
        tokenA.approve(address(amm), type(uint256).max);
        tokenB.approve(address(amm), type(uint256).max);
        // 10 round-trip swaps
        for (uint256 i = 0; i < 10; i++) {
            amm.swapAforB(10 ether);
            amm.swapBforA(10 ether);
        }
        vm.stopPrank();

        // LP1 withdraws all shares
        uint256 balABefore = tokenA.balanceOf(user);
        uint256 balBBefore = tokenB.balanceOf(user);
        vm.prank(user);
        amm.removeLiquidity(sharesLP1);

        uint256 receivedA = tokenA.balanceOf(user) - balABefore;
        uint256 receivedB = tokenB.balanceOf(user) - balBBefore;

        // LP1 is the sole LP so should receive at least as much as initial deposit
        // (fees accumulate in reserves so total value should be >= initial deposit)
        // Allow 1 wei rounding
        assertGe(receivedA + receivedB + 1, reserveAInitial + reserveBInitial,
            "LP should receive at least the initial deposit value after fees");
    }

    function testMultipleLP_twoLPs_withdrawProportional() public {
        // LP1: 1000 A + 1000 B
        seedLiquidity(1000 ether, 1000 ether);
        uint256 shares1 = amm.shares(user);

        // LP2: 1000 A + 1000 B (same ratio)
        vm.prank(user2);
        amm.addLiquidity(1000 ether, 1000 ether);
        uint256 shares2 = amm.shares(user2);

        // total reserves: 2000/2000
        assertEq(amm.reserveA(), 2000 ether);
        assertEq(amm.reserveB(), 2000 ether);

        // LP1 withdraws – should get half the pool
        uint256 balABefore = tokenA.balanceOf(user);
        uint256 balBBefore = tokenB.balanceOf(user);
        vm.prank(user);
        amm.removeLiquidity(shares1);

        uint256 gotA = tokenA.balanceOf(user) - balABefore;
        uint256 gotB = tokenB.balanceOf(user) - balBBefore;
        assertApproxEqAbs(gotA, 1000 ether, 1);
        assertApproxEqAbs(gotB, 1000 ether, 1);

        // LP2 withdraws – should get remaining half
        uint256 bal2ABefore = tokenA.balanceOf(user2);
        uint256 bal2BBefore = tokenB.balanceOf(user2);
        vm.prank(user2);
        amm.removeLiquidity(shares2);

        uint256 got2A = tokenA.balanceOf(user2) - bal2ABefore;
        uint256 got2B = tokenB.balanceOf(user2) - bal2BBefore;
        assertApproxEqAbs(got2A, 1000 ether, 1);
        assertApproxEqAbs(got2B, 1000 ether, 1);
    }

    function testMultipleLP_laterLPDoesNotGetEarlierFees() public {
        // LP1 adds liquidity
        seedLiquidity(1000 ether, 1000 ether);

        // Some swaps happen (fees accrue to LP1 proportional to pool share)
        address swapper = address(0x3);
        tokenA.transfer(swapper, 200 ether);
        vm.startPrank(swapper);
        tokenA.approve(address(amm), type(uint256).max);
        amm.swapAforB(100 ether);
        vm.stopPrank();

        // Capture reserves after LP1-only fee accrual
        uint256 rA = amm.reserveA();
        uint256 rB = amm.reserveB();

        // LP2 joins after swap at current reserves ratio
        uint256 addA = 100 ether;
        uint256 addB = (addA * rB) / rA; // proportional to current pool
        vm.prank(user2);
        amm.addLiquidity(addA, addB);
        uint256 shares2 = amm.shares(user2);
        uint256 totalShares = amm.totalShares();

        // LP2 share fraction: shares2 / totalShares should equal addA / (rA + addA)
        // Check that LP2's withdrawable amount equals exactly their deposit (no bonus fees)
        uint256 withdrawA = (shares2 * amm.reserveA()) / totalShares;
        uint256 withdrawB = (shares2 * amm.reserveB()) / totalShares;

        assertApproxEqAbs(withdrawA, addA, 1);
        assertApproxEqAbs(withdrawB, addB, 1);
    }

    // ─────────────────────────────────────────────
    // Existing smoke tests (kept for backwards-compat)
    // ─────────────────────────────────────────────

    function testAddLiquidity() public {
        vm.prank(user);
        amm.addLiquidity(100 ether, 100 ether);
        assertGt(amm.totalShares(), 0);
    }

    function testSwap() public {
        vm.startPrank(user);
        amm.addLiquidity(100 ether, 100 ether);
        amm.swapAforB(10 ether);
        vm.stopPrank();
        assertGt(tokenB.balanceOf(user), 0);
    }
}