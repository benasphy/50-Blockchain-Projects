// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockAggregator {

    int256 public price = 2000e8; // $2000 with 8 decimals

    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (0, price, 0, 0, 0);
    }

    function decimals() external pure returns (uint8) {
        return 8;
    }
}