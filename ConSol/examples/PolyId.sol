// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*

contract Example_PolyId {

  // ....
  function id1(function (int32) returns (int32) f) private returns (function (int32) returns (int32)) {
    return f;
  }
  function id2(function (int32) returns (int32) f) private returns (function (int32) returns (int32)) {
    return f;
  }

  Guarded_int32_int32 k = id(f)

  ////////////////////////////////////

  Guarded_int32_int32 f2 = id2(Guarded_int32_int32(spec2, f));
  Guarded_int32_int32 f1 = id1(Guarded_int32_int32(spec1, f2));

  Guarded_int32_int32 f1 = id1(Guarded_int32_int32(spec1, Guarded_int32_int32(spec2, f)));
  Guarded_int32_int32 f1 = id1(Guarded_int32_int32(spec1 + f2.spec, f2.f)));


  // f | pre1 -> post1
  function id1(Guarded_int32_int32 f) private returns (Guarded_int32_int32) {
    return f;
  }
  // f | pre2 -> post2
  function id2(Guarded_int32_int32 f) private returns (Guarded_int32_int32) {
    return f;
  }

  struct Spec_int32_int32 {
    function (int32) returns (bool) dom;
    function (int32) returns (bool) codom;
  }

  struct Guarded_int32_int32 {
    Spec_int32_int32 spec;
    function (int32) returns (int32) f;
  }


}
*/
