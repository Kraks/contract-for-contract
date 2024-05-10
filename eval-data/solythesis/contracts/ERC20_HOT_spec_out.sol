pragma solidity ^0.5.0;

/// @title Ownable
/// functions, this simplifies the implementation of "user permissions".
contract Ownable {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /// account.
    constructor() public {
        owner = msg.sender;
    }

    /// @param newOwner The address to transfer ownership to.
    function transferOwnership(address newOwner) public onlyOwner() {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

/// @title SafeMath
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert((c / a) == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    /// @dev {
    /// 	sub(a, b) returns (c)
    /// 	requires { b <= a }
    ///  }
    function sub_original(uint256 a, uint256 b) private pure returns (uint256) {
        return a - b;
    }

    /// @dev {
    /// 	add(a, b) returns (c)
    /// 	ensures { c >= a }
    ///  }
    function add_original(uint256 a, uint256 b) private pure returns (uint256) {
        uint256 c = a + b;
        return c;
    }

    function _sub_pre(uint256 a, uint256 b) private pure {
        if (!(b<=a)) revert();
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        _sub_pre(a, b);
        uint256 c = sub_original(a, b);
        return (c);
    }

    function _add_post(uint256 a, uint256 b, uint256 c) private pure {
        if (!(c>=a)) revert();
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = add_original(a, b);
        _add_post(a, b, c);
        return (c);
    }
}

contract HoloToken is Ownable {
    using SafeMath for uint256;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    event Mint(address indexed to, uint256 amount);

    event MintingFinished();

    event Burn(uint256 amount);

    string public constant name = "HoloToken";
    string public constant symbol = "HOT";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    constructor() public {
        totalSupply = 300000000 * (10 ** uint(decimals));
        balances[msg.sender] = totalSupply;
    }

    /// @dev {
    /// 	transfer(_to, _value) returns (b)
    /// 	requires { _to != address(0) && _value <= balances[msg.sender] }
    ///  }
    function transfer_original(address _to, uint256 _value) private returns (bool) {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /// @param _owner The address to query the the balance of.
    /// @return An uint256 representing the amount owned by the passed address.
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    /// @param _from address The address which you want to send tokens from
    /// @param _to address The address which you want to transfer to
    /// @param _value uint256 the amout of tokens to be transfered
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    ///    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    /// and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    /// race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    /// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    /// @param _spender The address which will spend the funds.
    /// @param _value The amount of tokens to be spent.
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /// @param _owner address The address which owns the funds.
    /// @param _spender address The address which will spend the funds.
    /// @return A uint256 specifying the amount of tokens still available for the spender.
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    /// approve should be called when allowed[_spender] == 0. To increment
    /// allowed value is better to use this function to avoid 2 calls (and wait until
    /// the first transaction is mined)
    /// From MonolithDAO Token.sol
    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function _transfer_pre(address _to, uint256 _value) private {
        if (!(_to!=address(0)&&_value<=balancesmsg.sender)) revert();
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        _transfer_pre(_to, _value);
        bool b = transfer_original(_to, _value);
        return (b);
    }
}