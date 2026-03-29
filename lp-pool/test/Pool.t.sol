// test/Pool.t.sol
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Token.sol";
import "../src/LiquidityPool.sol";

contract PoolTest is Test {

    Token tokenA;
    Token tokenB;
    LiquidityPool pool;

    address user = address(1);

    function setUp() public {

        tokenA = new Token("A", "A", 1_000_000 ether);
        tokenB = new Token("B", "B", 1_000_000 ether);

        pool = new LiquidityPool(address(tokenA), address(tokenB));

        tokenA.transfer(user, 1000 ether);
        tokenB.transfer(user, 1000 ether);

        vm.startPrank(user);
        tokenA.approve(address(pool), type(uint256).max);
        tokenB.approve(address(pool), type(uint256).max);
        vm.stopPrank();
    }

    function testAddLiquidity() public {

        vm.prank(user);
        pool.addLiquidity(100 ether, 100 ether);
    }

    function testSwap() public {

        vm.startPrank(user);
        pool.addLiquidity(100 ether, 100 ether);

        pool.swap(address(tokenA), 10 ether);
        vm.stopPrank();
    }

    function testRemoveLiquidity() public {

        vm.startPrank(user);
        pool.addLiquidity(100 ether, 100 ether);

        uint256 lpBalance = pool.lpToken().balanceOf(user);

        pool.removeLiquidity(lpBalance);
        vm.stopPrank();
    }
}