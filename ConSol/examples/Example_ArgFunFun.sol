// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Example_ArgFunFun {
  function foo(int32 x) private pure returns (int32) {
    return x + 1;
  }

  // @custom:consol { gee(h) returns gee_ret |
  // requires:
  // where:
  //   { h(f) returns h_ret |
  //     requires:
  //     where:
  //       { f(x) returns y |
  //         requires: x > 0
  //         ensures: y < 0
  //       }
  //     ensures:
  //       h_ret == 0
  //   }
  // ensures:
  //   gee_ret + 1 > 0
  // }
  function gee( function (function (int32) returns (int32)) returns (int32) h ) private returns (int32) {
    int32 z = h(foo);
    // using z...
    return z + 1;
  }

  function tee(function (int32) returns (int32) h) private returns (int32) {
    return h(0) + 1;
  }

  // now suppose some function uses gee
  // we must know the argument passed to gee *within* this contract
  function cool() private {
    gee(tee);
  }
}

contract Example_ArgFunFun_Translated {
  // unchanged, no spec attached
  function foo(int32 x) private pure returns (int32) {
    return x + 1;
  }

  function gt0(int32 x) private pure returns (bool) {
    return x > 0;
  }

  function lt0(int32 x) private pure returns (bool) {
    return x < 0;
  }

  function eq0(int32 x) private pure returns (bool) {
    return x == 0;
  }

  function plus1_gt0(int32 x) private pure returns (bool) {
    return x + 1 > 0;
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

  struct Spec_int32_int32_int32 {
    Spec_int32_int32 dom;
    function (int32) returns (bool) codom;
  }

  struct Guarded_int32_int32_int32 {
    Spec_int32_int32_int32 spec;
    function (Guarded_int32_int32 memory) returns (int32) f;
    //function (function (int32) returns (int32)) returns (int32) f;
  }

  function apply_Guarded_int32_int32_int32(
    Guarded_int32_int32_int32 memory h,
    function (int32) returns (int32) arg
  ) private returns (int32) {
    // Problem: we cannot just pass a Guarded_int32_int32 into h's underlying function,
    // unless we can transform the underlying function h.f too, which in this case is `tee`.
    int32 ret = h.f(Guarded_int32_int32(h.spec.dom, arg));
    require(h.spec.codom(ret), "return value error");
    return ret;
  }

  function gee_original(Guarded_int32_int32_int32 memory h) private returns (int32) {
    int32 z = apply_Guarded_int32_int32_int32(h, foo);
    // using z ...
    return z + 1;
  }

  function gee( function (Guarded_int32_int32 memory) returns (int32) h ) private returns (int32) {
    int32 ret = gee_original(Guarded_int32_int32_int32(
      Spec_int32_int32_int32(
        Spec_int32_int32(gt0, lt0),
        eq0),
      h));
    require(plus1_gt0(ret), "return value error");
    return ret;
  }

  // tee needs to be updated
  // XXX: be careful if tee is called via other path, so an ungarded version should be used in that case.
  function tee(Guarded_int32_int32 memory h) private returns (int32) {
    return apply_Guarded_int32_int32(h, 0) + 1;
  }

  function cool() private {
    gee(tee);
  }

}
