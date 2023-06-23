
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

  function id(address payable a) private pure returns (address payable)  { return a; }

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
    /*
    Now we have a call to whoow, but we don't how what it is statically.
    So in the translated code, we will have a mapping that records addresses to functions,
    and this call-site will be translated to lookup of that mapping to find the right guard function.
    This approach should work in principle, but only when this address call is ``indirect'' due to the overhead (how much??).
    By "indirect", we mean those address calls that potentially should be guarded but we cannot
    be certain about which guard should be used by syntactically analyzing the program.
    Consider another example:
      address addr = select_one_based_on_dynamic_cond(addr1, addr2)
      addr.call(...)
    where both addr1 and addr2 have their own specifications from the user.
    For direct address calls, we can just rewrite the call-sites to guarded functions (see Address.sol).
    */
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
          returns (bool, bytes memory))[] stackedDispatchMap;

  mapping(address => bool)[] private stackedIsSet;

  // Note(GW): this function only handles `call`, for other members of addresses
  // we need other "dispatch" functions since their types are different
  function dispatchCallGuard(address payable addr, uint256 v, uint256 g,
                        string memory mymsg, uint256 x)
                        private
                        returns (bool, bytes memory) {
    if (stackedIsSet[stackedIsSet.length-1][addr])
      return stackedDispatchMap[stackedDispatchMap.length-1][addr](addr, v, g, mymsg, x);
    else return addr.call{value: v, gas: g}(
      abi.encodeWithSignature("foo(string, uint256)", mymsg, x)
    );
  }

  // Note(GW): using a stack of mappings that records the address guards
  // following the call stack, we should be able to 1) enforce
  // checks under the current calling context (eg _addr is called in `id`),
  // and 2) layer checks for the same address.
  // In this way, we do not enforce guards of escaped address, thus
  // the enforcement is second-class.
  function testCallFoo(address payable _addr, int256) private {
    stackedIsSet.push();
    stackedIsSet[stackedIsSet.length-1][_addr] = true;
    stackedDispatchMap.push();
    stackedDispatchMap[stackedDispatchMap.length-1][_addr] = guardedCall1;
    address payable whoow = id(_addr);
    (bool success, bytes memory data) = dispatchCallGuard(whoow, msg.value, 5000, "call foo", 123);

    emit Response(success, data);
    stackedIsSet.pop();
    stackedDispatchMap.pop();
    // GW: so here we set up the monitoring/checking following
    // a stack discipline.
  }

}


