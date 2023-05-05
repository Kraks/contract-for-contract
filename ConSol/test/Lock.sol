// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Lock {
    /// @custom:consol {unlockTime |true}
    uint256 public unlockTime;
    address payable public owner;

    /// @custom:consol {amount | amount > 0}
    event Withdrawal(uint256 amount, uint256 when);

    /// @custom:consol {_unlockTime | _unlockTime > 0}
    constructor(uint256 _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    /// @custom:consol {msg.sender | msg.sender ==owner}
    function withdraw() public {
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        // require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}
