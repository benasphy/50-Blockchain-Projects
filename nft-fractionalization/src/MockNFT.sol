// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockNFT {
    string public name = "Rare NFT";
    string public symbol = "RNFT";

    uint256 public nextTokenId;

    mapping(uint256 => address) public ownerOf;

    mapping(uint256 => address) public approvals;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    function mint(address to)
        external
        returns (uint256)
    {
        uint256 tokenId = nextTokenId++;

        ownerOf[tokenId] = to;

        emit Transfer(
            address(0),
            to,
            tokenId
        );

        return tokenId;
    }

    function approve(
        address to,
        uint256 tokenId
    ) external {
        require(
            ownerOf[tokenId] ==
                msg.sender,
            "not owner"
        );

        approvals[tokenId] = to;
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {
        require(
            ownerOf[tokenId] == from,
            "not owner"
        );

        require(
            msg.sender == from ||
                approvals[tokenId] ==
                msg.sender,
            "not approved"
        );

        ownerOf[tokenId] = to;

        approvals[tokenId] = address(0);

        emit Transfer(
            from,
            to,
            tokenId
        );
    }
}