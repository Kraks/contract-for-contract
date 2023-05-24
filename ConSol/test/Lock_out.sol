pragma solidity ^0.8.9;

contract Lock {
    /// custom:consol {Withdrawal (amount, w) requires {amount>0} }
    event Withdrawal(uint256 amount, uint256 when);

    /// regular comment
    uint256 public unlockTime;
    address payable public owner;

    /// custom:consol {constructor(_unlockTime) requires {_unlockTime>0 && block.timestamp < _unlockTime}}
    constructor(uint256 _unlockTime) payable {
        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    /// custom:consol  {withdraw () requires {block.timestamp >= unlockTime} }
    function withdraw() public {
        emit Withdrawal(address(this).balance, block.timestamp);
        owner.transfer(address(this).balance);
    }

    /// @custom:consol  {getSum (a, b) returns (c,d ) requires {a>0 && b>0} ensures{c>0} }
    function getSum_original(int256 a, int256 b) private pure returns (int256, int256) {
        return (a + b, a);
    }

    function _getSumPre(int256 a, int256 b) public returns (bool) {
        return true;
    }

    function _getSumPost(int256 a, int256 b, int256 c, int256 d) public returns (bool) {
        return true;
    }

    function getSum(int256 a, int256 b) public pure returns (int256 c, int256 d) {
        require(_getSumPre(a, b), "Violate the preondition for function getSum");
        int256 c = getSum_original(a, b);
        require(_getSumPost(a, b, c, d), "Violate the postondition for function getSum");
        return (c, d);
    }
}