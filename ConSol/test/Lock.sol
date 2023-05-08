// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Lock {
    /// regular comment
    uint256 public unlockTime;
    address payable public owner;

    /// @custom:consol.js {amount | amount > 0}
    event Withdrawal(uint256 amount, uint256 when);

    /// @custom:consol.js {_unlockTime | _unlockTime > 0}
    /// @dev ualadfskf
    /// @custom:consol.js part2
    constructor(uint256 _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    /// @custom:consol.js {msg.sender | msg.sender ==owner}
    function withdraw() public {
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        // require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}
