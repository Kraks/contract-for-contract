// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IReceiver {
  function foo(string memory _message, uint _x) external payable returns (uint);
}

contract Caller {
  event Response(uint);

  // Let's imagine that contract Caller does not have the source code for the
  // contract Receiver, but we do know the address of contract Receiver and the
  // function to call as well as the interface of contract Receiver.

  /// @dev { callFoo(_addr, x) returns (y)
  ///   requires {x > 0}
  /// }
  function callFoo(address payable _addr, uint x) public payable returns (uint) {
    // call without options
    uint z = IReceiver(_addr).foo("call foo", x);
    // You can send ether and specify a custom gas amount
    uint y = IReceiver(_addr).foo{value: msg.value, gas: 5000}("call foo", x);

    emit Response(x);
    return x;
  }
}
