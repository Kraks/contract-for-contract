// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Example_ArgFun {
  // @custom:consol { foo(h) returns z |
  // requires:
  // where:
  //  { h(x) returns y |
  //    requires: x > 0
  //    ensures: y < 0
  //  }
  // ensures:
  //  z == 0
  function foo( function (int32) returns (int32) haa ) private returns (int32) {
    int32 x = haa(0);
    return x + 1;
  }
}

contract Example_ArgFun_Translated {

  function gt0(int32 x) private pure returns (bool) {
    return x > 0;
  }

  function lt0(int32 x) private pure returns (bool) {
    return x < 0;
  }

  function eq0(int32 x) private pure returns (bool) {
    return x == 0;
  }

  // Note: codom should take an additional argument, since the codom
  // can depend on the function argument.
  struct Spec_int32_int32 {
    function (int32) returns (bool) dom;
    function (int32) returns (bool) codom;
  }

  struct Guarded_int32_int32 {
    Spec_int32_int32 spec;
    function (int32) returns (int32) f;
  }

  function apply_Guarded_int32_int32(Guarded_int32_int32 memory gf, int32 x) private returns (int32) {
    require(gf.spec.dom(x), "argument value error");
    int32 y = gf.f(x);
    require(gf.spec.codom(y), "return value error");
    return y;
  }

  // In the original function, we need to change the introduction and elimination form,
  // i.e., the type when introducing the function, and how we apply the function
  function foo_original( Guarded_int32_int32 memory haa ) private returns (int32) {
    int32 x = apply_Guarded_int32_int32(haa, 0);
    return x + 1;
  }

  function foo( function (int32) returns (int32) haa ) private returns (int32) {
    int32 ret = foo_original(Guarded_int32_int32(Spec_int32_int32(gt0, lt0), haa));
    require(eq0(ret), "return value error");
    return ret;
  }

}
