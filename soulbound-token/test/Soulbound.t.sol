// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SoulboundToken {

    string public name = "SoulboundToken";
    string public symbol = "SBT";

    uint256 public totalSupply;
    address public issuer;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Revoked(uint256 indexed tokenId);

    error NotIssuer();
    error NotOwner();
    error NonTransferable();

    constructor() {
        issuer = msg.sender;
    }

    modifier onlyIssuer() {
        if (msg.sender != issuer) revert NotIssuer();
        _;
    }

    // ---------------- View Functions ----------------

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Not minted");
        return owner;
    }

    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "Zero address");
        return _balances[owner];
    }

    // ---------------- Minting ----------------

    function mint(address to) external onlyIssuer returns (uint256) {
        require(to != address(0), "Zero address");

        uint256 tokenId = ++totalSupply;

        _owners[tokenId] = to;
        _balances[to]++;

        emit Transfer(address(0), to, tokenId);

        return tokenId;
    }

    // ---------------- Revocation (Optional) ----------------

    function revoke(uint256 tokenId) external onlyIssuer {
        address owner = ownerOf(tokenId);

        _balances[owner]--;
        delete _owners[tokenId];

        emit Revoked(tokenId);
        emit Transfer(owner, address(0), tokenId);
    }

    // ---------------- Disabled Transfers ----------------

    function transferFrom(
        address,
        address,
        uint256
    ) external pure {
        revert NonTransferable();
    }

    function approve(address, uint256) external pure {
        revert NonTransferable();
    }

    function setApprovalForAll(address, bool) external pure {
        revert NonTransferable();
    }

    function getApproved(uint256) external pure returns (address) {
        return address(0);
    }

    function isApprovedForAll(address, address) external pure returns (bool) {
        return false;
    }
}