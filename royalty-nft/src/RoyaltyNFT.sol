// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC2981 {
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount);
}

contract RoyaltyNFT is IERC2981 {

    string public name = "RoyaltyNFT";
    string public symbol = "RNFT";

    uint256 public totalSupply;

    struct RoyaltyData {
        address creator;
        uint96 royaltyBps;
    }

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;

    mapping(uint256 => RoyaltyData) private _royalties;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    // ---------------- Ownership ----------------

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Not minted");
        return owner;
    }

    function balanceOf(address owner) external view returns (uint256) {
        return _balances[owner];
    }

    function approve(address to, uint256 tokenId) external {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "Not owner");

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) external view returns (address) {
        return _tokenApprovals[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(ownerOf(tokenId) == from, "Not owner");
        require(
            msg.sender == from || _tokenApprovals[tokenId] == msg.sender,
            "Not approved"
        );

        _balances[from]--;
        _balances[to]++;
        _owners[tokenId] = to;

        delete _tokenApprovals[tokenId];

        emit Transfer(from, to, tokenId);
    }

    // ---------------- Minting with Royalty ----------------

    function mint(address to, uint96 royaltyBps) external returns (uint256) {
        require(royaltyBps <= 1000, "Royalty too high"); // max 10%

        uint256 tokenId = ++totalSupply;

        _owners[tokenId] = to;
        _balances[to]++;

        _royalties[tokenId] = RoyaltyData({
            creator: to,
            royaltyBps: royaltyBps
        });

        emit Transfer(address(0), to, tokenId);
        return tokenId;
    }

    // ---------------- ERC2981 ----------------

    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        RoyaltyData memory data = _royalties[tokenId];

        require(data.creator != address(0), "No royalty");

        royaltyAmount = (salePrice * data.royaltyBps) / 10000;
        return (data.creator, royaltyAmount);
    }
}