pragma solidity ^0.5.0;

import "./SafeMath.sol";

contract erc20TokenInterface {

	function name() public view returns (string memory);
	function symbol() public view returns (string memory);
	function totalSupply() public view returns (uint);
	function decimals() public view returns (uint);
	function getBalance(address _owner) public view returns (uint);
	function transfer(address _to, uint _amount) public returns (bool success);
	function transferFrom(address _owner, address _to, uint _amount) public returns (bool success);
	function _approve(address _owner, address _spender, uint _amount) internal;
	function increaseAllowance(address _spender, uint256 addedValue) public returns (bool);
	function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool);
	function _mint(address account, uint256 value) internal;
	function _burn(address account, uint256 value) internal;
	function _burnFrom(address account, uint256 value) internal;
	event Transfer(address indexed _from, address indexed _to, uint amount);
	event Approval(address indexed _spender, address indexed _to, uint amount);

  }

  contract ERC20Token is erc20TokenInterface {
      
    using SafeMath for uint256;
    
    // EVENTS ----------------------------------------------------------------------------------------
  	event Transfer(address indexed _from, address indexed _to, uint amount);
	event Approval(address indexed _spender, address indexed _to, uint amount);
    
    // STATE VARIABLES -------------------------------------------------------------------------------
  	uint constant private MAX_UINT256 = 2**256 - 1;
  	uint _totalSupply = 21000000;
  	uint _decimals = 10;
  	string _name;
  	string _symbol;
  	address public owner;
    
    // DATA STRUCTURES -------------------------------------------------------------------------------
  	mapping (address => uint) public balances;
  	mapping (address => mapping (address => uint)) public allowances;
    
    // CONSTRUCTOR FUNCTION --------------------------------------------------------------------------
  	constructor () public {
  		_totalSupply = 21000000;
  		_decimals = 8;
  		_name = "A Very High Token";
  		_symbol = "HIGH";
  		owner = msg.sender;
  		balances[owner] =  _totalSupply;
  		emit Transfer(address(0), msg.sender, _totalSupply);
  	}

    // GETTER FUNCTIONS -----------------------------------------------------------------------------
  	function name() public view returns (string memory) {
  		return _name;
  	}
	function symbol() public view returns (string memory) {
		return _symbol;
	}
	function totalSupply() public view returns (uint) {
		return _totalSupply;
	}
	function decimals() public view returns (uint) {
		return _decimals;
	}
	function getBalance(address _owner) public view returns (uint) {
		return balances[_owner];
	}
	
	function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowances[_owner][_spender];
    }
    
    // PUBLIC FUNCTIONS -----------------------------------------------------------------------------
	function transfer(address _to, uint _amount) public returns (bool success) {
	    require (balances[msg.sender] >= _amount);
	    balances[msg.sender] = balances[msg.sender].sub(_amount);
	    balances[_to] = balances[_to].add(_amount);
	    require (balances[_to] >= _amount);
	    emit Transfer(msg.sender, _to, _amount);
	    return success;
	    
	}
	
	function transferFrom(address _owner, address _to, uint _amount) public returns (bool success) {
	    require (allowances[_owner][msg.sender] >= _amount);
	    require (balances[_owner] > _amount);
	    allowances[_owner][msg.sender] = allowances[_owner][msg.sender].sub(_amount);
	    balances[_owner] = balances[_owner].sub(_amount); 
	    balances[_to] = balances[_to].add(_amount);
	    emit Transfer(_owner, _to, _amount);
	    return success;
	}
	
    // function approve(address _spender, uint _amount) public returns (uint, bool success) {
    //    allowances[_spender][msg.sender] = allowances[_spender][msg.sender].add(_amount);
 	//    return (_amount, success);
	// }
	
	function increaseAllowance(address _spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, _spender, allowances[msg.sender][_spender].add(addedValue));
        return true;
    }
    
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(allowances[msg.sender][spender] >= subtractedValue);
        allowances[msg.sender][spender] = allowances[msg.sender][spender].sub(subtractedValue);
        return true;
    }
    
    // INTERNAL FUNCTIONS ----------------------------------------------------------------------------
    function _approve(address _owner, address _spender, uint256 value) internal  {
        require(_spender != address(0));
        require(_owner != address(0));
        allowances[_owner][_spender] = allowances[msg.sender][_spender].add(value);
        emit Approval(_owner, _spender, value);
    }
    
    function _mint(address account, uint256 value) internal {
        require(account != address(0));
        _totalSupply = _totalSupply.add(value);
        balances[account] = balances[account].add(value);
        emit Transfer(address(0), account, value);
    }
    
    function _burn(address account, uint256 value) internal {
        require(account != address(0));
        _totalSupply = _totalSupply.sub(value);
        balances[account] = balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }
    
    function _burnFrom(address account, uint256 value) internal {
        _burn(account, value);
        _approve(account, msg.sender, allowances[account][msg.sender].sub(value));
    }

  }