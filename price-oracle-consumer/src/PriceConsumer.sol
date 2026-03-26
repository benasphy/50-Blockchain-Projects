// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Minimal Chainlink Aggregator Interface
interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256 answer,
            uint256,
            uint256,
            uint80
        );

    function decimals() external view returns (uint8);
}

contract PriceConsumer {

    AggregatorV3Interface public priceFeed;

    constructor(address _feed) {
        priceFeed = AggregatorV3Interface(_feed);
    }

    // ---------------- Get Latest Price ----------------

    function getLatestPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    // ---------------- Normalize Price to 18 Decimals ----------------

    function getPrice18Decimals() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();

        uint8 decimals = priceFeed.decimals();

        return uint256(price) * (10 ** (18 - decimals));
    }

    // ---------------- Example Use Case ----------------
    // Convert ETH amount to USD

    function convertETHtoUSD(uint256 ethAmount)
        external
        view
        returns (uint256)
    {
        uint256 price = getPrice18Decimals();

        return (ethAmount * price) / 1e18;
    }
}