/**
 *Submitted for verification at Etherscan.io on 2019-07-12
*/

pragma solidity ^0.5.0;

contract SafeMath {
    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        _assert(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        _assert(b > 0);
        uint256 c = a / b;
        _assert(a == b * c + a % b);
        return c;
    }

    // @custom:consol { safeSub(a, b) returns (c) requires { b <= a } }
    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
	_safeSubPre(a, b);
	uint256 c = safeSub_original(a, b);
	_safeSubPost(a, b, c);
	return c;
    }
    function _safeSubPre(uint256 a, uint256 b) private pure {
	require(b <= a);
    }
    function _safeSubPost(uint256 a, uint256 b, uint256 c) private pure {
    }
    function safeSub_original(uint256 a, uint256 b) private pure returns (uint256) {
        return a - b;
    }

    // @custom:consol { safeAdd(a, b) returns (c) ensures { c >= a && c >= b } }
    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
	_safeAddPre(a, b);
	uint256 c = safeAdd_original(a, b);
	_safeAddPost(a, b, c);
	return c;
    }
    function _safeAddPre(uint256 a, uint256 b) private pure {
    }
    function _safeAddPost(uint256 a, uint256 b, uint256 c) private pure {
	require(c >= a && c >= b);
    }
    function safeAdd_original(uint256 a, uint256 b) private pure returns (uint256) {
        uint256 c = a + b;
        return c;
    }

    function _assert(bool assertion) internal pure {
        if (!assertion) {
            revert();
        }
    }
}

contract EKT is SafeMath {
    string public name = "EKT";
    string public symbol = "EKT";
    uint8 constant public decimals = 8;
    mapping(address => uint256)  _balances;
    mapping(address => mapping(address => uint256)) public _allowed;

    uint256  public totalSupply = 10 * 100000000 * 100000000;


    constructor () public{
        _balances[msg.sender] = totalSupply;
        emit Transfer(address(0x0), msg.sender, totalSupply);
    }

    function balanceOf(address addr) public view returns (uint256) {
        return _balances[addr];
    }


    // @custom:consol { burn(_value) returns (b) requires { _value > 0 && _value <= _balances[msg.sender] && (_to == address(0) || _balances[_to] + _value >= _balances[_to]) }
    function transfer(address _to, uint256 _value)  public returns (bool) {
	_transferPre(_to, _value);
	bool b = transfer_original(_to, _value);
	_transferPost(_to, _value, b);
	return b;
    }

    function _transferPre(address _to, uint256 _value) private {
	require(_value > 0 && _value <= _balances[msg.sender] && (_to == address(0) || _balances[_to] + _value >= _balances[_to]));
    }

    function _transferPost(address _to, uint256 _value, bool b) private {
    }

    function transfer_original(address _to, uint256 _value) private returns (bool) {
//        require(_to != address(0));
        if (_to == address(0)) {
            return burn(_value);
        } else {
            _balances[msg.sender] = safeSub(_balances[msg.sender], _value);
            _balances[_to] = safeAdd(_balances[_to], _value);
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
    }

    // @custom:consol { burn(_value) returns (b) requires { _value > 0 && _value <= _balances[msg.sender] }
    function burn(uint256 _value) public returns (bool) {
	_burnPre(_value);
	bool b = burn_original(_value);
	_burnPost(_value, b);
	return b;
    }
    function _burnPre(uint256 _value) private {
	require(_value > 0 && _value <= _balances[msg.sender]);
        require(totalSupply >= _value);
    }
    function _burnPost(uint256 _value, bool b) private {
    }
    function burn_original(uint256 _value) private returns (bool) {
        _balances[msg.sender] = safeSub(_balances[msg.sender], _value);
        totalSupply = safeSub(totalSupply, _value);
        emit Burn(msg.sender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool) {
        require(_to != address(0));
        require(_balances[_from] >= _value && _value > 0);
        require(_balances[_to] + _value >= _balances[_to]);

        require(_allowed[_from][msg.sender] >= _value);

        _balances[_to] = safeAdd(_balances[_to], _value);
        _balances[_from] = safeSub(_balances[_from], _value);
        _allowed[_from][msg.sender] = safeSub(_allowed[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address spender, uint256 value)  public returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address _master, address _spender) public view returns (uint256) {
        return _allowed[_master][_spender];
    }

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 value);
    event Burn(address indexed _from, uint256 value);
}
