// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyERC20 {
    // --------------------------------
    // METADATA
    // --------------------------------

    string public name;
    string public symbol;
    uint8 public immutable decimals;

    uint256 public totalSupply;

    // --------------------------------
    // STORAGE
    // --------------------------------

    mapping(address => uint256) private balances;

    mapping(address => mapping(address => uint256)) private allowances;

    // --------------------------------
    // EVENTS (MANDATORY)
    // --------------------------------

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // --------------------------------
    // CONSTRUCTOR
    // --------------------------------

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        _mint(msg.sender, _initialSupply);
    }

    // --------------------------------
    // VIEW FUNCTIONS
    // --------------------------------

    function balanceOf(address account)
        external
        view
        returns (uint256)
    {
        return balances[account];
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return allowances[owner][spender];
    }

    // --------------------------------
    // CORE FUNCTIONS
    // --------------------------------

    function transfer(address to, uint256 amount)
        external
        returns (bool)
    {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount)
        external
        returns (bool)
    {
        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        uint256 currentAllowance = allowances[from][msg.sender];

        require(currentAllowance >= amount, "ERC20: insufficient allowance");

        allowances[from][msg.sender] = currentAllowance - amount;

        emit Approval(from, msg.sender, allowances[from][msg.sender]);

        _transfer(from, to, amount);

        return true;
    }

    // --------------------------------
    // INTERNAL LOGIC
    // --------------------------------

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(to != address(0), "ERC20: transfer to zero");

        uint256 fromBalance = balances[from];
        require(fromBalance >= amount, "ERC20: insufficient balance");

        balances[from] = fromBalance - amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "ERC20: mint to zero");

        totalSupply += amount;
        balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }
}
