pragma solidity ^0.8.9;

contract Caller {
    event Response(bool success, bytes data);

    /// @custom:consol { testCallFoo(addr, x) requires {x > 0} where { addr{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v > 5 && g < 10000 && x != 0 } ensures { flag == true } }}
    function testCallFoo_original(address payable _addr, int256 x) private payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(abi.encodeWithSignature("foo(string, uint256)", "call foo", x));
        emit Response(success, data);
    }

    function _testCallFooPre(address payable addr, int256 x) private returns (bool) {
        return x>0;
    }

    function _addrPre(uint256 v, uint256 g, string memory mymsg,  uint256 x) private returns (bool) {
        return v>5&&g<10000&&x!=0;
    }

    function _addrPost(uint256 v, uint256 g, string memory mymsg,  uint256 x, bool flag, bytes memory data) private returns (bool) {
        return flag==true;
    }

    function guarded_addr(address addr, uint256 v, uint256 g, string memory mymsg,  uint256 x) public payable returns (bool flag, bytes memory data) {
        require(_addrPre(v, g, mymsg, x), "Violate the precondition for address addr");
        (bool flag, bytes memory data) = addr{value: v, gas: g}(mymsg, x);
        require(_addrPost(v, g, mymsg, x, flag, data), "Violate the postondition for address addr");
        return (flag, data);
    }

    function testCallFoo(address payable _addr, int256 x) public payable {
        require(_testCallFooPre(_addr, x), "Violate the precondition for function testCallFoo");
        testCallFoo_original(_addr, x);
    }
}