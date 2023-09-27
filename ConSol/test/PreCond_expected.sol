pragma solidity ^0.8.9;

contract C {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    uint256 public balance;

    /// @custom:consol {
    ///    withdraw (amt) requires {
    ///      amt > 0.5
    ///    }
    ///  }
    function withdraw_original(uint256 amount) private {
        balance = balance - amount;
    }

    function _withdraw_pre(uint256 amt) private {
        if (!(amt>0.5)) revert preViolation("withdraw");
    }

    function withdraw(uint256 amount) public {
        _withdraw_pre(amount);
        withdraw_original(amount);
    }
}
