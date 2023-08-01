/**
 *Submitted for verification at Etherscan.io on 2019-03-06
*/

pragma solidity ^0.5.0;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint a, uint b) internal pure returns (uint) {
    if (a == 0) {
      return 0;
    }
    uint c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint a, uint b) internal pure returns (uint) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  // @custom:consol { sub(a, b) returns (c) requires { b <= a } }
  function sub(uint a, uint b) internal pure returns (uint) {
    _subPre(a, b);
    uint c = sub_original(a, b);
    _subPost(a, b, c);
    return c;
  }
  function _subPre(uint a, uint b) internal pure {
    require(b <= a);
  }
  function _subPost(uint a, uint b, uint c) internal pure {
  }
  function sub_original(uint a, uint b) private pure returns (uint) {
    return a - b;
  }

  // @custom:consol { add(a, b) returns (c) ensures { c >= a } }
  function add(uint a, uint b) internal pure returns (uint) {
    _addPre(a, b);
    uint c = add_original(a, b);
    _addPost(a, b, c);
    return c;
  }
  function _addPre(uint a, uint b) internal pure {
  }
  function _addPost(uint a, uint b, uint c) internal pure {
    require(c >= a);
  }
  function add_original(uint a, uint b) private pure returns (uint) {
    uint c = a + b;
    return c;
  }
}

contract ERC20 {

    function totalSupply() public view returns (uint supply);
    
    function balanceOf(address _owner) public view returns (uint balance);
    
    function transfer(address _to, uint _value) public returns (bool success);
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    
    function approve(address _spender, uint _value) public returns (bool success);
    
    function allowance(address _owner, address _spender) public view returns (uint remaining);

    event Transfer(address indexed _from, address indexed _to, uint _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


contract StandardToken is ERC20 {

    using SafeMath for uint;

    uint public _totalSupply;

    mapping (address => uint) balances;
    
    mapping (address => mapping (address => uint)) allowed;

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        require(balances[msg.sender] >= _value && _value > 0);
        
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
        
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        
        return true;
    }

    function approve(address _spender, uint _value) public returns (bool success) {
        // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
            revert();
        }
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return allowed[_owner][_spender];
    }

}

contract Controlled {

    address public controller;

    constructor() public {
        controller = msg.sender;
    }

    function changeController(address _newController) public only_controller {
        controller = _newController;
    }
    
    function getController() view public returns (address) {
        return controller;
    }

    modifier only_controller { 
        require(msg.sender == controller);
        _; 
    }

}


contract ThetaToken is StandardToken, Controlled {
    
    using SafeMath for uint;

    string public constant name = "Theta Token";

    string public constant symbol = "THETA";

    uint8 public constant decimals = 18;

    // tokens can be transferred amoung holders only after unlockTime
    
    // for token circulation on platforms that integrate Theta before unlockTime
    mapping (address => bool) internal precirculated;

    constructor() public {
        _totalSupply = 10000000000000000;
        balances[msg.sender] = _totalSupply;
    }

    // @custom:consol { transfer(_to, _value) returns (b) requires {balances[msg.sender] >= _value && _value > 0 } }
    function transfer(address _to, uint _value) public returns (bool success) {
	_transferPre(_to, _value);
	bool b = transfer_original(_to, _value);
	_transferPost(_to, _value, b);
	return b;
    }
    function _transferPre(address _to, uint _value) internal view {
	require(balances[msg.sender] >= _value && _value > 0);
    }
    function _transferPost(address _to, uint _value, bool b) internal view {
    }
    function transfer_original(address _to, uint _value) private returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }

    function transferFrom(address _from, address _to, uint _amount) can_transfer(_from, _to) public returns (bool success) {
        return super.transferFrom(_from, _to, _amount);
    }

    function mint(address _owner, uint _amount) external only_controller returns (bool) {
        _totalSupply = _totalSupply.add(_amount);
        balances[_owner] = balances[_owner].add(_amount);

        emit Transfer(address(0), _owner, _amount);
        return true;
    }

    function allowPrecirculation(address _addr) only_controller public {
        precirculated[_addr] = true;
    }

    function disallowPrecirculation(address _addr) only_controller public {
        precirculated[_addr] = false;
    }

    function isPrecirculationAllowed(address _addr) view public returns(bool) {
        return precirculated[_addr];
    }

    modifier can_transfer(address _from, address _to) {
        require((isPrecirculationAllowed(_from) && isPrecirculationAllowed(_to)));
        _;
    }

}