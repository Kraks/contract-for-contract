pragma solidity ^0.8.9;

contract Lock {
    /// @custom:consol {Withdrawal (amount, w) requires {amount>0} }
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
    function withdraw() public {
        emit Withdrawal(address(this).balance, block.timestamp);
        owner.transfer(address(this).balance);
    }

    function _constructorPre(uint256 _unlockTime) public returns (bool) {
        return true;
    }

    function _withdrawPre() public returns (bool) {
        return true;
    }
}