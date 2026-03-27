// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address user) external view returns (uint256);
}

contract SimpleAMM {

    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    uint256 public totalShares;
    mapping(address => uint256) public shares;

    uint256 constant FEE = 3; // 0.3%
    uint256 constant FEE_DENOM = 1000;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // ---------------- Add Liquidity ----------------

    function addLiquidity(uint256 amountA, uint256 amountB) external {

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        uint256 share;

        if (totalShares == 0) {
            share = sqrt(amountA * amountB);
        } else {
            share = min(
                (amountA * totalShares) / reserveA,
                (amountB * totalShares) / reserveB
            );
        }

        require(share > 0, "Zero share");

        shares[msg.sender] += share;
        totalShares += share;

        reserveA += amountA;
        reserveB += amountB;
    }

    // ---------------- Remove Liquidity ----------------

    function removeLiquidity(uint256 share) external {

        require(shares[msg.sender] >= share, "Not enough shares");

        uint256 amountA = (share * reserveA) / totalShares;
        uint256 amountB = (share * reserveB) / totalShares;

        shares[msg.sender] -= share;
        totalShares -= share;

        reserveA -= amountA;
        reserveB -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
    }

    // ---------------- Swap ----------------

    function swapAforB(uint256 amountAIn) external {

        uint256 amountInWithFee =
            (amountAIn * (FEE_DENOM - FEE)) / FEE_DENOM;

        uint256 amountOut =
            (reserveB * amountInWithFee) /
            (reserveA + amountInWithFee);

        tokenA.transferFrom(msg.sender, address(this), amountAIn);
        tokenB.transfer(msg.sender, amountOut);

        reserveA += amountAIn;
        reserveB -= amountOut;
    }

    function swapBforA(uint256 amountBIn) external {

        uint256 amountInWithFee =
            (amountBIn * (FEE_DENOM - FEE)) / FEE_DENOM;

        uint256 amountOut =
            (reserveA * amountInWithFee) /
            (reserveB + amountInWithFee);

        tokenB.transferFrom(msg.sender, address(this), amountBIn);
        tokenA.transfer(msg.sender, amountOut);

        reserveB += amountBIn;
        reserveA -= amountOut;
    }

    // ---------------- Utils ----------------

    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x < y ? x : y;
    }

    function sqrt(uint256 y) internal pure returns (uint256 z) {
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
}