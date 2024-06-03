pragma solidity ^0.5.0;

/// @title SafeMath
library SafeMath {
    /// @dev {
    /// 	mul(a, b) returns (c)
    ///  	ensures { a == 0 && c == 0 || c / a == b }
    ///  }
    function mul_original(uint256 a, uint256 b) private pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
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
    /// 	  add(a, b) returns (c)
    /// 	  ensures { c >= a }
    ///  }
    function add_original(uint256 a, uint256 b) private pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function _mul_post(uint256 a, uint256 b, uint256 c) private pure {
        if (!(a==0&&c==0||c/a==b)) revert();
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = mul_original(a, b);
        _mul_post(a, b, c);
        return (c);
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

/// @title Ownable
/// functions, this simplifies the implementation of "user permissions".
contract Ownable {
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
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
}

/// @title ERC20Basic
contract ERC20Basic {
    event Transfer(address indexed from, address indexed to, uint value);

    uint public _totalSupply;

    function totalSupply() public view returns (uint);

    function balanceOf(address who) public view returns (uint);

    function transfer(address to, uint value) public;
}

/// @title ERC20 interface
contract ERC20 is ERC20Basic {
    event Approval(address indexed owner, address indexed spender, uint value);

    function allowance(address owner, address spender) public view returns (uint);

    function transferFrom(address from, address to, uint value) public;

    function approve(address spender, uint value) public;
}

/// @title Basic token
contract BasicToken is Ownable, ERC20Basic {
    using SafeMath for uint;

    mapping(address => uint) public balances;
    uint public basisPointsRate = 0;
    uint public maximumFee = 0;

    modifier onlyPayloadSize(uint size) {
        require(!(msg.data.length < (size + 4)));
        _;
    }

    /// @param _to The address to transfer to.
    /// @param _value The amount to be transferred.
    function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
        uint fee = (_value.mul(basisPointsRate)).div(10000);
        if (fee > maximumFee) {
            fee = maximumFee;
        }
        uint sendAmount = _value.sub(fee);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(sendAmount);
        if (fee > 0) {
            balances[owner] = balances[owner].add(fee);
            emit Transfer(msg.sender, owner, fee);
        }
        emit Transfer(msg.sender, _to, sendAmount);
    }

    /// @param _owner The address to query the the balance of.
    /// @return An uint representing the amount owned by the passed address.
    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }
}

/// @title Standard ERC20 token
///  
contract StandardToken is BasicToken, ERC20 {
    mapping(address => mapping(address => uint)) public allowed;
    uint public constant MAX_UINT = (2 ** 256) - 1;

    /// @param _from address The address which you want to send tokens from
    /// @param _to address The address which you want to transfer to
    /// @param _value uint the amount of tokens to be transferred
    function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
        uint fee = (_value.mul(basisPointsRate)).div(10000);
        if (fee > maximumFee) {
            fee = maximumFee;
        }
        if (allowed[_from][msg.sender] < MAX_UINT) {
            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        }
        uint sendAmount = _value.sub(fee);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(sendAmount);
        if (fee > 0) {
            balances[owner] = balances[owner].add(fee);
            emit Transfer(_from, owner, fee);
        }
        emit Transfer(_from, _to, sendAmount);
    }

    /// @param _spender The address which will spend the funds.
    /// @param _value The amount of tokens to be spent.
    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
        require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    /// @param _owner address The address which owns the funds.
    /// @param _spender address The address which will spend the funds.
    /// @return A uint specifying the amount of tokens still available for the spender.
    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return allowed[_owner][_spender];
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

