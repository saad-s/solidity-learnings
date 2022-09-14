// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

// token contract from scracth 
contract ERC20Token is IERC20 {
  address public owner;
  
  // token details 
  string public name;
  string public symbol;
  uint8 public decimals;
  
  uint public totalSupply;

  error lowBalanceError(string _errorMsg);

  // balance of an address 
  mapping(address => uint) public balanceOf;
  // amount allowed to spend on another address's behalf 
  mapping(address => mapping(address => uint)) public allowance;
  
  constructor (string memory _name, string memory _symbol, uint8 _decimals) {
    owner = msg.sender;
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    super;
  }

  modifier lowBalance(address sender, uint amount) {
    // require(balanceOf[sender] >= amount, "not enough tokens available");
    if (balanceOf[sender] < amount)
      revert lowBalanceError('not enough tokens available');
    _;
  }

  function transfer(address recipient, uint amount) external lowBalance(msg.sender ,amount) returns (bool) {
    balanceOf[msg.sender] -= amount;
    balanceOf[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount);
    return true;
  }

  function approve(address spender, uint amount) external lowBalance(msg.sender, amount) returns (bool) {
    allowance[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
    return true;
  }

  function transferFrom(address sender, address recipient, uint amount) external lowBalance(sender, amount) returns (bool) {
    // should cause over/underflow errors
    allowance[sender][msg.sender] -= amount;
    balanceOf[sender] -= amount;
    balanceOf[recipient] += amount;
    emit Transfer(sender, recipient, amount);
    return true;
  }

  function mint(address recipient, uint amount) external {
    require(msg.sender == owner, "only owner can mint new tokens");
    balanceOf[recipient] += amount;
    totalSupply += amount;
    emit Transfer(address(0), recipient, amount);
  }

  function burn(uint amount) external lowBalance(msg.sender, amount) {
    balanceOf[msg.sender] -= amount;
    totalSupply -= amount;
    emit Transfer(msg.sender, address(0), amount);
  }
}