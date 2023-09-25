pragma solidity ^0.8.9;

contract C {
    error preViolation(string memory funcName);

    error postViolation(string memory funcName);

    error PreViolationAddr(uint256 specId);

    error PostViolationAddr(uint256 specId);

    uint256 public balance;

    /// @custom:consol {
    ///    withdraw (amt) requires {
    ///      amt > 0.5
    ///    }
    ///  }
    function withdraw_original(uint256 amount) private {
        balance = balance - amount;
    }

    function _withdrawPre(uint256 amt) private {
        if (!amt>0.5) revert preViolation("withdraw");
    }

    function withdraw(uint256 amount) public {
        _withdrawPre(amount);
        withdraw_original(amount);
    }
}
