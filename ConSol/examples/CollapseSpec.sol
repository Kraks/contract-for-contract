// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Spec {
  struct Spec_int32_int32 {
    function (int32) returns (bool)[] dom;
    function (int32) returns (bool) codom;
    string label;
  }

  function lt0(int32 x) private returns (bool) { return x < 0; }

  function gt0(int32 x) private returns (bool) { return x > 0; }

  function create(uint n) private {
      function (int32) returns (bool)[] memory doms = new function (int32) returns (bool)[](2);
      Spec_int32_int32 memory s = Spec_int32_int32(doms, lt0, "label");
  }

  struct Guarded_int32_int32 {
    Spec_int32_int32[] specs;
    function (int32) returns (int32) f;
  }

  /*
  function apply_Guarded_int32_int32(Guarded_int32_int32 memory gf, int32 x) returns (int32) {
      for (int i = 0; i < gf.specs.length; i++) {
          require(gf.specs[i].dom)
      }
  }
  */
}
