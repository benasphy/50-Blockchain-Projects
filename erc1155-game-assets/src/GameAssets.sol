// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GameAssets {

    mapping(uint256 => mapping(address => uint256)) private _balances;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    string public uri;
    address public owner;

    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(string memory _uri) {
        uri = _uri;
        owner = msg.sender;
    }

    // ---------------- Balance ----------------

    function balanceOf(address account, uint256 id)
        public
        view
        returns (uint256)
    {
        require(account != address(0), "Zero address");
        return _balances[id][account];
    }

    function balanceOfBatch(
        address[] memory accounts,
        uint256[] memory ids
    )
        external
        view
        returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "Length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; i++) {
            batchBalances[i] = _balances[ids[i]][accounts[i]];
        }

        return batchBalances;
    }

    // ---------------- Approvals ----------------

    function setApprovalForAll(address operator, bool approved) external {
        _operatorApprovals[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address account, address operator)
        public
        view
        returns (bool)
    {
        return _operatorApprovals[account][operator];
    }

    // ---------------- Transfers ----------------

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount
    )
        public
    {
        require(
            msg.sender == from ||
            isApprovedForAll(from, msg.sender),
            "Not authorized"
        );

        require(to != address(0), "Zero address");

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "Insufficient");

        _balances[id][from] = fromBalance - amount;
        _balances[id][to] += amount;

        emit TransferSingle(msg.sender, from, to, id, amount);
    }

    // ---------------- Batch Transfer ----------------

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
    )
        public
    {
        require(ids.length == amounts.length, "Length mismatch");

        require(
            msg.sender == from ||
            isApprovedForAll(from, msg.sender),
            "Not authorized"
        );

        require(to != address(0), "Zero address");

        for (uint256 i = 0; i < ids.length; i++) {

            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "Insufficient");

            _balances[id][from] = fromBalance - amount;
            _balances[id][to] += amount;
        }

        emit TransferBatch(msg.sender, from, to, ids, amounts);
    }

    // ---------------- Minting ----------------

    function mint(
        address to,
        uint256 id,
        uint256 amount
    )
        external
        onlyOwner
    {
        require(to != address(0), "Zero address");

        _balances[id][to] += amount;

        emit TransferSingle(msg.sender, address(0), to, id, amount);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts
    )
        external
        onlyOwner
    {
        require(ids.length == amounts.length, "Length mismatch");

        for (uint256 i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] += amounts[i];
        }

        emit TransferBatch(msg.sender, address(0), to, ids, amounts);
    }
}