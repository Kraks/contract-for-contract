// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Lock {
    /// regular comment
    uint256 public unlockTime;
    address payable public owner;

    /// @custom:consol { Withdrawal(amount, when) requires { amount > 0 } }
    event Withdrawal(uint256 amount, uint256 when);

    /// @custom:consol { constructor(t) requires { t > 0 } }
    constructor(uint256 _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    /// @custom:consol { withdraw() requires { msg.sender == owner } }
    function withdraw() public {
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        // require(msg.sender == owner, "You aren't the owner");

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance);
    }
}
