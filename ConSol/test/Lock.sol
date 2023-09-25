// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Lock {
    /// custom:consol {Withdrawal (amount, w) requires {amount>0} }
    event Withdrawal(uint256 amount, uint256 when);

    /// regular comment
    uint256 public unlockTime;
    address payable public owner;

    /// @custom:consol {constructor(_unlockTime) requires {_unlockTime>0 && block.timestamp < _unlockTime}}
    constructor(uint256 _unlockTime) payable {
        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    /// @custom:consol  {withdraw () requires {block.timestamp >= unlockTime} }
    function withdraw() public{
        emit Withdrawal(address(this).balance, block.timestamp);
        owner.transfer(address(this).balance);
    }

    /// @custom:consol  {getSumNoRet (not_the_same_name, metoo)requires {not_the_same_name>0 && metoo>0}}
    function getSumNoRet(int256 a, int256 b) public pure {
        int256 c = a+b;
    }


    /// @custom:consol  {getSum (a, b) returns (c) requires {a>0 && b>0}}
    function getSum(int256 a, int256 b) public pure returns (int256) {
        return a + b;
    }


    /// @custom:consol  {getSum2Ret (a, b) returns (c,d) requires {a>0 && b>0} ensures{c>0} }
    function getSum2Ret(int256 a, int256 b) public pure returns (int256, int256) {
        return (a + b , a - b);
    }
}
