
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

contract Caller {
  event Response(bool success, bytes data);

  // Let's imagine that contract Caller does not have the source code for the
  // contract Receiver, but we do know the address of contract Receiver and the function to call.

  // @custom:consol { testCallFoo(addr)
  // where
  //   {
  //     addr{value: v, gas: g}(mymsg, x) returns (flag, data)
  //     requires { v > 5 && g < 10000 && x != 0 }
  //     ensures { flag == true }
  //   }
  // }
  function testCallFoo(address payable _addr) public payable {
    // You can send ether and specify a custom gas amount
    (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(
      abi.encodeWithSignature("foo(string, uint256)", "call foo", 123)
    );

    emit Response(success, data);
  }
}

contract Call_Translated {
  event Response(bool success, bytes data);

  function guardedCall(address payable addr, uint256 v, uint256 g,
                       string memory mymsg, uint256 x)
                       private
                       returns (bool, bytes memory)
                       {
    // Note: alternatively, we could life the expressions in `require` into separate functions,
    // but it seems unnecessary
    require(v > 5 && g < 10000 && x != 0, "pre cond violates");
    (bool flag, bytes memory data) = addr.call{value: v, gas: g}(
      abi.encodeWithSignature("foo(string, uint256)", mymsg, x)
    );
    require(flag == true, "post cond violates");
    return (flag, data);
  }

  function testCallFoo(address payable _addr) public payable {
    (bool success, bytes memory data) = guardedCall(_addr, msg.value, 5000, "call foo", 123);

    emit Response(success, data);
  }
}
