// SPDX-License-Identifier: MIT
pragma solidity <0.8.0 >=0.4.0 >=0.4.24 >=0.6.0 >=0.6.2 ^0.6.0 ^0.6.12;
// pragma solidity=0.6.12;
pragma experimental ABIEncoderV2;

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

// src/@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol

library AddressUpgradeable {

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

// src/@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol

interface IBEP20 {

    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address _owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// src/interfaces/IQBridgeDelegator.sol

interface IQBridgeDelegator {

    function delegate(address xToken, address account, uint option, uint amount) external;
}

// src/interfaces/IQBridgeHandler.sol

interface IQBridgeHandler {
    /**
        @notice Correlates {resourceID} with {contractAddress}.
        @param resourceID ResourceID to be used when making deposits.
        @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
     */
    function setResource(bytes32 resourceID, address contractAddress) external;

    /**
        @notice Marks {contractAddress} as mintable/burnable.
        @param contractAddress Address of contract to be used when making or executing deposits.
     */
    function setBurnable(address contractAddress) external;

    /**
        @notice It is intended that deposit are made using the Bridge contract.
        @param depositer Address of account making the deposit in the Bridge contract.
        @param data Consists of additional data needed for a specific deposit.
     */
    function deposit(bytes32 resourceID, address depositer, bytes calldata data) external;
    function depositETH(bytes32 resourceID, address depositer, bytes calldata data) external payable;

    /**
        @notice It is intended that proposals are executed by the Bridge contract.
        @param data Consists of additional data needed for a specific deposit execution.
     */
    function executeProposal(bytes32 resourceID, bytes calldata data) external;

    /**
        @notice Used to manually release funds from ERC safes.
        @param tokenAddress Address of token contract to release.
        @param recipient Address to release tokens to.
        @param amount the amount of ERC20 tokens to release.
     */
    function withdraw(address tokenAddress, address recipient, uint amount) external;
}

// src/library/SafeToken.sol

interface ERC20Interface {
    function balanceOf(address user) external view returns (uint);
}

library SafeToken {
    function myBalance(address token) internal view returns (uint) {
        return ERC20Interface(token).balanceOf(address(this));
    }

    function balanceOf(address token, address user) internal view returns (uint) {
        return ERC20Interface(token).balanceOf(user);
    }

    function safeApprove(
        address token,
        address to,
        uint value
    ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");
    }

    function safeTransfer(
        address token,
        address to,
        uint value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success, ) = to.call{ value: value }(new bytes(0));
        require(success, "!safeTransferETH");
    }
}

// src/@openzeppelin/contracts-upgradeable/proxy/Initializable.sol

// solhint-disable-next-line compiler-version

abstract contract Initializable {

    bool private _initialized;

    bool private _initializing;

    modifier initializer() {
        require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    function _isConstructor() private view returns (bool) {
        return !AddressUpgradeable.isContract(address(this));
    }
}

// src/@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol

abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {
    }
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
    uint256[50] private __gap;
}

// src/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol

abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function __Ownable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal initializer {
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
    uint256[49] private __gap;
}

// src/library/BEP20Upgradeable.sol

abstract contract BEP20Upgradeable is IBEP20, OwnableUpgradeable {
    using SafeMath for uint;

    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowances;
    uint private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    uint[50] private __gap;

    function __BEP20__init(
        string memory name,
        string memory symbol,
        uint8 decimals
    ) internal initializer {
        __Ownable_init();
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function getOwner() external view override returns (address) {
        return owner();
    }
    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint) {
        return _balances[account];
    }

    function transfer(address recipient, uint amount) external override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance")
        );
        return true;
    }

    function increaseAllowance(address spender, uint addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero")
        );
        return true;
    }

    function burn(uint amount) public returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint amount
    ) internal {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint amount) internal {
        require(account != address(0), "BEP20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint amount
    ) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _burnFrom(address account, uint amount) internal {
        _burn(account, amount);
        _approve(
            account,
            _msgSender(),
            _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance")
        );
    }
}

