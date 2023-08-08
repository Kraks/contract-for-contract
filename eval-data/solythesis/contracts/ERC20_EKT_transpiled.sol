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

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
	return _safeSub_guard(a, b);
    }

    // @custom:consol 
    //	safeSub(a, b) returns (c) 
    //	requires b <= a
    function _safeSub_guard(uint256 a, uint256 b) private pure returns (uint256) {
	_safeSub_pre(a, b);
	uint256 c = _safeSub_worker(a, b);
	return c;
    }
    function _safeSub_pre(uint256 a, uint256 b) private pure {
	if (!(b <= a)) revert();
    }

    function _safeSub_worker(uint256 a, uint256 b) private pure returns (uint256) {
        return a - b;
    }

    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
	return _safeAdd_guard(a, b);
    }

    // @custom:consol 
    //	safeAdd(a, b) returns (c) 
    //	ensures c >= a && c >= b
    function _safeAdd_guard(uint256 a, uint256 b) private pure returns (uint256) {
	uint256 c = _safeAdd_worker(a, b);
	_safeAdd_post(a, b, c);
	return c;
    }

    function _safeAdd_post(uint256 a, uint256 b, uint256 c) private pure {
	if (!(c >= a && c >= b)) revert(0);
    }
    function _safeAdd_worker(uint256 a, uint256 b) private pure returns (uint256) {
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


    function transfer(address _to, uint256 _value) public returns (bool) {
	return _transfer_guard(_to, _value);
    }

    // @custom:consol 
    //	burn(_value) returns (b) 
    //	requires _value > 0 && _value <= _balances[msg.sender] && (_to == address(0) || _balances[_to] + _value >= _balances[_to])
    function _transfer_guard(address _to, uint256 _value) private returns (bool) {
	_transfer_pre(_to, _value);
	bool b = _transfer_worker(_to, _value);
	return b;
    }

    function _transfer_pre(address _to, uint256 _value) private {
	if (!(_value > 0 && _value <= _balances[msg.sender] && (_to == address(0) || _balances[_to] + _value >= _balances[_to]))) revert();
    }

    function _transfer_worker(address _to, uint256 _value) private returns (bool) {
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

    function burn(uint256 _value) public returns (bool) {
	return _burn_guard(_value);
    }

    // @custom:consol 
    //	burn(_value) returns (b) 
    //	requires _value > 0 && _value <= _balances[msg.sender] && totalSupply >= _value
    function _burn_guard(uint256 _value) private returns (bool) {
	_burn_pre(_value);
	bool b = _burn_worker(_value);
	return b;
    }

    function _burn_pre(uint256 _value) private {
	if (!(_value > 0 && _value <= _balances[msg.sender] && totalSupply >= _value)) revert();
    }

    function _burn_worker(uint256 _value) private returns (bool) {
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
