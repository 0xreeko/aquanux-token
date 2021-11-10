// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

abstract contract ERC20Standard {
function name() virtual public view returns (string memory);
function symbol() virtual public view returns (string memory);
function decimals() virtual public view returns (uint);
function totalSupply() virtual public view returns (uint);
function balanceOf(address _owner) virtual public view returns (uint balance);
function transfer(address _to, uint _value) virtual public returns (bool success);
function transferFrom(address _from, address _to, uint _value) virtual public returns (bool success);
function approve(address _spender, uint _value) virtual public returns (bool success);
function allowance(address _owner, address _spender) virtual public view returns (uint remaining);

event Transfer(address indexed _from, address indexed _to, uint _value);
event Approval(address indexed _owner, address indexed _spender, uint _value);

}

// this contract allows one to accept the transfer of adminship for a token.
contract Owned {
    address public admin;
    address public newAdmin;
    event adminTransferred(address indexed _from, address indexed _to);
    
    constructor() {
        admin = msg.sender;
    }
    
    function adminTransfer(address _to) public {
        require(admin == msg.sender);
        newAdmin = _to;
    }
    
    function acceptAdminship() public {
        require(msg.sender == newAdmin);
        emit adminTransferred(admin, newAdmin);
        admin = newAdmin;
        newAdmin = address(0);
    }
}

// inhereting
contract Aquanux is ERC20Standard {
    string public _symbol;
    string public _name;
    uint public _decimals;
    uint public _totalSupply;
    address public _minter;
    
    mapping(address => uint) balances;
    
    constructor() {
        _symbol = 'AQT';
        _name = "Aquanux Token";
        _decimals = 18;
        _totalSupply = 1000000;
        _minter = msg.sender;
        
        balances[_minter] += _totalSupply;
        emit Transfer(address(0), _minter, _totalSupply);
    }
    
    function name() public override view returns (string memory) {
        return _name;
    }
    function symbol() public override view returns (string memory) {
        return _symbol;
    }
    function decimals() public override view returns (uint) {
        return _decimals;
    }
    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address _owner) public override view returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transferFrom(address _from, address _to, uint _value) virtual public override returns (bool success) {
        require(balances[_from] >= _value);
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function transfer(address _to, uint _value) virtual public override returns (bool success) {
        return transferFrom(msg.sender, _to, _value);
    }
    function approve(address _spender, uint _value) virtual public override returns (bool success) {
        return true;
    }
    function allowance(address _owner, address _spender) virtual public override view returns (uint remaining) {
        return 0;
    }
    
    function mint(uint _amount) public returns (bool) {
        require(msg.sender == _minter);
        balances[_minter] += _amount;
        _totalSupply += _amount;
        return true;
    }

