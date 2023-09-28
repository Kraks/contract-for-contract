// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract C {
  /// @custom:consol {
  ///   f(a, b) returns c1 ensures { c1 > a + b }
  /// }
  function f(uint256 a, uint256 b) public returns (uint256) {
    return a + b;
  }

  /// @custom:consol {
  ///   g(a, b) returns (c2) ensures { c2 > a * b }
  /// }
  function g(uint256 a, uint256 b) public returns (uint256) {
    return a * b;
  }

  /// @custom:consol {
  ///   h(a, b) returns (c3, d) ensures { c3 + d == (a * b) + (a + b) }
  /// }
  function h(uint256 a, uint256 b) public returns (uint256, uint256) {
    return (a * b, a + b);
  }

  // Note: there is a minor issue when writing nomial returned values,
  // those names (e.g. c, d, e) may not be fresh in the function body...

  /// @custom:consol {
  ///   p(a, b) returns (c4, d, e) ensures { (c4 + d) * e == (a * b) + (a + b) }
  /// }
  function p(uint256 a, uint256 b) public returns (uint256, uint256, uint256) {
    return (a * b, a + b, 1);
  }
}
