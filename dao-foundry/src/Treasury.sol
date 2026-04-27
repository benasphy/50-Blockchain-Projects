// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Treasury {
    address public dao;

    constructor(address _dao) {
        dao = _dao;
    }

    receive() external payable {}

    function execute(
        address target,
        uint256 value,
        bytes calldata data
    ) external returns (bytes memory) {
        require(msg.sender == dao, "only DAO");

        (bool success, bytes memory result) = target.call{value: value}(data);
        require(success, "tx failed");

        return result;
    }
}