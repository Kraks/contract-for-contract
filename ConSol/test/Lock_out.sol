pragma solidity ^0.8.9;

contract Lock {
    /// @custom:consol testtitle
    event Withdrawal(uint256 amount, uint256 when);

    uint256 public unlockTime;
    address payable public owner;

    constructor(uint256 _unlockTime) payable {
        require(block.timestamp < _unlockTime, "Unlock time should be in the future");
        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    function withdraw() public {
        /// @custom:consol  test multi-lines
        /// second-line
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        emit Withdrawal(address(this).balance, block.timestamp);
        owner.transfer(address(this).balance);
    }
}