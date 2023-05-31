pragma solidity ^0.8.9;
contract Caller {
  event Response(bool success, bytes data);

  // Let's imagine that contract Caller does not have the source code for the
  // contract Receiver, but we do know the address of contract Receiver and the function to call.

  /// @custom:consol { testCallFoo(addr, x) requires {x > 0} where { addr{value: v, gas: g}(mymsg, x) returns (flag, data) requires { v > 5 && g < 10000 && x != 0 } ensures { flag == true } } { addr.send(x) returns (b) requires { x < 1024 } ensures {b == true} }}
  function testCallFoo(address payable _addr, uint256 x) public payable {
    // You can send ether and specify a custom gas amount

    (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(
      abi.encodeWithSignature("foo(string, uint256)", "call foo", x)
    );

    bool res = _addr.send(x);

    emit Response(success, data);
  }

  // This one doesn't have value and gas

  /// @custom:consol { testCallFoo(addr, x) requires {x > 0} where { addr(mymsg, x) returns (flag, data) requires { v > 5 && g < 10000 && x != 0 } ensures { flag == true } }}
  function anotherTest(address payable _addr, int256 x) public payable {
    (bool success, bytes memory data) = _addr.call(
      abi.encodeWithSignature("foo(string, uint256)", "call foo", 456)
    );
    emit Response(success, data);
  }

}
