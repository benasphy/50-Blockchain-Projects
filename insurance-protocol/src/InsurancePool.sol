// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

contract InsurancePool {
    Token public token;

    uint256 public totalLiquidity;

    uint256 public totalShares;

    uint256 public nextPolicyId;

    // -----------------------------------
    // LP SHARES
    // -----------------------------------

    mapping(address => uint256) public shares;

    // -----------------------------------
    // POLICY
    // -----------------------------------

    struct Policy {
        uint256 id;

        address holder;

        uint256 coverageAmount;

        uint256 premiumPaid;

        uint256 expiration;

        bool active;

        bool claimed;
    }

    mapping(uint256 => Policy) public policies;

    constructor(address _token) {
        token = Token(_token);
    }

    // -----------------------------------
    // LP DEPOSIT
    // -----------------------------------

    function provideLiquidity(
        uint256 amount
    ) external {
        token.transferFrom(
            msg.sender,
            address(this),
            amount
        );

        uint256 mintedShares;

        if (totalShares == 0) {
            mintedShares = amount;
        } else {
            mintedShares =
                (amount * totalShares) /
                totalLiquidity;
        }

        shares[msg.sender] += mintedShares;

        totalShares += mintedShares;

        totalLiquidity += amount;
    }

    // -----------------------------------
    // LP WITHDRAW
    // -----------------------------------

    function withdrawLiquidity(
        uint256 shareAmount
    ) external {
        require(
            shares[msg.sender] >= shareAmount,
            "not enough shares"
        );

        uint256 assets =
            (shareAmount * totalLiquidity) /
            totalShares;

        shares[msg.sender] -= shareAmount;

        totalShares -= shareAmount;

        totalLiquidity -= assets;

        token.transfer(msg.sender, assets);
    }

    // -----------------------------------
    // BUY INSURANCE
    // -----------------------------------

    function buyPolicy(
        uint256 coverageAmount,
        uint256 duration
    ) external {
        require(
            coverageAmount <= totalLiquidity,
            "insufficient pool"
        );

        // simple premium:
        // 5% of coverage
        uint256 premium =
            coverageAmount * 5 / 100;

        token.transferFrom(
            msg.sender,
            address(this),
            premium
        );

        totalLiquidity += premium;

        policies[nextPolicyId] = Policy({
            id: nextPolicyId,
            holder: msg.sender,
            coverageAmount: coverageAmount,
            premiumPaid: premium,
            expiration:
                block.timestamp + duration,
            active: true,
            claimed: false
        });

        nextPolicyId++;
    }

    // -----------------------------------
    // CLAIM
    // -----------------------------------

    function submitClaim(
        uint256 policyId
    ) external {
        Policy storage p =
            policies[policyId];

        require(
            msg.sender == p.holder,
            "not holder"
        );

        require(p.active, "inactive");

        require(!p.claimed, "claimed");

        require(
            block.timestamp <
                p.expiration,
            "expired"
        );

        require(
            totalLiquidity >=
                p.coverageAmount,
            "pool insolvent"
        );

        p.claimed = true;

        p.active = false;

        totalLiquidity -=
            p.coverageAmount;

        token.transfer(
            p.holder,
            p.coverageAmount
        );
    }

    // -----------------------------------
    // VIEWS
    // -----------------------------------

    function sharePrice()
        external
        view
        returns (uint256)
    {
        if (totalShares == 0) {
            return 1e18;
        }

        return
            (totalLiquidity * 1e18) /
            totalShares;
    }
}