pragma solidity ^0.8.9;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

library SafeMath {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a, "add");
    }

    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a, "sub");
        c = a - b;
    }

    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require((a == 0) || ((c / a) == b), "mul");
    }

    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0, "div");
        c = a / b;
    }
}

library Address {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly {
            codehash := extcodehash(account)
        }
        return ((codehash != 0x0) && (codehash != accountHash));
    }

    function toPayable(address account) internal pure returns (address payable) {
        return payable(account);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).safeAdd(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).safeSub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract Ownable {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address private _contract_owner;

    ///  @dev Throws if called by any account other than the owner.
    modifier onlyOwner() {
        require(_contract_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    ///  @dev Initializes the contract setting the deployer as the initial owner.
    constructor() {
        address msgSender = msg.sender;
        _contract_owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    ///  @dev Returns the address of the current owner.
    function owner() public view returns (address) {
        return _contract_owner;
    }

    ///  @dev Transfers ownership of the contract to a new account (`newOwner`).
    ///  Can only be called by the current owner.
    function transferOwnership(address newOwner) public onlyOwner() {
        _transferOwnership(newOwner);
    }

    ///  @dev Transfers ownership of the contract to a new account (`newOwner`).
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_contract_owner, newOwner);
        _contract_owner = newOwner;
    }
}

interface ERC20TokenBankInterface {
    function balance() external returns (uint);

    function token() external view returns (address, string memory);

    function issue(address _to, uint _amount) external returns (bool success);
}

contract CurveInterface {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    address public curve;
}

interface PriceInterface {
    function get_virtual_price() external view returns (uint256);

    function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external;

    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
}

contract ExchangeBetweenPools is Ownable {
    using SafeERC20 for IERC20;

    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    event MinimumAmountChanged(uint256 old, uint256 _new);

    string public note;
    IERC20 public usdt;
    IERC20 public usdc;
    address public from_bank;
    address public to_bank;
    uint256 public minimum_amount;
    /// curve.exchange_underlying(x, y, camount, n)
    ///    ensures _exchange_underlying_post_condition(camount)
    PriceInterface public curve;

    constructor(address _from_bank, address _to_bank, uint256 _min_amount) {
        note = "Only for USDC to USDT";
        from_bank = _from_bank;
        to_bank = _to_bank;
        (address u1, string memory s1) = ERC20TokenBankInterface(from_bank).token();
        usdc = IERC20(u1);
        (u1, s1) = ERC20TokenBankInterface(to_bank).token();
        usdt = IERC20(u1);
        minimum_amount = _min_amount;
        CurveInterface pool_deposit = CurveInterface(0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3);
        curve = PriceInterface(pool_deposit.curve());
    }

    function changeMinimumAmount(uint256 _new_amount) public onlyOwner() {
        require(_new_amount > 0, "invalid amount");
        uint256 old = minimum_amount;
        minimum_amount = _new_amount;
        emit MinimumAmountChanged(old, minimum_amount);
    }

    /// @custom:consol {doExchange(amount) returns (success) requires {amount >= minimum_amount && amount <= ERC20TokenBankInterface(from_bank).balance()}}
    function doExchange_original(uint256 amount) private returns (bool) {
        require(amount >= minimum_amount, "invalid amount");
        require(amount <= ERC20TokenBankInterface(from_bank).balance(), "too much amount");
        ERC20TokenBankInterface(from_bank).issue(address(this), amount);
        uint256 camount = usdc.balanceOf(address(this));
        usdc.safeApprove(address(curve), camount);
        curve.exchange_underlying(1, 2, camount, 0);
        uint256 namount = usdt.balanceOf(address(this));
        usdt.safeTransfer(to_bank, namount);
        return true;
    }

    function _doExchange_pre(uint256 amount) private {
        if (!(amount>=minimum_amount&&amount<=ERC20TokenBankInterface(from_bank).balance())) revert preViolation("doExchange");
    }

    function doExchange(uint256 amount) public returns (bool) {
        _doExchange_pre(amount);
        bool success = doExchange_original(amount);
        return (success);
    }
}

contract ExchangeBetweenPoolsFactory {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    event NewExchangeBetweenPools(address addr);

    function createExchangeBetweenPools(address from_bank, address to_bank, uint256 minimum_amount) public returns (address) {
        ExchangeBetweenPools addr = new ExchangeBetweenPools(from_bank, to_bank, minimum_amount);
        emit NewExchangeBetweenPools(address(addr));
        addr.transferOwnership(msg.sender);
        return address(addr);
    }
}