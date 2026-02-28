// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC721Royalty {
    function transferFrom(address from, address to, uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount);
}

contract RoyaltyMarketplace {

    struct Listing {
        address seller;
        uint256 price;
    }

    IERC721Royalty public nft;

    mapping(uint256 => Listing) public listings;

    event Listed(uint256 tokenId, uint256 price);
    event Bought(uint256 tokenId, address buyer);

    constructor(address _nft) {
        nft = IERC721Royalty(_nft);
    }

    function list(uint256 tokenId, uint256 price) external {
        require(price > 0, "Price zero");
        require(nft.ownerOf(tokenId) == msg.sender, "Not owner");

        nft.transferFrom(msg.sender, address(this), tokenId);

        listings[tokenId] = Listing({
            seller: msg.sender,
            price: price
        });

        emit Listed(tokenId, price);
    }

    function buy(uint256 tokenId) external payable {

        Listing memory listing = listings[tokenId];
        require(listing.price > 0, "Not listed");
        require(msg.value == listing.price, "Wrong price");

        delete listings[tokenId];

        // Get royalty info
        (address creator, uint256 royaltyAmount) =
            nft.royaltyInfo(tokenId, msg.value);

        uint256 sellerAmount = msg.value - royaltyAmount;

        // Pay creator
        if (royaltyAmount > 0) {
            (bool royaltyPaid, ) = creator.call{value: royaltyAmount}("");
            require(royaltyPaid, "Royalty failed");
        }

        // Pay seller
        (bool sellerPaid, ) = listing.seller.call{value: sellerAmount}("");
        require(sellerPaid, "Seller payment failed");

        nft.transferFrom(address(this), msg.sender, tokenId);

        emit Bought(tokenId, msg.sender);
    }
}