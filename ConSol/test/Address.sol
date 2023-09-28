// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IReceiver {
  function foo(string memory _message, uint _x) external payable returns (uint);
}

contract Caller {
  event Response(uint);

  struct Vault {
    address creator;
    string name;
    address users;
    uint amount;
  }

  // Let's imagine that contract Caller does not have the source code for the
  // contract Receiver, but we do know the address of contract Receiver and the
  // function to call as well as the interface of contract Receiver.

  /// @custom:consol { callFoo(addr, x)
  ///   requires {x > 0}
  ///   where {
  ///     IReceiver(addr).foo{value: v, gas: g}(mymsg, x) returns (y)
  ///     requires { v > 5 && g < 10000 && x != 0 }
  ///     ensures { y == x + 1 }
  ///   }
  /// }
  function callFoo(Vault memory v, address payable _addr, uint x) public payable {
    // You can send ether and specify a custom gas amount
    uint y = IReceiver(_addr).foo{value: msg.value, gas: 5000}("call foo", x);

    emit Response(y);
  }
}

