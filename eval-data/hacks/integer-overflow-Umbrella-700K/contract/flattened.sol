//SPDX-License-Identifier: MIT
pragma solidity <0.8.0 =0.7.5 >=0.6.0 >=0.6.2;

// src/@openzeppelin/contracts/math/Math.sol

library Math {

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// src/@openzeppelin/contracts/math/SafeMath.sol

library SafeMath {

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }


    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }


    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// src/@openzeppelin/contracts/token/ERC20/IERC20.sol

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// src/@openzeppelin/contracts/utils/Address.sol

library Address {

    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }


    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }


    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// src/@openzeppelin/contracts/utils/Context.sol


abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// src/@openzeppelin/contracts/utils/ReentrancyGuard.sol

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// src/interfaces/IBurnableToken.sol

interface IBurnableToken {
    function burn(uint256 _amount) external;
}

// src/interfaces/IStakingRewards.sol

interface IStakingRewards {
    // Mutative
    function stake(uint256 amount) external;

    function withdraw(uint256 amount) external;

    function getReward() external;

    function exit() external;
    // Views
    function lastTimeRewardApplicable() external view returns (uint256);

    function rewardPerToken() external view returns (uint256);

    function earned(address account) external view returns (uint256);

    function getRewardForDuration() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

}

// src/@openzeppelin/contracts/access/Ownable.sol

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// src/interfaces/Owned.sol

abstract contract Owned is Ownable {
    constructor(address _owner) {
        transferOwnership(_owner);
    }
}

// src/@openzeppelin/contracts/token/ERC20/ERC20.sol

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;


    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }


    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }


    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }


    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// src/@openzeppelin/contracts/token/ERC20/SafeERC20.sol

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// src/interfaces/Pausable.sol

// Inheritance

abstract contract Pausable is Owned {
    bool public paused;

    event PauseChanged(bool isPaused);

    modifier notPaused {
        require(!paused, "This action cannot be performed while the contract is paused");
        _;
    }

    constructor() {
        // This contract is abstract, and thus cannot be instantiated directly
        require(owner() != address(0), "Owner must be set");
        // Paused will be false
    }

    function setPaused(bool _paused) external onlyOwner {
        // Ensure we're actually changing the state before we do anything
        if (_paused == paused) {
            return;
        }

        // Set our paused state.
        paused = _paused;

        // Let everyone know that our pause state has changed.
        emit PauseChanged(paused);
    }
}

// src/interfaces/RewardsDistributionRecipient.sol

// Inheritance

// https://docs.synthetix.io/contracts/RewardsDistributionRecipient
abstract contract RewardsDistributionRecipient is Owned {
    address public rewardsDistribution;

    modifier onlyRewardsDistribution() {
        require(msg.sender == rewardsDistribution, "Caller is not RewardsDistributor");
        _;
    }

    function notifyRewardAmount(uint256 reward) virtual external;

    function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
        rewardsDistribution = _rewardsDistribution;
    }
}

// src/interfaces/MintableToken.sol

/// @author  umb.network
abstract contract MintableToken is Owned, ERC20, IBurnableToken {
    uint256 public immutable maxAllowedTotalSupply;
    uint256 public everMinted;

    modifier assertMaxSupply(uint256 _amountToMint) {
        _assertMaxSupply(_amountToMint);
        _;
    }

    // ========== CONSTRUCTOR ========== //

    constructor (uint256 _maxAllowedTotalSupply) {
        require(_maxAllowedTotalSupply != 0, "_maxAllowedTotalSupply is empty");

        maxAllowedTotalSupply = _maxAllowedTotalSupply;
    }

    // ========== MUTATIVE FUNCTIONS ========== //

    function burn(uint256 _amount) override external {
        _burn(msg.sender, _amount);
    }

    // ========== RESTRICTED FUNCTIONS ========== //

    function mint(address _holder, uint256 _amount)
        virtual
        external
        onlyOwner()
        assertMaxSupply(_amount)
    {
        require(_amount != 0, "zero amount");

        _mint(_holder, _amount);
    }

    function _assertMaxSupply(uint256 _amountToMint) internal {
        uint256 everMintedTotal = everMinted + _amountToMint;
        everMinted = everMintedTotal;
        require(everMintedTotal <= maxAllowedTotalSupply, "total supply limit exceeded");
    }
}

// src/interfaces/OnDemandToken.sol