// src/bridge/QBridgeToken.sol

/*
      ___       ___       ___       ___       ___
     /\  \     /\__\     /\  \     /\  \     /\  \
    /::\  \   /:/ _/_   /::\  \   _\:\  \    \:\  \
    \:\:\__\ /:/_/\__\ /::\:\__\ /\/::\__\   /::\__\
     \::/  / \:\/:/  / \:\::/  / \::/\/__/  /:/\/__/
     /:/  /   \::/  /   \::/  /   \:\__\    \/__/
     \/__/     \/__/     \/__/     \/__/

*
* MIT License
* ===========
*
* Copyright (c) 2021 QubitFinance
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

contract QBridgeToken is BEP20Upgradeable {

    /* ========== STATE VARIABLES ========== */

    mapping(address => bool) private _minters;

    /* ========== MODIFIERS ========== */

    modifier onlyMinter() {
        require(isMinter(msg.sender), "QBridgeToken: caller is not the minter");
        _;
    }

    /* ========== INITIALIZER ========== */

    function initialize(string memory name, string memory symbol, uint8 decimals) external initializer {
        __BEP20__init(name, symbol, decimals);
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

    function setMinter(address minter, bool canMint) external onlyOwner {
        _minters[minter] = canMint;
    }

    function mint(address _to, uint _amount) public onlyMinter {
        _mint(_to, _amount);
    }

    function burnFrom(address account, uint amount) public onlyMinter {
        uint decreasedAllowance = allowance(account, msg.sender).sub(amount, "BEP20: burn amount exceeds allowance");
        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);
    }

    /* ========== VIEWS ========== */

    function isMinter(address account) public view returns (bool) {
        return _minters[account];
    }
}

// src/bridge/QBridgeHandler.sol

