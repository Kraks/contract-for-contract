pragma solidity 0.8.10;

contract SushiBar{
    // using SafeMath for uint256;
    // IERC20 public sushi;

    // constructor(IERC20 _sushi) public {
    //     sushi = _sushi;
    // }

    // Enter the bar. Pay some SUSHIs. Earn some shares.
    /// @custom:consol {enter(_amount) returns () ensures {totalSupply() <= sushi.balanceOf(address(this))}}
    function enter(uint256 _amount) public {
        return;
        // uint256 totalSushi = sushi.balanceOf(address(this));
        // uint256 totalShares = totalSupply();
        // if (totalShares == 0 || totalSushi == 0) {
        //     _mint(msg.sender, _amount);
        // } else {
        //     uint256 what = _amount.mul(totalShares).div(totalSushi);
        //     _mint(msg.sender, what);
        // }
        // sushi.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your SUSHIs.
    /// @custom:consol {leave(_share) returns () ensures {totalSupply() <= sushi.balanceOf(address(this))}}
    function leave(uint256 _share) public {
        return;
        // uint256 totalShares = totalSupply();
        // uint256 what = _share.mul(sushi.balanceOf(address(this))).div(totalShares);
        // _burn(msg.sender, _share);
        // sushi.transfer(msg.sender, what);
    }
}
