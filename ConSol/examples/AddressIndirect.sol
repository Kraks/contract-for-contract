
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

  function id(address a) private pure returns (address)  { return a; }

  // Let's imagine that contract Caller does not have the source code for the
  // contract Receiver, but we do know the address of contract Receiver and the function to call.

  // @custom:consol { testCallFoo(addr, x)
  // where
  //   {
  //     addr{value: v, gas: g}(mymsg, x) returns (flag, data)
  //     requires { v > 5 && g < 10000 && x != 0 }
  //     ensures { flag == true }whoow
  //   }
  // }
  function testCallFoo(address payable _addr, int256 x) public payable {
    // You can send ether and specify a custom gas amount
    address whoow = id(_addr);
    // now we have a call to whoow, but we don't how what it is statically
    (bool success, bytes memory data) = whoow.call{value: msg.value, gas: 5000}(
      abi.encodeWithSignature("foo(string, uint256)", "call foo", 123 + x)
    );

    emit Response(success, data);
  }
}

contract Caller_Translated {
  event Response(bool success, bytes data);

  function id(address payable a) private pure returns (address payable)  { return a; }

  function guardedCall1(address payable addr, uint256 v, uint256 g,
                        string memory mymsg, uint256 x)
                        private
                        returns (bool, bytes memory) {
    // Note: alternatively, we could life the expressions in `require` into separate functions,
    // but it seems unnecessary
    require(v > 5 && g < 10000 && x != 0, "pre cond violates");
    (bool flag, bytes memory data) = addr.call{value: v, gas: g}(
      abi.encodeWithSignature("foo(string, uint256)", mymsg, x)
    );
    require(flag == true, "post cond violates");
    return (flag, data);
  }

  mapping(address =>
          function(address payable, uint256, uint256, string memory, uint256)
          returns (bool, bytes memory)) private dispatchMap;

  // Note(GW): this function only handles `call`, for other members of addresses
  // we need other "dispatch" functions since their types are different
  function dispatchCallGuard(address payable addr, uint256 v, uint256 g,
                        string memory mymsg, uint256 x)
                        private
                        returns (bool, bytes memory) {
    return dispatchMap[addr](addr, v, g, mymsg, x);
  }

  function testCallFoo(address payable _addr, int256) private {
    dispatchMap[_addr] = guardedCall1;
    address payable whoow = id(_addr);
    (bool success, bytes memory data) = dispatchCallGuard(whoow, msg.value, 5000, "call foo", 123);

    emit Response(success, data);
  }

}

