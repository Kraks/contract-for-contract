/**
 * Source Code first verified at https://etherscan.io on Friday, February 9, 2018
 (UTC) */

pragma solidity ^0.5.0;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  // @custom:consol { mul(a, b) returns (c) ensures { a == 0 || c / a == b } }
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    _mulPre(a, b);
    uint256 c = mul_original(a, b);
    _mulPost(a, b, c);
    return c;
  }
  function _mulPre(uint256 a, uint256 b) private pure {
  }
  function _mulPost(uint256 a, uint256 b, uint256 c) private pure {
    require(a == 0 || c / a == b);
  }
  function mul_original(uint256 a, uint256 b) private pure returns (uint256) {
    uint256 c = a * b;
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  // @custom:consol { sub(a, b) returns (c) requires { b <= a } }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    _subPre(a, b);
    uint256 c = sub_original(a, b);
    _subPost(a, b, c);
    return c;
  }
  function _subPre(uint256 a, uint256 b) private pure {
    require(b <= a);
  }
  function _subPost(uint256 a, uint256 b, uint256 c) private pure {
  }
  function sub_original(uint256 a, uint256 b) private pure returns (uint256) {
    return a - b;
  }

  // @custom:consol { add(a, b) returns (c) ensures { c >= a }
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    _addPre(a, b);
    uint256 c = add_original(a, b);
    _addPost(a, b, c);
    return c;
  }
  function _addPre(uint256 a, uint256 b) private pure {
  }
  function _addPost(uint256 a, uint256 b, uint256 c) private pure {
    require(c >= a);
  }
  function add_original(uint256 a, uint256 b) private pure returns (uint256) {
    uint256 c = a + b;
    return c;
  }
}

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  // @custom:consol { transfer(_to, _value) returns (b) requires { _to != address(0) && _value > 0 && _value <= balances[msg.sender] } }
  function transfer(address _to, uint256 _value) public returns (bool) {
    _transferPre(_to, _value);
    bool ret = transfer_original(_to, _value);
    _transferPost(_to, _value, ret);
    return ret;
  }

  function _transferPre(address _to, uint256 _value) private {
    require(_to != address(0));
    require(_value > 0);
    require(_value <= balances[msg.sender]);
  }

  function _transferPost(address _to, uint256 _value, bool b) private {
  }

  function transfer_original(address _to, uint256 _value) private returns (bool) {
    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
   // @custom:consol { transferFrom(_from, _to, _value) returns (b) requires { _to != address(0) && _value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender] } }
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    _transferFromPre(_from, _to, _value);
    bool ret = transferFrom_original(_from, _to, _value);
    _transferFromPost(_from, _to, _value, ret);
    return ret;
  }

  function _transferFromPre(address _from, address _to, uint256 _value) private {
    require(_to != address(0));
    require(_value > 0);
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
  }

  function _transferFromPost(address _from, address _to, uint256 _value, bool b) private {
  }

  function transferFrom_original(address _from, address _to, uint256 _value) private returns (bool) {
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  // @custom:consol { transferOwnership(newOwner) requires { newOwner != address(0) } }
  function transferOwnership(address newOwner) public {
    _transferOwnershipPre(newOwner);
    transferOwnership_original(newOwner);
  }

  function _transferOwnershipPre(address newOwner) private {
    require(newOwner != address(0));
  }


  function transferOwnership_original(address newOwner) onlyOwner private {
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}

/**
 * @title Pausable token
 *
 * @dev StandardToken modified with pausable transfers.
 **/

contract PausableToken is StandardToken, Pausable {

  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
    return super.approve(_spender, _value);
  }
  
  // @custom:consol { batchTransfer(_receivers, _value) returns (b) requires { _receivers.length > 0 && _receivers.length <= 20 && _value > 0 && balances[msg.sender] >= uint256(_receivers.length) * _value } }
  function batchTransfer(address[] memory _receivers, uint256 _value) public whenNotPaused returns (bool) {
    _batchTransferPre(_receivers, _value);
    bool ret = batchTransfer_original(_receivers, _value);
    _batchTransferPost(_receivers, _value, ret);
    return ret;
  }

  function _batchTransferPre(address[] memory _receivers, uint256 _value) private {
    require(_receivers.length > 0 && _receivers.length <= 20 && _value > 0 && balances[msg.sender] >= uint256(_receivers.length) * _value);
  }

  function _batchTransferPost(address[] memory _receivers, uint256 _value, bool b) private {
  }

  function batchTransfer_original(address[] memory _receivers, uint256 _value) private whenNotPaused returns (bool) {
    uint cnt = _receivers.length;
    uint256 amount = uint256(cnt) * _value;

    balances[msg.sender] = balances[msg.sender].sub(amount);
    for (uint i = 0; i < cnt; i++) {
        balances[_receivers[i]] = balances[_receivers[i]].add(_value);
        emit Transfer(msg.sender, _receivers[i], _value);
    }
    return true;
  }
}

/**
 * @title Bec Token
 *
 * @dev Implementation of Bec Token based on the basic standard token.
 */
contract BecToken is PausableToken {
    /**
    * Public variables of the token
    * The following variables are OPTIONAL vanities. One does not have to include them.
    * They allow one to customise the token contract & in no way influences the core functionality.
    * Some wallets/interfaces might not even bother to look at this information.
    */
    string public name = "BeautyChain";
    string public symbol = "BEC";
    string public version = '1.0.0';
    uint8 public decimals = 18;

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     */
    constructor() public {
      totalSupply = 7000000000 * (10**(uint256(decimals)));
      balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
    }

    function () external payable {
        //if ether is sent to this address, send it back.
        revert();
    }
}