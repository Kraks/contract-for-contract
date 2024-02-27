pragma solidity ^0.8.9;

contract Caller {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    event Response(bool success, bytes data);

    /// @custom:consol { testCallFoo(addr, x) requires {x > 0} where { addr{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v > 5 && g < 10000 && x != 0 } ensures { flag == true } } { addr.send(x) returns (b) requires { x < 1024 } ensures {b == true} }}
    function testCallFoo_original(address payable _addr, uint256 x) private payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(abi.encodeWithSignature("foo(string, uint256)", "call foo", x));
        bool res = _addr.send(x);
        emit Response(success, data);
    }

    /// @custom:consol { anotherTest(addr, x) requires {x > 0} where { addr(mymsg, x) returns (flag, data) requires { v > 5 && g < 10000 && x != 0 } ensures { flag == true } }}
    function anotherTest_original(address payable _addr, int256 x) private payable {
        (bool success, bytes memory data) = _addr.call(abi.encodeWithSignature("foo(string, uint256)", "call foo", 456));
        emit Response(success, data);
    }

    function _testCallFoo_pre(address payable addr, uint256 x) private {
        if (!(x>0)) revert preViolation("testCallFoo");
    }

    function testCallFoo(address payable _addr, uint256 x) private payable {
        testCallFoo_guard(uint256(uint160(address(_addr))), x)
    }

    function testCallFoo(address payable _addr, uint256 x) public payable {
        _testCallFoo_pre(_addr, x);
        testCallFoo_original(_addr, x);
    }

    function _anotherTest_pre(address payable addr, int256 x) private {
        if (!(x>0)) revert preViolation("anotherTest");
    }

    function anotherTest(address payable _addr, int256 x) private payable {
        anotherTest_guard(uint256(uint160(address(_addr))), x)
    }

    function anotherTest(address payable _addr, int256 x) public payable {
        _anotherTest_pre(_addr, x);
        anotherTest_original(_addr, x);
    }
}