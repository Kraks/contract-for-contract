// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Receiver {
  event Received(address caller, uint amount, string message);

  fallback() external payable {
    emit Received(msg.sender, msg.value, "Fallback was called");
  }

  function foo(string memory _message, uint _x) public payable returns (uint) {
    emit Received(msg.sender, msg.value, _message);

    return _x + 1;
  }
}

interface IReceiver {
  function foo(string memory _message, uint _x) external payable returns (uint);
}

contract Caller {
  event Response(uint);

  // Let's imagine that contract Caller does not have the source code for the
  // contract Receiver, but we do know the address of contract Receiver and the
  // function to call as well as the interface of contract Receiver.

  // @custom:consol { testCallFoo(addr, x)
  // requires {x > 0}
  // where
  //   {
  //     addr.foo{value: v, gas: g}(mymsg, x) returns (y)
  //     requires { v > 5 && g < 10000 && x != 0 }
  //     ensures { y == x + 1 }
  //   }
  // }
  function testCallFoo(address payable _addr, uint x) public payable {
    // You can send ether and specify a custom gas amount
    uint y = IReceiver(_addr).foo{value: msg.value, gas: 5000}("call foo", x);

    emit Response(y);
  }
}

contract Caller_Translate {
  event Response(uint);

  // Errors
  error PreViolation(uint256 funcId);
  error PreViolationAddr(uint256 specId);
  error PostViolationAddr(uint256 specId);

  mapping(uint256 => function(uint256, uint256, string memory, uint)) _IReceiverFooPres;
  mapping(uint256 => function(uint256, uint256, string memory, uint, uint)) _IReceiverFooPosts;

  struct GuardedAddress {
    address _addr;
    // Note: if we use an array of functions here, we may have troubles with function types.
    // Correct me if I were wrong?
    uint256 _spec;
  }

  constructor() {
    _constructMapping();
  }

  function _constructMapping() internal {
    _IReceiverFooPres[1] = _PreSpec1;

    _IReceiverFooPosts[1] = _PostSpec1;
  }

  function testCallFoo(address payable addr, uint x) public payable {
    // Wrap up
    GuardedAddress memory _addr = GuardedAddress ({
      _addr: address(addr),
      _spec: 0
    });

    testCallFoo_Translate(_addr, x);
  }

  function _PreSpec1(uint256 v, uint256 g, string memory mymsg, uint x) internal {
    if (!(v > 5 && g < 10000 && x != 0)) { revert PreViolationAddr(1); }
  }

  function _PostSpec1(uint256 v, uint256 g, string memory mymsg, uint x, uint y) internal {
    if (!(y == x + 1)) { revert PostViolationAddr(1); }
  }

  // Note: this function is specially generated for IReceiver.foo
  function _IReceiverFooPre(GuardedAddress memory addr, uint256 v, uint256 g, string memory mymsg, uint x) internal {
    uint256 spec = addr._spec;
    while (spec != 0) {
      uint256 id = spec & (~spec + 1);
      _IReceiverFooPres[id](v, g, mymsg, x);
      spec -= id;
    }
  }

  // Note: this function is specially generated for IReceiver.foo
  function _IReceiverFooPost(GuardedAddress memory addr, uint256 v, uint256 g, string memory mymsg, uint x, uint y) internal {
    uint256 spec = addr._spec;
    while (spec != 0) {
      uint256 id = spec & (~spec + 1);
      _IReceiverFooPosts[id](v, g, mymsg, x, y);
      spec -= id;
    }
  }

  function _IReceiverFooGuardedCall(GuardedAddress memory addr, uint256 v, uint256 g, string memory mymsg, uint x) internal returns (uint y) {
    _IReceiverFooPre(addr, v, g, mymsg, x);
    y = IReceiver(payable(addr._addr)).foo{value: v, gas: g}(mymsg, x); 
    _IReceiverFooPost(addr, v, g, mymsg, x, y);
  }

  function _testCallFooPre(address payable addr, uint x) internal {
      if (!(x > 0)) { revert PreViolation(0); }
  }
 
  function testCallFoo_Translate(GuardedAddress memory addr, uint x) internal {
   addr._spec |= 1; // Note: update spec here

    _testCallFooPre(payable(addr._addr), x);
    uint y = _IReceiverFooGuardedCall(addr, msg.value, 5000, "call foo", x);
    emit Response(y);
  }
}
