// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Lock {
    /// @custom:consol {Withdrawal(amount, when) requires {amount>0} }
    event Withdrawal(uint256 amount, uint256 when);

    /// regular comment
    uint256 public unlockTime;
    address payable public owner;

    /// @custom:consol {constructor(_unlockTime) requires {_unlockTime>0 && block.timestamp < _unlockTime}}
    constructor(uint256 _unlockTime) payable {
        require(_unlockTime > 0, "unlockTime must be greater than 0");
        require(block.timestamp < _unlockTime, "Unlock time should be in the future");
        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    /// @custom:consol  {withdraw () requires {block.timestamp >= unlockTime} }
    function withdraw() public{
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        emit Withdrawal(address(this).balance, block.timestamp);
        owner.transfer(address(this).balance);
    }
}


contract Lock_Translated {
    /// @custom:consol {Withdrawal(amount, when) requires {amount>0} }
    event Withdrawal(uint256 amount, uint256 when);
    
    /// regular comment
    uint256 public unlockTime;
    address payable public owner;


    function constructorPre(uint256 _unlockTime) private view returns (bool){
        return _unlockTime>0 && block.timestamp < _unlockTime;
    }

    /// @custom:consol {constructor(_unlockTime) requires {_unlockTime>0 && block.timestamp < _unlockTime}}
    // TODO: this should be private
    function constructor_original(uint256 _unlockTime) private {
        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    constructor(uint256 _unlockTime) payable {
        require(constructorPre(_unlockTime), "lll");
        constructor_original(_unlockTime);
    }

    





    function withdrawPre() private view returns (bool){
        return block.timestamp >= unlockTime;
    }


    /// @custom:consol  {withdraw () requires {block.timestamp >= unlockTime} }
    function withdraw_original() private{
        emit Withdrawal(address(this).balance, block.timestamp);
        owner.transfer(address(this).balance);
    }

    function withdraw() public{
        require(withdrawPre(), "hahaha");
        withdraw_original();
    }
}