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

    /// @custom:consol { callFoo(addr, x) returns (y)
    ///    requires {x > 0}
    ///    where {
    ///      IReceiver(addr).foo{value: v, gas: g}(mymsg, x) returns (y)
    ///      requires { v > 5 && g < 10000 && x != 0 }
    ///      ensures { y == x + 1 }
    ///    }
    ///  }
    function callFoo_original(uint256 addr, uint x) private returns (uint) {
        uint y = _dispatch_IReceiver_foo(addr, msg.value, 5000, "call foo", x);
        emit Response(y);
        return y;
    }

    // Done
    // Those parameter names should be the same as the specification
    // QUESTION: should the argument always be `address payable`?
    function _callFoo_pre(address payable addr, uint x) private {
        if (!(x>0)) revert preViolation("callFoo");
    }

    // Those parameter names should be the same as the specification
    function _IReceiver_foo_spec0_pre(address addr, uint256 v, uint256 g, string memory mymsg, uint x) private {
        if (!(v > 5 && g < 10000 && x != 0)) revert PreViolationAddr(1);
    }

    // Those parameter names should be the same as the specification
    function _IReceiver_foo_spec0_post(address addr, uint256 v, uint256 g, string memory mymsg, uint x, uint y) private {
        if (!(y == x + 1)) revert PostViolationAddr(1);
    }

    // XXX: parameter names, should come from the interface
    // XXX: we generate gas parameter by default, if the call site does not specify it, should use a default (max?) value
    function _dispatch_IReceiver_foo(uint256 addr, uint256 value, uint256 gas, string memory mymsg, uint x) private returns (uint) {
        uint96 specId = uint96(addr >> 160);
        // Note: should only generate dispatching logic for IRerciever.foo for good
        // 1 is the spec Id in this example
        // 2^0, 2^1, 2^n, upto n = 95 in the worst case
        if (specId & encodeNatSpecId(0) != 0) {
            _IReceiver_foo_spec0_pre(_unwrap(addr), value, gas, mymsg, x);
        }
        uint y = IReceiver(_unwrap(addr)).foo{value: value, gas: gas}(mymsg, x);
        if (specId & encodeNatSpecId(0) != 0) {
            _IReceiver_foo_spec0_post(_unwrap(addr), value, gas, mymsg, x, y);
        }
        return y;
    }

    // Should be inlined/applied at compile-time by Solidity
    function _attachSpec(uint256 addr, uint96 specId) pure private returns (uint256) {
        return addr | (specId << 160);
    }

    // Should be eliminated/applied at compile-time by Solidity
    function encodeNatSpecId(uint96 specId) pure private returns (uint96) {
        return uint96(1 << specId);
    }

    function callFoo_guard(uint256 _addr, uint x) private returns (uint) {
        // Note (GW): technically we want to pass wrapped/guarded addresses into pre/post checking functiosn too,
        // since they may invoke these address values. However, they may also inspect the raw data of addresses
        // (eg compare equality), which would require unwrap them. So generally, we need to be able to parse
        // the specification expression and insert proper unwrap inside, in contrast to treating them as strings.
        // Right now, we don't have that yet, so let's just pass unwrapped addr to pre/post check functions.
        _callFoo_pre(_unwrap(_addr), x);
        _addr = _attachSpec(_addr, encodeNatSpecId(0));
        return callFoo_original(_addr, x);
    }

    // TODO: inlined/applied at compile-time of consol
    function _unwrap(uint256 guardedAddr) pure private returns (address payable) {
        //address a = payable(address(uint160(guardedAddr)));
        return payable(address(uint160(guardedAddr)));
    }

    function callFoo(address payable _addr, uint x) public payable returns (uint) {
        uint256 _cs_0 = callFoo_guard(uint256(uint160(address(_addr))), x);
        return (_cs_0);
    }
}
