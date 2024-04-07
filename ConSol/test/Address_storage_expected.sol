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

    /// @custom:consol {non_addr_var{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v==100 } ensures { data == true }}
    uint160 internal non_addr_var;
    /// @custom:consol {IReceiver(testaddr).foo{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v==100 } ensures { data == true }}
    uint256 internal testaddr = _wrap_testaddr(0);
    /// @custom:consol {IReceiver(testaddr2).foo{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v==200 }}
    uint256 internal testaddr2 = _wrap_testaddr2(0x86392dC19c0b719886221c78AB11eb8Cf5c52812);

    function callFoo(uint x) public payable returns (uint) {
        uint z = dispatch_IReceiver_foo(testaddr, 0, 0, "call foo", x);
        uint y = dispatch_IReceiver_foo(testaddr, msg.value, 5000, "call foo", x);
        (bool success, ) = testaddr2.call(abi.encodeWithSignature("foo(uint256)", x));
        emit Response(y);
        return y;
    }

    function _wrap_testaddr(address addr) private pure returns (uint256) {
        uint256 _addr = uint256(uint160(addr));
        _addr = _addr | (uint96(1 << 42) << 160);
        _addr = _addr | (uint96(1 << 2) << 160);
        return _addr;
    }

    function _wrap_testaddr2(address addr) private pure returns (uint256) {
        uint256 _addr = uint256(uint160(addr));
        _addr = _addr | (uint96(1 << 42) << 160);
        _addr = _addr | (uint96(1 << 2) << 160);
        return _addr;
    }
}