contract BlackList is Ownable, BasicToken {
    event DestroyedBlackFunds(address _blackListedUser, uint _balance);

    event AddedBlackList(address _user);

    event RemovedBlackList(address _user);

    mapping(address => bool) public isBlackListed;

    /// //// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
    function getBlackListStatus(address _maker) external view returns (bool) {
        return isBlackListed[_maker];
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function addBlackList(address _evilUser) public onlyOwner() {
        isBlackListed[_evilUser] = true;
        emit AddedBlackList(_evilUser);
    }

    function removeBlackList(address _clearedUser) public onlyOwner() {
        isBlackListed[_clearedUser] = false;
        emit RemovedBlackList(_clearedUser);
    }

    function destroyBlackFunds(address _blackListedUser) public onlyOwner() {
        require(isBlackListed[_blackListedUser]);
        uint dirtyFunds = balanceOf(_blackListedUser);
        balances[_blackListedUser] = 0;
        _totalSupply -= dirtyFunds;
        emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
    }
}

contract UpgradedStandardToken is StandardToken {
    function transferByLegacy(address from, address to, uint value) public;

    function transferFromByLegacy(address sender, address from, address spender, uint value) public;

    function approveByLegacy(address from, address spender, uint value) public;
}

contract TetherToken is Pausable, StandardToken, BlackList {
    event Issue(uint amount);

    event Redeem(uint amount);

    event Deprecate(address newAddress);

    event Params(uint feeBasisPoints, uint maxFee);

    string public name;
    string public symbol;
    uint public decimals;
    address public upgradedAddress;
    bool public deprecated;

    constructor(uint _initialSupply, string memory _name, string memory _symbol, uint _decimals) public {
        _totalSupply = _initialSupply;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        balances[owner] = _initialSupply;
        deprecated = false;
    }

    /// @dev {
    /// 	transfer(_to, _value)
    /// 	requires { !isBlackListed[msg.sender] }
    ///  }
    function transfer_original(address _to, uint _value) private whenNotPaused() {
        if (deprecated) {
            return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
        } else {
            return super.transfer(_to, _value);
        }
    }

    function transferFrom(address _from, address _to, uint _value) public whenNotPaused() {
        require(!isBlackListed[_from]);
        if (deprecated) {
            return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
        } else {
            return super.transferFrom(_from, _to, _value);
        }
    }

    function balanceOf(address who) public view returns (uint) {
        if (deprecated) {
            return UpgradedStandardToken(upgradedAddress).balanceOf(who);
        } else {
            return super.balanceOf(who);
        }
    }

    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
        if (deprecated) {
            return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
        } else {
            return super.approve(_spender, _value);
        }
    }

    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        if (deprecated) {
            return StandardToken(upgradedAddress).allowance(_owner, _spender);
        } else {
            return super.allowance(_owner, _spender);
        }
    }

    function deprecate(address _upgradedAddress) public onlyOwner() {
        deprecated = true;
        upgradedAddress = _upgradedAddress;
        emit Deprecate(_upgradedAddress);
    }

    function totalSupply() public view returns (uint) {
        if (deprecated) {
            return StandardToken(upgradedAddress).totalSupply();
        } else {
            return _totalSupply;
        }
    }

    function issue(uint amount) public onlyOwner() {
        require((_totalSupply + amount) > _totalSupply);
        require((balances[owner] + amount) > balances[owner]);
        balances[owner] += amount;
        _totalSupply += amount;
        emit Issue(amount);
    }

    function redeem(uint amount) public onlyOwner() {
        require(_totalSupply >= amount);
        require(balances[owner] >= amount);
        _totalSupply -= amount;
        balances[owner] -= amount;
        emit Redeem(amount);
    }

    function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner() {
        require(newBasisPoints < 20);
        require(newMaxFee < 50);
        basisPointsRate = newBasisPoints;
        maximumFee = newMaxFee.mul(10 ** decimals);
        emit Params(basisPointsRate, maximumFee);
    }

    function _transfer_pre(address _to, uint _value) private {
        if (!(!isBlackListed[msg.sender])) revert();
    }

    function transfer(address _to, uint _value) public {
        _transfer_pre(_to, _value);
        transfer_original(_to, _value);
    }
}