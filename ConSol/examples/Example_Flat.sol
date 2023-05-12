// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Example_Flat {
  // @custom:consol { foo(x) returns (y) |
  // requires:
  //   x < 0
  // ensures:
  //   y > 0
  // }
  function foo(int32 x) private pure returns (int32) {
    return -x;
  }
}

contract Example_Flat_Translated {

  function gt0(int32 x) private pure returns (bool) {
    return x > 0;
  }

  function lt0(int32 x) private pure returns (bool) {
    return x < 0;
  }

  function foo_original(int32 x) private pure returns (int32) {
    return -x;
  }

  function foo(int32 x) private pure returns (int32) {
    require(lt0(x), "wrong argument value");
    int32 ret = foo_original(x);
    require(gt0(ret), "wrong return value");
    return ret;
  }
}