/*
      ___       ___       ___       ___       ___
     /\  \     /\__\     /\  \     /\  \     /\  \
    /::\  \   /:/ _/_   /::\  \   _\:\  \    \:\  \
    \:\:\__\ /:/_/\__\ /::\:\__\ /\/::\__\   /::\__\
     \::/  / \:\/:/  / \:\::/  / \::/\/__/  /:/\/__/
     /:/  /   \::/  /   \::/  /   \:\__\    \/__/
     \/__/     \/__/     \/__/     \/__/

*
* MIT License
* ===========
*
* Copyright (c) 2021 QubitFinance
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

contract QBridgeHandler is IQBridgeHandler, OwnableUpgradeable {
    using SafeMath for uint;
    using SafeToken for address;

    /* ========== CONSTANT VARIABLES ========== */

    uint public constant OPTION_QUBIT_BNB_NONE = 100;
    uint public constant OPTION_QUBIT_BNB_0100 = 110;
    uint public constant OPTION_QUBIT_BNB_0050 = 105;
    uint public constant OPTION_BUNNY_XLP_0150 = 215;

    address public constant ETH = 0x0000000000000000000000000000000000000000;

    /* ========== STATE VARIABLES ========== */

    address public _bridgeAddress;

    mapping(bytes32 => address) public resourceIDToTokenContractAddress; // resourceID => token contract address
    mapping(address => bytes32) public tokenContractAddressToResourceID; // token contract address => resourceID

    mapping(address => bool) public burnList; // token contract address => is burnable
    mapping(address => bool) public contractWhitelist; // token contract address => is whitelisted
    mapping(uint => address) public delegators; // option => delegator contract address
    mapping(bytes32 => uint) public withdrawalFees; // resourceID => withdraw fee
    mapping(bytes32 => mapping(uint => uint)) public minAmounts; // [resourceID][option] => minDepositAmount

    /* ========== INITIALIZER ========== */

    receive() external payable {}

    function initialize(address bridgeAddress) external initializer {
        __Ownable_init();
        _bridgeAddress = bridgeAddress;
    }

    /* ========== MODIFIERS ========== */

    modifier onlyBridge() {
        require(msg.sender == _bridgeAddress, "QBridgeHandler: caller is not the bridge contract");
        _;
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

    function setResource(bytes32 resourceID, address contractAddress) external override onlyBridge {
        resourceIDToTokenContractAddress[resourceID] = contractAddress;
        tokenContractAddressToResourceID[contractAddress] = resourceID;
        contractWhitelist[contractAddress] = true;
    }

    function setBurnable(address contractAddress) external override onlyBridge {
        require(contractWhitelist[contractAddress], "QBridgeHandler: contract address is not whitelisted");
        burnList[contractAddress] = true;
    }

    function setDelegator(uint option, address newDelegator) external onlyOwner {
        delegators[option] = newDelegator;
    }

    function setWithdrawalFee(bytes32 resourceID, uint withdrawalFee) external onlyOwner {
        withdrawalFees[resourceID] = withdrawalFee;
    }

    function setMinDepositAmount(bytes32 resourceID, uint option, uint minAmount) external onlyOwner {
        minAmounts[resourceID][option] = minAmount;
    }


    /// @dev {deposit(resourceID, depositer, data) returns ()
    ///     requires {(resourceIDToTokenContractAddress[resourceID] != address(0) && contractWhitelist[resourceIDToTokenContractAddress[resourceID]])} }
    function deposit(bytes32 resourceID, address depositer, bytes calldata data) external override onlyBridge {
        uint option;
        uint amount;
        (option, amount) = abi.decode(data, (uint, uint));

        address tokenAddress = resourceIDToTokenContractAddress[resourceID];

        if (burnList[tokenAddress]) {
            require(amount >= withdrawalFees[resourceID], "less than withdrawal fee");
            QBridgeToken(tokenAddress).burnFrom(depositer, amount);
        } else {
            require(amount >= minAmounts[resourceID][option], "less than minimum amount");
            tokenAddress.safeTransferFrom(depositer, address(this), amount);
        }
    }

    function depositETH(bytes32 resourceID, address depositer, bytes calldata data) external payable override onlyBridge {
        uint option;
        uint amount;
        (option, amount) = abi.decode(data, (uint, uint));
        require(amount == msg.value);

        address tokenAddress = resourceIDToTokenContractAddress[resourceID];
        require(contractWhitelist[tokenAddress], "provided tokenAddress is not whitelisted");

        require(amount >= minAmounts[resourceID][option], "less than minimum amount");
    }

    /**
        @notice Proposal execution should be initiated by a relayer on the deposit's destination chain.
        @param data passed into the function should be constructed as follows:
        option                                 uint256
        amount                                 uint256
        destinationRecipientAddress            address
     */
    function executeProposal(bytes32 resourceID, bytes calldata data) external override onlyBridge {
        uint option;
        uint amount;
        address recipientAddress;
        (option, amount, recipientAddress) = abi.decode(data, (uint, uint, address));

        address tokenAddress = resourceIDToTokenContractAddress[resourceID];

        require(contractWhitelist[tokenAddress], "provided tokenAddress is not whitelisted");

        if (burnList[tokenAddress]) {
            address delegatorAddress = delegators[option];
            if (delegatorAddress == address(0)) {
                QBridgeToken(tokenAddress).mint(recipientAddress, amount);
            } else {
                QBridgeToken(tokenAddress).mint(delegatorAddress, amount);
                IQBridgeDelegator(delegatorAddress).delegate(tokenAddress, recipientAddress, option, amount);
            }
        } else if (tokenAddress == ETH) {
            SafeToken.safeTransferETH(recipientAddress, amount.sub(withdrawalFees[resourceID]));
        } else {
            tokenAddress.safeTransfer(recipientAddress, amount.sub(withdrawalFees[resourceID]));
        }
    }

    function withdraw(address tokenAddress, address recipient, uint amount) external override onlyBridge {
        if (tokenAddress == ETH)
            SafeToken.safeTransferETH(recipient, amount);
        else
            tokenAddress.safeTransfer(recipient, amount);
    }

}
