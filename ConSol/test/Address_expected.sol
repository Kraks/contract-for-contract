pragma solidity ^0.8.17;

interface IReceiver {
    function foo(string memory _message, uint _x) external payable returns (uint);
}

contract Caller {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error PreViolationAddr(uint256 specId);

    error PostViolationAddr(uint256 specId);

    event Response(uint);

    /// @custom:consol { callFoo(addr, x)
    ///    requires {x > 0}
    ///    where {
    ///      IReceiver(addr).foo{value: v, gas: g}(mymsg, x) returns (y)
    ///      requires { v > 5 && g < 10000 && x != 0 }
    ///      ensures { y == x + 1 }
    ///    }
    ///  }
    function callFoo_original(uint256 addr, uint x) private {
        uint y = _dispatch_IReceiver_foo(addr, msg.value, 5000, "call foo", x);
        emit Response(y);
    }

    function _callFooPre(address addr, uint x) private {
        if (!(x>0)) revert preViolation("callFoo");
    }

    function _dispatch_IReceiver_foo(uint256 addr, uint256 value, uint256 gas, string memory msg, uint x) private returns (uint) {
        // TODO
        return 0;
    }

    function _attachSpec(uint256 addr, uint256 specId) private {
        // TODO
    }

    function callFoo_guard(uint256 _addr, uint x) private {
        // Note (GW): technically we want to pass wrapped/guarded addresses into pre/post checking functiosn too,
        // since they may invoke these address values. However, they may also inspect the raw data of addresses
        // (eg compare equality), which would require unwrap them. So generally, we need to be able to parse
        // the specification expression and insert proper unwrap inside, in contrast to treating them as strings.
        // Right now, we don't have that yet, so let's just pass unwrapped addr to pre/post check functions.
        _callFooPre(_unwrap(_addr), x);
        _attachSpec(_addr, 1);
        callFoo_original(_addr, x);
    }

    function _wrap(address payable addr) private returns (uint256) {
        return uint256(uint160(address(addr)));
    }

    function _unwrap(uint256 guardedAddr) private returns (address) {
        return address(uint160(guardedAddr));
    }

    function callFoo(address payable _addr, uint x) public payable {
        callFoo_guard(_wrap(_addr), x);
    }
}
