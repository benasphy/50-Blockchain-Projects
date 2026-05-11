// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";
import "./Strategy.sol";

contract Vault {
    Token public token;

    Strategy public strategy;

    uint256 public totalShares;

    mapping(address => uint256) public shares;

    constructor(
        address _token,
        address _strategy
    ) {
        token = Token(_token);
        strategy = Strategy(_strategy);
    }

    // total vault value
    function totalAssets()
        public
        view
        returns (uint256)
    {
        return strategy.totalManaged();
    }

    // -----------------------------------
    // DEPOSIT
    // -----------------------------------

    function deposit(uint256 amount) external {
        uint256 assets = totalAssets();

        token.transferFrom(
            msg.sender,
            address(strategy),
            amount
        );

        strategy.deposit(amount);

        uint256 mintedShares;

        if (totalShares == 0) {
            mintedShares = amount;
        } else {
            mintedShares =
                (amount * totalShares) /
                assets;
        }

        shares[msg.sender] += mintedShares;

        totalShares += mintedShares;
    }

    // -----------------------------------
    // WITHDRAW
    // -----------------------------------

    function withdraw(uint256 shareAmount)
        external
    {
        require(
            shares[msg.sender] >= shareAmount,
            "not enough shares"
        );

        uint256 assets =
            (shareAmount * totalAssets()) /
            totalShares;

        shares[msg.sender] -= shareAmount;

        totalShares -= shareAmount;

        strategy.withdraw(assets);

        token.transfer(msg.sender, assets);
    }

    // share price
    function sharePrice()
        external
        view
        returns (uint256)
    {
        if (totalShares == 0) {
            return 1e18;
        }

        return
            (totalAssets() * 1e18) /
            totalShares;
    }
}