pragma solidity 0.8.10;

contract SushiBar {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    /// @custom:consol {enter(_amount) returns () ensures {totalSupply() <= sushi.balanceOf(address(this))}}
    function enter_original(uint256 _amount) private {
        return;
    }

    /// @custom:consol {leave(_share) returns () ensures {totalSupply() <= sushi.balanceOf(address(this))}}
    function leave_original(uint256 _share) private {
        return;
    }

    function _enter_post(uint256 _amount) private {
        if (!(totalSupply()<=sushi.balanceOf(address(this)))) revert postViolation("enter");
    }

    function enter(uint256 _amount) public {
        enter_original(_amount);
        _enter_post(_amount);
    }

    function _leave_post(uint256 _share) private {
        if (!(totalSupply()<=sushi.balanceOf(address(this)))) revert postViolation("leave");
    }

    function leave(uint256 _share) public {
        leave_original(_share);
        _leave_post(_share);
    }
}