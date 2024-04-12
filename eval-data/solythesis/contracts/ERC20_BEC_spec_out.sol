pragma solidity ^0.5.0;

/// @title SafeMath
library SafeMath {
    /// @dev {
    ///  	mul(a, b) returns (c) ensures { a == 0 || c / a == b }
    ///  }
    function mul_original(uint256 a, uint256 b) private returns (uint256) {
        uint256 c = a * b;
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    /// @dev {
    /// 	sub(a, b) returns (c)
    ///  requires { b <= a }
    ///  }
    function sub_original(uint256 a, uint256 b) private returns (uint256) {
        return a - b;
    }

    /// @dev {
    /// 	add(a, b) returns (c)
    /// 	  ensures { c >= a }
    ///  }
    function add_original(uint256 a, uint256 b) private returns (uint256) {
        uint256 c = a + b;
        return c;
    }

    function _mul_post(uint256 a, uint256 b, uint256 c) private {
        if (!(a==0||c/a==b)) revert();
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = mul_original(a, b);
        _mul_post(a, b, c);
        return (c);
    }

    function _sub_pre(uint256 a, uint256 b) private {
        if (!(b<=a)) revert();
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        _sub_pre(a, b);
        uint256 c = sub_original(a, b);
        return (c);
    }

    function _add_post(uint256 a, uint256 b, uint256 c) private {
        if (!(c>=a)) revert();
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = add_original(a, b);
        _add_post(a, b, c);
        return (c);
    }
}

/// @title ERC20Basic
contract ERC20Basic {
    event Transfer(address indexed from, address indexed to, uint256 value);

    uint256 public totalSupply;
}

/// @title Basic token
contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) internal balances;

    /// @dev {
    ///  	transfer(_to, _value) returns (b)
    /// 	   requires { _to != address(0) && _value > 0 && _value <= balances[msg.sender] }
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

    function _transfer_pre(address _to, uint256 _value) private {
        if (!(_to!=address(0)&&_value>0&&_value<=balances[msg.sender])) revert();
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        _transfer_pre(_to, _value);
        bool b = transfer_original(_to, _value);
        return (b);
    }
}

/// @title ERC20 interface
contract ERC20 is ERC20Basic {
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/// @title Standard ERC20 token
///
contract StandardToken is ERC20, BasicToken {
    mapping(address => mapping(address => uint256)) internal allowed;

    /// @dev {
    /// 	transferFrom(_from, _to, _value) returns (b)
    /// 	 requires { _to != address(0) && _value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender] }
    ///  }
    function transferFrom_original(address _from, address _to, uint256 _value) private returns (bool) {
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
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function _transferFrom_pre(address _from, address _to, uint256 _value) private {
        if (!(_to!=address(0)&&_value>0&&_value<=balances_from&&_value<=allowed[_from][msg.sender])) revert();
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        _transferFrom_pre(_from, _to, _value);
        bool b = transferFrom_original(_from, _to, _value);
        return (b);
    }
}

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

    /// @dev {
    ///  	transferOwnership(newOwner)
    /// 	   requires { newOwner != address(0) }
    ///  }
    function transferOwnership_original(address newOwner) private onlyOwner() {
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function _transferOwnership_pre(address newOwner) private {
        if (!(newOwner!=address(0))) revert();
    }

    function transferOwnership(address newOwner) public {
        _transferOwnership_pre(newOwner);
        transferOwnership_original(newOwner);
    }
}

/// @title Pausable
contract Pausable is Ownable {
    event Pause();

    event Unpause();

    bool public paused = false;

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    modifier whenPaused() {
        require(paused);
        _;
    }

    function pause() public onlyOwner() whenNotPaused() {
        paused = true;
        emit Pause();
    }

    function unpause() public onlyOwner() whenPaused() {
        paused = false;
        emit Unpause();
    }
}

/// @title Pausable token
///  *
contract PausableToken is StandardToken, Pausable {
    function transfer(address _to, uint256 _value) public whenNotPaused() returns (bool) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused() returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public whenNotPaused() returns (bool) {
        return super.approve(_spender, _value);
    }

    /// @dev {
    /// 	batchTransfer(_receivers, _value) returns (b)
    /// 	 requires { _receivers.length > 0 && _receivers.length <= 20 && _value > 0 && balances[msg.sender] >= uint256(cnt) * _value }
    ///  }
    function batchTransfer_original(address[] memory _receivers, uint256 _value) private whenNotPaused() returns (bool) {
        uint cnt = _receivers.length;
        uint256 amount = uint256(cnt) * _value;
        balances[msg.sender] = balances[msg.sender].sub(amount);
        for (uint i = 0; i < cnt; i++) {
            balances[_receivers[i]] = balances[_receivers[i]].add(_value);
            emit Transfer(msg.sender, _receivers[i], _value);
        }
        return true;
    }

    function _batchTransfer_pre(address[] memory _receivers, uint256 _value) private {
        if (!(_receivers.length>0&&_receivers.length<=20&&_value>0&&balances[msg.sender]>=uint256(cnt)*_value)) revert();
    }

    function batchTransfer(address[] memory _receivers, uint256 _value) public returns (bool) {
        _batchTransfer_pre(_receivers, _value);
        bool b = batchTransfer_original(_receivers, _value);
        return (b);
    }
}

/// @title Bec Token
///
contract BecToken is PausableToken {
    string public name = "BeautyChain";
    string public symbol = "BEC";
    string public version = "1.0.0";
    uint8 public decimals = 18;

    constructor() public {
        totalSupply = 7000000000 * (10 ** (uint256(decimals)));
        balances[msg.sender] = totalSupply;
    }

    function () external payable {
        revert();
    }
}
