// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiSigWallet {

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 confirmations;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public required;

    Transaction[] public transactions;

    mapping(uint256 => mapping(address => bool)) public confirmed;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    modifier txExists(uint256 txId) {
        require(txId < transactions.length, "Tx does not exist");
        _;
    }

    modifier notExecuted(uint256 txId) {
        require(!transactions[txId].executed, "Already executed");
        _;
    }

    modifier notConfirmed(uint256 txId) {
        require(!confirmed[txId][msg.sender], "Already confirmed");
        _;
    }

    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint256 indexed txId);
    event Confirm(address indexed owner, uint256 indexed txId);
    event Execute(uint256 indexed txId);

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "Owners required");
        require(
            _required > 0 && _required <= _owners.length,
            "Invalid confirmations"
        );

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Zero address");
            require(!isOwner[owner], "Duplicate owner");

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submit(
        address to,
        uint256 value,
        bytes memory data
    ) external onlyOwner {

        transactions.push(
            Transaction({
                to: to,
                value: value,
                data: data,
                executed: false,
                confirmations: 0
            })
        );

        emit Submit(transactions.length - 1);
    }

    function confirm(uint256 txId)
        external
        onlyOwner
        txExists(txId)
        notExecuted(txId)
        notConfirmed(txId)
    {
        confirmed[txId][msg.sender] = true;
        transactions[txId].confirmations += 1;

        emit Confirm(msg.sender, txId);
    }

    function execute(uint256 txId)
        external
        txExists(txId)
        notExecuted(txId)
    {
        Transaction storage transaction = transactions[txId];

        require(
            transaction.confirmations >= required,
            "Not enough confirmations"
        );

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );

        require(success, "Tx failed");

        emit Execute(txId);
    }

    function getOwners() external view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() external view returns (uint256) {
        return transactions.length;
    }
}