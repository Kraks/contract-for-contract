pragma solidity ^0.8.17;

interface IReceiver {
    function foo(string memory _message, uint _x) external payable returns (uint);
}

contract Caller {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    event Response(uint);

    /// @custom:consol {testaddr{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v==100 } ensures { data == true }}
    address internal testaddr = _wrap_testaddr(0);
    /// @custom:consol {testaddr2{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v==200 }}
    address internal testaddr2 = _wrap_testaddr2(0x86392dC19c0b719886221c78AB11eb8Cf5c52812);

    /// @custom:consol { callFoo(addr, x) returns (y)
    ///    requires {x > 0}
    ///    where {
    ///      IReceiver(addr).foo{value: v, gas: g}(mymsg, x) returns (y)
    ///      requires { v > 5 && g < 10000 && x != 0 }
    ///      ensures { y == x + 1 }
    ///    }
    ///  }
    function callFoo_original(uint256 _addr, uint256 x) public payable returns (uint) {
        uint z = dispatch_IReceiver_foo(_addr, 0, 0, "call foo", x);
        uint y = dispatch_IReceiver_foo(_addr, msg.value, 5000, "call foo", x);
        emit Response(y);
        return y;
    }

    function _wrap_testaddr(address addr) private pure returns (uint256) {
        return uint256(uint160(addr));
    }

    function _wrap_testaddr2(address addr) private pure returns (uint256) {
        return uint256(uint160(addr));
    }

    function _callFoo_pre(address payable addr, uint x) private {
        if (!(x>0)) revert preViolation("callFoo");
    }

    function callFoo_guard(uint256 _addr, uint256 x) private payable returns (uint) {
        _callFoo_pre(payable(address(uint160(_addr))), x);
        _addr = _addr | (uint96(1 << 42) << 160);
        uint y = callFoo_original(_addr, x);
        return (y);
    }

    function callFoo(address payable _addr, uint x) private payable returns (uint) {
        uint256 _cs_0 = callFoo_guard(uint256(uint160(address(_addr))), x);
        return (_cs_0);
    }

    function _IReceiver_foo_0_pre(address addr, uint256 v, uint256 g, string memory mymsg, uint x) private {
        if (!(v>5&&g<10000&&x!=0)) revert preViolationAddr(0);
    }

    function _IReceiver_foo_0_post(address addr, uint256 v, uint256 g, string memory mymsg, uint x, uint y) private {
        if (!(y==x+1)) revert postViolationAddr(0);
    }

    function dispatch_IReceiver_foo(uint256 addr, uint256 value, uint256 gas, string memory _message, uint _x) private payable returns (uint) {
        uint96 specId = uint96(addr >> 160);
        if ((specId & uint96(1 << 0)) != 0) _IReceiver_foo_0_pre(payable(address(uint160(addr))), value, gas, _message, _x);
        uint256 _cs_1 = IReceiver(payable(address(uint160(addr)))).foo{value: value, gas: gas}(_message, _x);
        if ((specId & uint96(1 << 0)) != 0) _IReceiver_foo_0_post(payable(address(uint160(addr))), value, gas, _message, _x, _cs_1);
        return (_cs_1);
    }
}