// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MockNFT.sol";
import "./FractionToken.sol";

contract FractionVault {
    MockNFT public nft;

    FractionToken public fractionToken;

    uint256 public tokenId;

    bool public initialized;

    bool public redeemed;

    constructor(address _nft) {
        nft = MockNFT(_nft);
    }

    // -----------------------------------
    // FRACTIONALIZE NFT
    // -----------------------------------

    function fractionalize(
        uint256 _tokenId,
        uint256 fractions,
        string memory name,
        string memory symbol
    ) external {
        require(!initialized);

        tokenId = _tokenId;

        nft.transferFrom(
            msg.sender,
            address(this),
            tokenId
        );

        fractionToken =
            new FractionToken(
                name,
                symbol
            );

        fractionToken.mint(
            msg.sender,
            fractions
        );

        initialized = true;
    }

    // -----------------------------------
    // REDEEM NFT
    // Must own 100% fractions
    // -----------------------------------

    function redeem()
        external
    {
        require(initialized);

        require(!redeemed);

        uint256 total =
            fractionToken.totalSupply();

        require(
            fractionToken.balanceOf(
                msg.sender
            ) == total,
            "need all fractions"
        );

        redeemed = true;

        fractionToken.burn(
            msg.sender,
            total
        );

        nft.transferFrom(
            address(this),
            msg.sender,
            tokenId
        );
    }

    // helper
    function fractionalTokenAddress()
        external
        view
        returns (address)
    {
        return address(
            fractionToken
        );
    }
}