abstract contract OnDemandToken is MintableToken {
    bool constant public ON_DEMAND_TOKEN = true;

    mapping (address => bool) public minters;

    event SetupMinter(address minter, bool active);

    modifier onlyOwnerOrMinter() {
        address msgSender = _msgSender();
        require(owner() == msgSender || minters[msgSender], "access denied");

        _;
    }

    function setupMinter(address _minter, bool _active) external onlyOwner() {
        minters[_minter] = _active;
        emit SetupMinter(_minter, _active);
    }

    function setupMinters(address[] calldata _minters, bool[] calldata _actives) external onlyOwner() {
        for (uint256 i; i < _minters.length; i++) {
            minters[_minters[i]] = _actives[i];
            emit SetupMinter(_minters[i], _actives[i]);
        }
    }

    function mint(address _holder, uint256 _amount)
        external
        virtual
        override
        onlyOwnerOrMinter()
        assertMaxSupply(_amount)
    {
        require(_amount != 0, "zero amount");

        _mint(_holder, _amount);
    }
}

// src/staking/StakingRewards.sol

// Inheritance

// based on synthetix
contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    struct Times {
        uint32 periodFinish;
        uint32 rewardsDuration;
        uint32 lastUpdateTime;
        uint96 totalRewardsSupply;
    }

    // ========== STATE VARIABLES ========== //

    uint256 public immutable maxEverTotalRewards;

    IERC20 public immutable rewardsToken;
    IERC20 public immutable stakingToken;

    uint256 public rewardRate = 0;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    Times public timeData;
    bool public stopped;

    // ========== EVENTS ========== //

    event RewardAdded(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event RewardsDurationUpdated(uint256 newDuration);
    event FarmingFinished();

    // ========== MODIFIERS ========== //

    modifier whenActive() {
        require(!stopped, "farming is stopped");
        _;
    }

    modifier updateReward(address account) virtual {
        uint256 newRewardPerTokenStored = rewardPerToken();
        rewardPerTokenStored = newRewardPerTokenStored;
        timeData.lastUpdateTime = uint32(lastTimeRewardApplicable());

        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = newRewardPerTokenStored;
        }

        _;
    }

    // ========== CONSTRUCTOR ========== //

    constructor(
        address _owner,
        address _rewardsDistribution,
        address _stakingToken,
        address _rewardsToken
    ) Owned(_owner) {
        require(OnDemandToken(_rewardsToken).ON_DEMAND_TOKEN(), "rewardsToken must be OnDemandToken");

        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
        rewardsDistribution = _rewardsDistribution;

        timeData.rewardsDuration = 2592000; // 30 days
        maxEverTotalRewards = MintableToken(_rewardsToken).maxAllowedTotalSupply();
    }

    // ========== RESTRICTED FUNCTIONS ========== //

    function notifyRewardAmount(
        uint256 _reward
    ) override virtual external whenActive onlyRewardsDistribution updateReward(address(0)) {
        Times memory t = timeData;
        uint256 newRewardRate;

        if (block.timestamp >= t.periodFinish) {
            newRewardRate = _reward / t.rewardsDuration;
        } else {
            uint256 remaining = t.periodFinish - block.timestamp;
            uint256 leftover = remaining * rewardRate;
            newRewardRate = (_reward + leftover) / t.rewardsDuration;
        }

        require(newRewardRate != 0, "invalid rewardRate");

        rewardRate = newRewardRate;

        // always increasing by _reward even if notification is in a middle of period
        // because leftover is included
        uint256 totalRewardsSupply = timeData.totalRewardsSupply + _reward;
        require(totalRewardsSupply <= maxEverTotalRewards, "rewards overflow");

        timeData.totalRewardsSupply = uint96(totalRewardsSupply);
        timeData.lastUpdateTime = uint32(block.timestamp);
        timeData.periodFinish = uint32(block.timestamp + t.rewardsDuration);

        emit RewardAdded(_reward);
    }

    function setRewardsDuration(uint256 _rewardsDuration) external whenActive onlyOwner {
        require(_rewardsDuration != 0, "empty _rewardsDuration");

        require(
            block.timestamp > timeData.periodFinish,
            "Previous period must be complete before changing the duration"
        );

        timeData.rewardsDuration = uint32(_rewardsDuration);
        emit RewardsDurationUpdated(_rewardsDuration);
    }

    // when farming was started with 1y and 12tokens
    // and we want to finish after 4 months, we need to end up with situation
    // like we were starting with 4mo and 4 tokens.
    function finishFarming() virtual external whenActive onlyOwner {
        Times memory t = timeData;
        require(block.timestamp < t.periodFinish, "can't stop if not started or already finished");

        stopped = true;

        if (_totalSupply != 0) {
            uint256 remaining = t.periodFinish - block.timestamp;
            timeData.rewardsDuration = uint32(t.rewardsDuration - remaining);
        }

        timeData.periodFinish = uint32(block.timestamp);

        emit FarmingFinished();
    }

    // ========== MUTATIVE FUNCTIONS ========== //

    function exit() override external {
        withdraw(_balances[msg.sender]);
        getReward();
    }

    function stake(uint256 amount) override external {
        _stake(msg.sender, amount, false);
    }

    function rescueToken(ERC20 _token, address _recipient, uint256 _amount) external onlyOwner() {
        if (address(_token) == address(stakingToken)) {
            require(_totalSupply <= stakingToken.balanceOf(address(this)) - _amount, "amount is too big to rescue");
        } else if (address(_token) == address(rewardsToken)) {
            revert("reward token can not be rescued");
        }

        _token.transfer(_recipient, _amount);
    }

    function periodFinish() external view returns (uint256) {
        return timeData.periodFinish;
    }

    function rewardsDuration() external view returns (uint256) {
        return timeData.rewardsDuration;
    }

    function lastUpdateTime() external view returns (uint256) {
        return timeData.lastUpdateTime;
    }

    function balanceOf(address account) override external view returns (uint256) {
        return _balances[account];
    }

    function getRewardForDuration() override external view returns (uint256) {
        return rewardRate * timeData.rewardsDuration;
    }

    function version() external pure virtual returns (uint256) {
        return 1;
    }

    function withdraw(uint256 amount) override public {
        _withdraw(amount, msg.sender, msg.sender);
    }

    function getReward() override public {
        _getReward(msg.sender, msg.sender);
    }

    // ========== VIEWS ========== //

    function totalSupply() override public view returns (uint256) {
        return _totalSupply;
    }

    function lastTimeRewardApplicable() override public view returns (uint256) {
        return Math.min(block.timestamp, timeData.periodFinish);
    }

    function rewardPerToken() override public view returns (uint256) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }

        return rewardPerTokenStored + (
            (lastTimeRewardApplicable() - timeData.lastUpdateTime) * rewardRate * 1e18 / _totalSupply
        );
    }

    function earned(address account) override virtual public view returns (uint256) {
        return (_balances[account] * (rewardPerToken() - userRewardPerTokenPaid[account]) / 1e18) + rewards[account];
    }

    function _stake(address user, uint256 amount, bool migration)
        internal
        nonReentrant
        notPaused
        updateReward(user)
    {
        require(timeData.periodFinish != 0, "Stake period not started yet");
        require(amount != 0, "Cannot stake 0");

        _totalSupply = _totalSupply + amount;
        _balances[user] = _balances[user] + amount;

        if (migration) {
            // other contract will send tokens to us, this will save ~13K gas
        } else {
            // not using safe transfer, because we working with trusted tokens
            require(stakingToken.transferFrom(user, address(this), amount), "token transfer failed");
        }

        emit Staked(user, amount);
    }

    /// @dev {_withdraw(amount, user, recipient)
    ///      requires {_balances[user] >= amount && amount != 0}}
    function _withdraw(uint256 amount, address user, address recipient) internal nonReentrant updateReward(user) {
        // not using safe math, because there is no way to overflow if stake tokens not overflow
        _totalSupply = _totalSupply - amount;
        _balances[user] = _balances[user] - amount;
        // not using safe transfer, because we working with trusted tokens
        require(stakingToken.transfer(recipient, amount), "token transfer failed");

        emit Withdrawn(user, amount);
    }

    /// @param user address
    /// @param recipient address, where to send reward
    function _getReward(address user, address recipient)
        internal
        virtual
        nonReentrant
        updateReward(user)
        returns (uint256 reward)
    {
        reward = rewards[user];

        if (reward != 0) {
            rewards[user] = 0;
            OnDemandToken(address(rewardsToken)).mint(recipient, reward);
            emit RewardPaid(user, reward);
        }
    }
}
