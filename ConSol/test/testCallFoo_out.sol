pragma solidity ^0.8.9;

contract Caller {
    error preViolation(string memory funcName);

    error postViolation(string memory funcName);

    error PreViolationAddr(uint256 specId);

    error PostViolationAddr(uint256 specId);

    event Response(bool success, bytes data);

    /// @custom:consol {
    ///   testCallFoo(addr, x) requires {x > 0} where {
    ///     addr{value: v, gas: g}(mymsg, x) returns (flag, data)
    ///     requires { v > 5 && g < 10000 && x != 0 }
    ///     ensures { flag == true }
    ///   } {
    ///     addr.send(x) returns (b)
    ///     requires { x < 1024 }
    ///     ensures { b == true }
    ///   }
    /// }
    function testCallFoo_original(address payable _addr, uint256 x) private payable {
        (bool success, bytes memory data) = guarded_testCallFoo_addr_call(_addr, msg.value, 5000, "call foo", x);
        bool res = guarded_testCallFoo_addr_send(_addr, x);
        emit Response(success, data);
    }

    function _testCallFooPre(address payable addr, uint256 x) private {
        if (!x>0) revert preViolation("testCallFoo");
    }

    function _addrPre(uint256 v, uint256 g, string memory mymsg,  uint256 x) private {
        if (!v>5&&g<10000&&x!=0) revert PreViolationAddr(0);
    }

    function _addrPost(uint256 v, uint256 g, string memory mymsg,  uint256 x, bool flag, bytes memory data) private {
        if (!flag==true) revert PostViolationAddr(0);
    }

    function guarded_testCallFoo_addr_call(address addr, uint256 v, uint256 g, string memory mymsg,  uint256 x) public payable returns (bool flag, bytes memory data) {
        _addrPre(v, g, mymsg, x);
        (bool flag, bytes memory data) = addr.call{value: v, gas: g}(abi.encodeWithSignature("foo(string, uint256)", mymsg, x));
        _addrPost(v, g, mymsg, x, flag, data);
        return (flag, data);
    }

    function _addrPre(uint256 x) private {
        if (!x<1024) revert PreViolationAddr(0);
    }

    function _addrPost(uint256 x, bool b) private {
        if (!b==true) revert PostViolationAddr(0);
    }

    function guarded_testCallFoo_addr_send(address addr, uint256 x) public payable returns (bool b) {
        _addrPre(x);
        bool b = addr.send(x);
        _addrPost(x, b);
        return (b);
    }

    function testCallFoo(address payable _addr, uint256 x) public payable {
        _testCallFooPre(_addr, x);
        testCallFoo_original(_addr, x);
    }
}
