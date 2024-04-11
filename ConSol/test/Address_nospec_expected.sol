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

    /// @dev { callFoo(_addr, x) returns (y)
    ///    requires {x > 0}
    ///  }
    function callFoo_original(address payable _addr, uint x) private returns (uint) {
        uint z = IReceiver(_addr).foo("call foo", x);
        uint y = IReceiver(_addr).foo{value: msg.value, gas: 5000}("call foo", x);
        emit Response(x);
        return x;
    }

    function _callFoo_pre(address payable _addr, uint x) private {
        if (!(x>0)) revert preViolation("callFoo");
    }

    function callFoo(address payable _addr, uint x) public payable returns (uint) {
        _callFoo_pre(_addr, x);
        uint y = callFoo_original(_addr, x);
        return (y);
    }
}