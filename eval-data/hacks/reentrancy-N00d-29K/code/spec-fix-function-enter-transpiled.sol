contract SushiBar is ERC20("n00d with X", "Xn00d"){
    using SafeMath for uint256;
    IERC20 public sushi;

    constructor(IERC20 _sushi) public {
        sushi = _sushi;
    }

    function _enter_post_condition(uint256 _amount) internal returns (bool) {
        return totalSupply() <= sushi.balanceOf(address(this));
    }

    function _enter_guard(uint256 _amount) internal {
        _enter_worker(_amount);
        require(_enter_post_condition(_amount));
    }

    // Enter the bar. Pay some SUSHIs. Earn some shares.
    // @custom:consol
    // function enter(_amount) returns ()
    //   ensures totalSupply() <= sushi.balanceOf(address(this))
    function _enter_worker(uint256 _amount) internal {
        uint256 totalSushi = sushi.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalSushi == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalSushi);
            _mint(msg.sender, what);
        }
        sushi.transferFrom(msg.sender, address(this), _amount);
    }

    function enter(uint256 _amount) external {
        _enter_guard(_amount);
    }

    function _leave_guard(uint256 _amount) internal {
        _leave_worker(_amount);
        require(_enter_post_condition(_amount));
    }

    // Leave the bar. Claim back your SUSHIs.
    // function leave(_share) returns ()
    //   ensures totalSupply() <= sushi.balanceOf(address(this))
    function _leave_worker(uint256 _share) internal {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(sushi.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        sushi.transfer(msg.sender, what);

        require(totalSupply() <= sushi.balanceOf(address(this)));
    }

    function leave(uint256 _amount) external {
        _leave_guard(_amount);
    }
}
