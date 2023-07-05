pragma solidity ^0.8.9;

contract Caller {
    error preViolation(string memory funcName);

    error PreViolationAddr(uint256 specId);

    event Response(bool success, bytes data);

    /// @custom:consol { testCallFoo(addr, x) requires {x > 0} where { addr{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v > 5 && g < 10000 && x != 0 } ensures { flag == true } } { addr.send(x) returns (b) requires { x < 1024 } ensures {b == true} }}
    function testCallFoo_original(address payable _addr, uint256 x) private payable {
        (bool success, bytes memory data) = guarded_testCallFoo_addr(_addr, msg.value, 5000, "call foo", x);
        bool res = guarded_testCallFoo_addr(_addr, x);
        emit Response(success, data);
    }

    /// @custom:consol { testCallFoo(addr, x) requires {x > 0} where { addr(mymsg, x) returns (flag, data) requires { v > 5 && g < 10000 && x != 0 } ensures { flag == true } }}
    function anotherTest_original(address payable _addr, int256 x) private payable {
        (bool success, bytes memory data) = guarded_anotherTest_addr(_addr, "call foo", 456);
        emit Response(success, data);
    }

    function _testCallFooPre(address payable addr, uint256 x) private returns (bool) {
        return x>0;
    }

    function _addrPre(uint256 v, uint256 g, string memory mymsg,  uint256 x) private returns (bool) {
        return v>5&&g<10000&&x!=0;
    }

    function _addrPost(uint256 v, uint256 g, string memory mymsg,  uint256 x, bool flag, bytes memory data) private returns (bool) {
        return flag==true;
    }

    function guarded_testCallFoo_addr(address addr, uint256 v, uint256 g, string memory mymsg,  uint256 x) public payable returns (bool flag, bytes memory data) {
        require(_addrPre(v, g, mymsg, x), "Violate the precondition for address addr");
        (bool flag, bytes memory data) = addr.call{value: v, gas: g}(abi.encodeWithSignature("foo(string, uint256)", mymsg, x));
        require(_addrPost(v, g, mymsg, x, flag, data), "Violate the postondition for address addr");
        return (flag, data);
    }

    function _addrPre(uint256 x) private returns (bool) {
        return x<1024;
    }

    function _addrPost(uint256 x, bool b) private returns (bool) {
        return b==true;
    }

    function guarded_testCallFoo_addr(address addr, uint256 x) public payable returns (bool b) {
        require(_addrPre(x), "Violate the precondition for address addr");
        bool b = addr.send(x);
        require(_addrPost(x, b), "Violate the postondition for address addr");
        return (b);
    }

    function testCallFoo(address payable _addr, uint256 x) public payable {
        require(_testCallFooPre(_addr, x), "Violate the precondition for function testCallFoo");
        testCallFoo_original(_addr, x);
    }

    function _anotherTestPre(address payable addr, int256 x) private returns (bool) {
        return x>0;
    }

    function _addrPre(string memory mymsg,  uint256 x) private returns (bool) {
        return v>5&&g<10000&&x!=0;
    }

    function _addrPost(string memory mymsg,  uint256 x, bool flag, bytes memory data) private returns (bool) {
        return flag==true;
    }

    function guarded_anotherTest_addr(address addr, string memory mymsg,  uint256 x) public payable returns (bool flag, bytes memory data) {
        require(_addrPre(mymsg, x), "Violate the precondition for address addr");
        (bool flag, bytes memory data) = addr.call(abi.encodeWithSignature("foo(string, uint256)", mymsg, x));
        require(_addrPost(mymsg, x, flag, data), "Violate the postondition for address addr");
        return (flag, data);
    }

    function anotherTest(address payable _addr, int256 x) public payable {
        require(_anotherTestPre(_addr, x), "Violate the precondition for function anotherTest");
        anotherTest_original(_addr, x);
    }
}