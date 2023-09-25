// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract C {
    uint256 public balance;

    /// @custom:consol {
    ///   withdraw (amt) requires {
    ///     amt > 0.5
    ///   }
    /// }
    function withdraw(uint256 amount) public{
      balance = balance - amount;
    }
}
