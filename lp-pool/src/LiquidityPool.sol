// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address user) external view returns (uint256);
}

interface ILPToken {
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;
    function totalSupply() external view returns (uint256);
}

contract LiquidityPool {

    IERC20 public tokenA;
    IERC20 public tokenB;
    ILPToken public lpToken;

    uint256 public reserveA;
    uint256 public reserveB;

    uint256 constant FEE = 3; // 0.3%
    uint256 constant DENOM = 1000;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        lpToken = ILPToken(address(new LPToken()));
    }

    // ---------------- Add Liquidity ----------------

    function addLiquidity(uint256 amountA, uint256 amountB) external {

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        uint256 liquidity;

        if (lpToken.totalSupply() == 0) {
            liquidity = sqrt(amountA * amountB);
        } else {
            liquidity = min(
                (amountA * lpToken.totalSupply()) / reserveA,
                (amountB * lpToken.totalSupply()) / reserveB
            );
        }

        require(liquidity > 0, "Zero liquidity");

        lpToken.mint(msg.sender, liquidity);

        reserveA += amountA;
        reserveB += amountB;
    }

    // ---------------- Remove Liquidity ----------------

    function removeLiquidity(uint256 liquidity) external {

        uint256 totalSupply = lpToken.totalSupply();

        uint256 amountA = (liquidity * reserveA) / totalSupply;
        uint256 amountB = (liquidity * reserveB) / totalSupply;

        lpToken.burn(msg.sender, liquidity);

        reserveA -= amountA;
        reserveB -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);
    }

    // ---------------- Swap ----------------

    function swap(address tokenIn, uint256 amountIn) external {

        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "Invalid token");

        bool isA = tokenIn == address(tokenA);

        (IERC20 inToken, IERC20 outToken, uint256 reserveIn, uint256 reserveOut) =
            isA
                ? (tokenA, tokenB, reserveA, reserveB)
                : (tokenB, tokenA, reserveB, reserveA);

        inToken.transferFrom(msg.sender, address(this), amountIn);

        uint256 amountInWithFee = (amountIn * (DENOM - FEE)) / DENOM;

        uint256 amountOut =
            (reserveOut * amountInWithFee) /
            (reserveIn + amountInWithFee);

        outToken.transfer(msg.sender, amountOut);

        if (isA) {
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            reserveB += amountIn;
            reserveA -= amountOut;
        }
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