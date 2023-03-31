// SPDX-License-Identifier: XXX

pragma solidity >=0.8.10;

import "./interfaces/IERC20.sol";
import "./libraries/SafeMath.sol";


contract FabioToken is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;
    uint256 private _maxBalance;
    string private _name;
    uint8 private _decimals;
    string private _symbol;
    address private _owner;

    constructor () {
        _name = "Fabio Token";
        _symbol = "FABIO";
        _decimals = 5;
        _totalSupply = 10**13;
        _balances[msg.sender] = _totalSupply;
        _owner = msg.sender;

        emit Transfer(address(0), msg.sender , _totalSupply);
    }

    function totalSupply() external override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public override view returns (uint256) {
        return _balances[owner];
    }

    function allowance(address owner, address spender) public override view returns (uint256) {
        return _allowed[owner][spender];
    }


    function transfer(address to, uint256 value) public override returns (bool) {
        require(value <= _balances[msg.sender]);
        require(to != address(0));

        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public override returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function changeTokenName(string memory newName) public returns (bool) {
        // Check if the sender is the token holder with the highest balance
        //require(_balances[msg.sender] > 10000, "Only a token holder who owns more than 10000 tokens can change the name");
        
        //If the sender has more than 10'000 tokens, continue
        _name = newName;
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }


    function name() public view returns (string memory) {
    return _name;
    }

    function symbol() public view returns (string memory) {
    return _symbol;
    }

    function decimals() public view returns (uint8) {
    return _decimals;
    }
}