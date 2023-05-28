pragma solidity ^0.8.9;

contract Caller {
    event Response(bool success, bytes data);

    /// @custom:consol { testCallFoo(addr, x) requires {x > 0} where { addr{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v > 5 && g < 10000 && x != 0 } ensures { flag == true } }}
    function testCallFoo_original(address payable _addr, int256 x) private payable {
        (bool success, bytes memory data) = guardedCall(_addr, msg.value, 5000, "foo(string, uint256)", "call foo", x);
        emit Response(success, data);
    }

    function _testCallFooPre(address payable _addr, int256 x) public returns (bool) {
        return x>0;
    }

    function guardedCall(, , , , , ) public constant {
        require(v>5&&g<10000&&x!=0, "Violate the precondition");
        require(flag==true, "Violate the postcondition");
    }

    function testCallFoo(address payable _addr, int256 x) public payable {
        require(_testCallFooPre(_addr, x), "Violate the precondition for function testCallFoo");
        testCallFoo_original(_addr, x);
    }
}