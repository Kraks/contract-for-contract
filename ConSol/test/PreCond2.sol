// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract C {
    uint256 public balance;
    // We allow using storage variables in specifications
    uint256 private min;

    /// @custom:consol {
    ///   withdraw (amt) requires {
    ///     amt >= min
    ///   }
    /// }
    function withdraw(uint256 amount) public{
      balance = balance - amount;
    }
}
