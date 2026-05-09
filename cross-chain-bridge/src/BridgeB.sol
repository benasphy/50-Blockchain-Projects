// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./WrappedToken.sol";

contract BridgeB {
    WrappedToken public wrapped;

    address public relayer;

    mapping(uint256 => bool) public processedNonces;

    event Minted(
        address indexed user,
        uint256 amount,
        uint256 nonce
    );

    constructor(address _wrapped) {
        wrapped = WrappedToken(_wrapped);
        relayer = msg.sender;
    }

    function mint(
        address user,
        uint256 amount,
        uint256 nonce
    ) external {
        require(msg.sender == relayer, "not relayer");
        require(!processedNonces[nonce], "already processed");

        processedNonces[nonce] = true;

        wrapped.mint(user, amount);

        emit Minted(user, amount, nonce);
    }
}