// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract C {
  /// @custom:consol {
  ///   f(a, b) returns c ensures { c > a + b }
  /// }
  function f(uint256 a, uint256 b) public returns (uint256) {
    return a + b;
  }

  /// @custom:consol {
  ///   g(a, b) returns (c) ensures { c > a * b }
  /// }
  function g(uint256 a, uint256 b) public returns (uint256) {
    return a * b;
  }

  /// @custom:consol {
  ///   h(a, b) returns (c, d) ensures { c + d == (a * b) + (a + b) }
  /// }
  function h(uint256 a, uint256 b) public returns (uint256, uint256) {
    return (a * b, a + b);
  }

  // Note: there is a minor issue when writing nomial returned values,
  // those names (e.g. c, d, e) may not be fresh in the function body...

  /// @custom:consol {
  ///   p(a, b) returns (c, d, e) ensures { (c + d) * e == (a * b) + (a + b) }
  /// }
  function p(uint256 a, uint256 b) public returns (uint256, uint256, uint256) {
    return (a * b, a + b, 1);
  }
}
