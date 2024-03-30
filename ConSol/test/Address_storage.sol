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

  // TODO: test return address

  /// @custom:consol {non_addr_var{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v==100 } ensures { data == true }}
  uint160 non_addr_var;
  /// @custom:consol {testaddr{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v==100 } ensures { data == true }}
  address testaddr;

  /// @custom:consol {testaddr2{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v==200 }}
  address testaddr2 = 0x86392dC19c0b719886221c78AB11eb8Cf5c52812;

  function callFoo(uint x) public payable returns (uint) {
    // call without options
    uint z = IReceiver(testaddr).foo("call foo", x);
    // You can send ether and specify a custom gas amount
    uint y = IReceiver(testaddr2).foo{value: msg.value, gas: 5000}("call foo", x);

    emit Response(y);
    return y;
  }
}
