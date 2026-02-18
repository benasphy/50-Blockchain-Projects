// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GasOptimizationDemo.sol";

contract GasOptimizationDemoTest is Test {
    GasOptimizationDemo demo;

    function setUp() public {
        demo = new GasOptimizationDemo();
    }

    function testUpdateUserGas() public {
        demo.updateUserBad();
        demo.updateUserGood();
    }

    function testIncrementGas() public {
        demo.incrementBad();
        demo.incrementGood();
    }

    function testSumGas() public {
        uint256;
        numbers[0] = 1;
        numbers[1] = 2;
        numbers[2] = 3;

        demo.sumMemory(numbers);
        demo.sumCalldata(numbers);
    }
}
