// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FaucetToken {
    // ----------------------------
    // METADATA
    // ----------------------------

    string public name = "FaucetToken";
    string public symbol = "FCT";
    uint8 public immutable decimals = 18;

    uint256 public totalSupply;

    // ----------------------------
    // STORAGE
    // ----------------------------

    mapping(address => uint256) private balances;

    mapping(address => mapping(address => uint256)) private allowances;

    address public faucet;

    // ----------------------------
    // EVENTS
    // ----------------------------

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // ----------------------------
    // CONSTRUCTOR
    // ----------------------------

    constructor() {
        faucet = msg.sender; // temporary until faucet contract sets itself
    }

    // ----------------------------
    // MODIFIER
    // ----------------------------

    modifier onlyFaucet() {
        require(msg.sender == faucet, "Not faucet");
        _;
    }

    // ----------------------------
    // FAUCET SETTER
    // ----------------------------

    function setFaucet(address _faucet) external {
        require(msg.sender == faucet, "Only current faucet");
        faucet = _faucet;
    }

    // ----------------------------
    // ERC20 FUNCTIONS
    // ----------------------------

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return allowances[owner][spender];
    }

    function transferFrom(address from, address to, uint256 amount)
        external
        returns (bool)
    {
        uint256 allowed = allowances[from][msg.sender];
        require(allowed >= amount, "Not allowed");

        allowances[from][msg.sender] = allowed - amount;
        _transfer(from, to, amount);
        return true;
    }

    // ----------------------------
    // MINTING (FAUCET ONLY)
    // ----------------------------

    function mint(address to, uint256 amount) external onlyFaucet {
        require(to != address(0), "Zero address");

        totalSupply += amount;
        balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    // ----------------------------
    // INTERNAL
    // ----------------------------

    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "Zero address");
        require(balances[from] >= amount, "Insufficient");

        balances[from] -= amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
    }
}