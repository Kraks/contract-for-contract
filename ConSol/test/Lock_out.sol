pragma solidity ^0.8.9;

contract Lock {
    error preViolation(string memory funcName);

    error postViolation(string memory funcName);

    /// custom:consol {Withdrawal (amount, w) requires {amount>0} }
    event Withdrawal(uint256 amount, uint256 when);

    /// regular comment
    uint256 public unlockTime;
    address payable public owner;

    /// @custom:consol {constructor(_unlockTime) requires {_unlockTime>0 && block.timestamp < _unlockTime}}
    function constructor_original(uint256 _unlockTime) private payable {
        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    /// @custom:consol  {withdraw () requires {block.timestamp >= unlockTime} }
    function withdraw_original() private {
        emit Withdrawal(address(this).balance, block.timestamp);
        owner.transfer(address(this).balance);
    }

    /// @custom:consol  {getSumNoRet (not_the_same_name, metoo)requires {not_the_same_name>0 && metoo>0}}
    function getSumNoRet_original(int256 a, int256 b) private pure {
        int256 c = a + b;
    }

    /// @custom:consol  {getSum (a, b) returns (c) requires {a>0 && b>0}}
    function getSum_original(int256 a, int256 b) private pure returns (int256) {
        return a + b;
    }

    /// @custom:consol  {getSum2Ret (a, b) returns (c,d ) requires {a>0 && b>0} ensures{c>0} }
    function getSum2Ret_original(int256 a, int256 b) private pure returns (int256, int256) {
        return (a + b, a - b);
    }

    function _constructorPre(uint256 _unlockTime) private {
        if (!_unlockTime>0&&block.timestamp<_unlockTime) revert preViolation(0);
    }

    constructor(uint256 _unlockTime) payable {
        _constructorPre(_unlockTime);
        constructor_original(_unlockTime);
    }

    function _withdrawPre() private {
        if (!block.timestamp>=unlockTime) revert preViolation(0);
    }

    function withdraw() public {
        _withdrawPre();
        withdraw_original();
    }

    function _getSumNoRetPre(int256 not_the_same_name, int256 metoo) private {
        if (!not_the_same_name>0&&metoo>0) revert preViolation(0);
    }

    function getSumNoRet(int256 a, int256 b) public pure {
        _getSumNoRetPre(a, b);
        getSumNoRet_original(a, b);
    }

    function _getSumPre(int256 a, int256 b) private {
        if (!a>0&&b>0) revert preViolation(0);
    }

    function getSum(int256 a, int256 b) public pure returns (int256) {
        _getSumPre(a, b);
        int256 c = getSum_original(a, b);
        return (c);
    }

    function _getSum2RetPre(int256 a, int256 b) private {
        if (!a>0&&b>0) revert preViolation(0);
    }

    function _getSum2RetPost(int256 a, int256 b, int256 c, int256 d) private {
        if (!c>0) revert postViolation(0);
    }

    function getSum2Ret(int256 a, int256 b) public pure returns (int256, int256) {
        _getSum2RetPre(a, b);
        (int256 c, int256 d) = getSum2Ret_original(a, b);
        _getSum2RetPost(a, b, c, d);
        return (c, d);
    }
}