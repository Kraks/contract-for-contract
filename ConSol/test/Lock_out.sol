pragma solidity ^0.8.9;

contract Lock {
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

    /// @custom:consol  {getSumNoRet (a, b)requires {a>0 && b>0}}
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

    function _constructorPre(uint256 _unlockTime) public returns (bool) {
        return any thing I want;
    }

    constructor(uint256 _unlockTime) payable {
        require(_constructorPre(_unlockTime), "Violate the preondition for function constructor");
        constructor_original(_unlockTime);
    }

    function _withdrawPre() public returns (bool) {
        return any thing I want;
    }

    function withdraw() public {
        require(_withdrawPre(), "Violate the preondition for function withdraw");
        withdraw_original();
    }

    function _getSumNoRetPre(int256 a, int256 b) public returns (bool) {
        return any thing I want;
    }

    function getSumNoRet(int256 a, int256 b) public pure {
        require(_getSumNoRetPre(a, b), "Violate the preondition for function getSumNoRet");
        getSumNoRet_original(a, b);
    }

    function _getSumPre(int256 a, int256 b) public returns (bool) {
        return any thing I want;
    }

    function getSum(int256 a, int256 b) public pure returns (int256 c) {
        require(_getSumPre(a, b), "Violate the preondition for function getSum");
        int256 c = getSum_original(a, b);
        return (c);
    }

    function _getSum2RetPre(int256 a, int256 b) public returns (bool) {
        return any thing I want;
    }

    function _getSum2RetPost(int256 a, int256 b, int256 c, int256 d) public returns (bool) {
        return any thing I want;
    }

    function getSum2Ret(int256 a, int256 b) public pure returns (int256 c, int256 d) {
        require(_getSum2RetPre(a, b), "Violate the preondition for function getSum2Ret");
        (int256 c, int256 d) = getSum2Ret_original(a, b);
        require(_getSum2RetPost(a, b, c, d), "Violate the postondition for function getSum2Ret");
        return (c, d);
    }
}