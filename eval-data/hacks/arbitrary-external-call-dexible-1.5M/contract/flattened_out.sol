pragma solidity ^0.8.0^0.8.1^0.8.17;

///  @dev Interface of the ERC20 standard as defined in the EIP.
interface IERC20 {
    ///  @dev Emitted when `value` tokens are moved from one account (`from`) to
    ///  another (`to`).
    ///  Note that `value` may be zero.
    event Transfer(address indexed from, address indexed to, uint256 value);

    ///  @dev Emitted when the allowance of a `spender` for an `owner` is set by
    ///  a call to {approve}. `value` is the new allowance.
    event Approval(address indexed owner, address indexed spender, uint256 value);

    ///  @dev Returns the amount of tokens in existence.
    function totalSupply() external view returns (uint256);

    ///  @dev Returns the amount of tokens owned by `account`.
    function balanceOf(address account) external view returns (uint256);

    ///  @dev Moves `amount` tokens from the caller's account to `to`.
    ///  Returns a boolean value indicating whether the operation succeeded.
    ///  Emits a {Transfer} event.
    function transfer(address to, uint256 amount) external returns (bool);

    ///  @dev Returns the remaining number of tokens that `spender` will be
    ///  allowed to spend on behalf of `owner` through {transferFrom}. This is
    ///  zero by default.
    ///  This value changes when {approve} or {transferFrom} are called.
    function allowance(address owner, address spender) external view returns (uint256);

    ///  @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
    ///  Returns a boolean value indicating whether the operation succeeded.
    ///  IMPORTANT: Beware that changing an allowance with this method brings the risk
    ///  that someone may use both the old and the new allowance by unfortunate
    ///  transaction ordering. One possible solution to mitigate this race
    ///  condition is to first reduce the spender's allowance to 0 and set the
    ///  desired value afterwards:
    ///  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    ///  Emits an {Approval} event.
    function approve(address spender, uint256 amount) external returns (bool);

    ///  @dev Moves `amount` tokens from `from` to `to` using the
    ///  allowance mechanism. `amount` is then deducted from the caller's
    ///  allowance.
    ///  Returns a boolean value indicating whether the operation succeeded.
    ///  Emits a {Transfer} event.
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

///  @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
///  https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
///  Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
///  presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
///  need to send a transaction, and thus is not required to hold Ether at all.
interface IERC20Permit {
    ///  @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
    ///  given ``owner``'s signed approval.
    ///  IMPORTANT: The same issues {IERC20-approve} has related to transaction
    ///  ordering also apply here.
    ///  Emits an {Approval} event.
    ///  Requirements:
    ///  - `spender` cannot be the zero address.
    ///  - `deadline` must be a timestamp in the future.
    ///  - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
    ///  over the EIP712-formatted function arguments.
    ///  - the signature must use ``owner``'s current nonce (see {nonces}).
    ///  For more information on the signature format, see the
    ///  https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
    ///  section].
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;

    ///  @dev Returns the current nonce for `owner`. This value must be
    ///  included whenever a signature is generated for {permit}.
    ///  Every successful call to {permit} increases ``owner``'s nonce by one. This
    ///  prevents a signature from being used multiple times.
    function nonces(address owner) external view returns (uint256);

    ///  @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

///  @dev Collection of functions related to the address type
library Address {
    ///  @dev Returns true if `account` is a contract.
    ///  [IMPORTANT]
    ///  ====
    ///  It is unsafe to assume that an address for which this function returns
    ///  false is an externally-owned account (EOA) and not a contract.
    ///  Among others, `isContract` will return false for the following
    ///  types of addresses:
    ///   - an externally-owned account
    ///   - a contract in construction
    ///   - an address where a contract will be created
    ///   - an address where a contract lived, but was destroyed
    ///  ====
    ///  [IMPORTANT]
    ///  ====
    ///  You shouldn't rely on `isContract` to protect against flash loan attacks!
    ///  Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
    ///  like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
    ///  constructor.
    ///  ====
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    ///  @dev Replacement for Solidity's `transfer`: sends `amount` wei to
    ///  `recipient`, forwarding all available gas and reverting on errors.
    ///  https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
    ///  of certain opcodes, possibly making contracts go over the 2300 gas limit
    ///  imposed by `transfer`, making them unable to receive funds via
    ///  `transfer`. {sendValue} removes this limitation.
    ///  https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
    ///  IMPORTANT: because control is transferred to `recipient`, care must be
    ///  taken to not create reentrancy vulnerabilities. Consider using
    ///  {ReentrancyGuard} or the
    ///  https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    ///  @dev Performs a Solidity function call using a low level `call`. A
    ///  plain `call` is an unsafe replacement for a function call: use this
    ///  function instead.
    ///  If `target` reverts with a revert reason, it is bubbled up by this
    ///  function (like regular Solidity function calls).
    ///  Returns the raw returned data. To convert to the expected return value,
    ///  use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
    ///  Requirements:
    ///  - `target` must be a contract.
    ///  - calling `target` with `data` must not revert.
    ///  _Available since v3.1._
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    ///  @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
    ///  `errorMessage` as a fallback revert reason when `target` reverts.
    ///  _Available since v3.1._
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    ///  @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
    ///  but also transferring `value` wei to `target`.
    ///  Requirements:
    ///  - the calling contract must have an ETH balance of at least `value`.
    ///  - the called Solidity function must be `payable`.
    ///  _Available since v3.1._
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    ///  @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
    ///  with `errorMessage` as a fallback revert reason when `target` reverts.
    ///  _Available since v3.1._
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    ///  @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
    ///  but performing a static call.
    ///  _Available since v3.3._
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    ///  @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
    ///  but performing a static call.
    ///  _Available since v3.3._
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    ///  @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
    ///  but performing a delegate call.
    ///  _Available since v3.4._
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    ///  @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
    ///  but performing a delegate call.
    ///  _Available since v3.4._
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    ///  @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
    ///  the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
    ///  _Available since v4.8._
    function verifyCallResultFromTarget(address target, bool success, bytes memory returndata, string memory errorMessage) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    ///  @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
    ///  revert reason or using the provided one.
    ///  _Available since v4.3._
    function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        if (returndata.length > 0) {
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

///  @dev Provides information about the current execution context, including the
///  sender of the transaction and its data. While these are generally available
///  via msg.sender and msg.data, they should not be accessed in such a direct
///  manner, since when dealing with meta-transactions the account sending and
///  paying for execution may not be the actual sender (as far as an application
///  is concerned).
///  This contract is only required for intermediate, library-like contracts.
abstract contract Context {
    function _msgSender() virtual internal view returns (address) {
        return msg.sender;
    }

    function _msgData() virtual internal view returns (bytes calldata) {
        return msg.data;
    }
}

///  @dev Standard math utilities missing in the Solidity language.
library Math {
    enum Rounding { Down, Up, Zero }

    ///  @dev Returns the largest of two numbers.
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a > b) ? a : b;
    }

    ///  @dev Returns the smallest of two numbers.
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a < b) ? a : b;
    }

    ///  @dev Returns the average of two numbers. The result is rounded towards
    ///  zero.
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a & b) + ((a ^ b) / 2);
    }

    ///  @dev Returns the ceiling of the division of two numbers.
    ///  This differs from standard division with `/` in that it rounds up instead
    ///  of rounding down.
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a == 0) ? 0 : (((a - 1) / b) + 1);
    }

    ///  @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    ///  @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
    ///  with further edits by Uniswap Labs also under MIT license.
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            uint256 prod0;
            uint256 prod1;
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }
            if (prod1 == 0) {
                return prod0 / denominator;
            }
            require(denominator > prod1);
            uint256 remainder;
            assembly {
                remainder := mulmod(x, y, denominator)
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }
            uint256 twos = denominator & ((~denominator) + 1);
            assembly {
                denominator := div(denominator, twos)
                prod0 := div(prod0, twos)
                twos := add(div(sub(0, twos), twos), 1)
            }
            prod0 |= prod1 * twos;
            uint256 inverse = (3 * denominator) ^ 2;
            inverse *= 2 - (denominator * inverse);
            inverse *= 2 - (denominator * inverse);
            inverse *= 2 - (denominator * inverse);
            inverse *= 2 - (denominator * inverse);
            inverse *= 2 - (denominator * inverse);
            inverse *= 2 - (denominator * inverse);
            result = prod0 * inverse;
            return result;
        }
    }

    ///  @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if ((rounding == Rounding.Up) && (mulmod(x, y, denominator) > 0)) {
            result += 1;
        }
        return result;
    }

    ///  @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
    ///  Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 result = 1 << (log2(a) >> 1);
        unchecked {
            result = (result + (a / result)) >> 1;
            result = (result + (a / result)) >> 1;
            result = (result + (a / result)) >> 1;
            result = (result + (a / result)) >> 1;
            result = (result + (a / result)) >> 1;
            result = (result + (a / result)) >> 1;
            result = (result + (a / result)) >> 1;
            return min(result, a / result);
        }
    }

    ///  @notice Calculates sqrt(a), following the selected rounding direction.
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (((rounding == Rounding.Up) && ((result * result) < a)) ? 1 : 0);
        }
    }

    ///  @dev Return the log in base 2, rounded down, of a positive value.
    ///  Returns 0 if given 0.
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if ((value >> 128) > 0) {
                value >>= 128;
                result += 128;
            }
            if ((value >> 64) > 0) {
                value >>= 64;
                result += 64;
            }
            if ((value >> 32) > 0) {
                value >>= 32;
                result += 32;
            }
            if ((value >> 16) > 0) {
                value >>= 16;
                result += 16;
            }
            if ((value >> 8) > 0) {
                value >>= 8;
                result += 8;
            }
            if ((value >> 4) > 0) {
                value >>= 4;
                result += 4;
            }
            if ((value >> 2) > 0) {
                value >>= 2;
                result += 2;
            }
            if ((value >> 1) > 0) {
                result += 1;
            }
        }
        return result;
    }

    ///  @dev Return the log in base 2, following the selected rounding direction, of a positive value.
    ///  Returns 0 if given 0.
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (((rounding == Rounding.Up) && ((1 << result) < value)) ? 1 : 0);
        }
    }

    ///  @dev Return the log in base 10, rounded down, of a positive value.
    ///  Returns 0 if given 0.
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= (10 ** 64)) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= (10 ** 32)) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= (10 ** 16)) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= (10 ** 8)) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= (10 ** 4)) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= (10 ** 2)) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= (10 ** 1)) {
                result += 1;
            }
        }
        return result;
    }

    ///  @dev Return the log in base 10, following the selected rounding direction, of a positive value.
    ///  Returns 0 if given 0.
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (((rounding == Rounding.Up) && ((10 ** result) < value)) ? 1 : 0);
        }
    }

    ///  @dev Return the log in base 256, rounded down, of a positive value.
    ///  Returns 0 if given 0.
    ///  Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if ((value >> 128) > 0) {
                value >>= 128;
                result += 16;
            }
            if ((value >> 64) > 0) {
                value >>= 64;
                result += 8;
            }
            if ((value >> 32) > 0) {
                value >>= 32;
                result += 4;
            }
            if ((value >> 16) > 0) {
                value >>= 16;
                result += 2;
            }
            if ((value >> 8) > 0) {
                result += 1;
            }
        }
        return result;
    }

    ///  @dev Return the log in base 10, following the selected rounding direction, of a positive value.
    ///  Returns 0 if given 0.
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (((rounding == Rounding.Up) && ((1 << (result * 8)) < value)) ? 1 : 0);
        }
    }
}

interface IPausable {
    event Paused();

    event Resumed();

    function pause() external;

    function resume() external;
}

///  Constant values used elsewhere
library LibConstants {
    uint16 internal constant HOUR = 3600;
    uint24 internal constant DAY = 86400;
    uint internal constant USD_PRECISION = 1e6;
    uint internal constant MM_VOLUME = 1e12;
    uint internal constant PRICE_PRECISION = 1e30;
    string public constant ROLE_MGR = "ROLE_MANAGER";
    string public constant RELAY = "RELAY";
    string public constant SWAP_FAILURE = "SWAP_FAILURE";
    string public constant SWAP_SUCCESS = "SWAP_SUCCESS";
}

interface IDexibleEvents {
    event SwapFailed(address indexed trader, address feeToken, uint gasFeePaid);

    event SwapSuccess(address indexed trader, address indexed affiliate, uint inputAmount, uint outputAmount, address feeToken, uint gasFee, uint affiliateFee, uint dexibleFee);

    event AffiliatePaid(address indexed affiliate, address token, uint amount);

    event PaidGasFunds(address indexed relay, uint amount);

    event InsufficientGasFunds(address indexed relay, uint amount);

    event ChangedRevshareVault(address indexed old, address indexed newRevshare);

    event ChangedRevshareSplit(uint8 split);

    event ChangedBpsRates(uint32 stdRate, uint32 minRate);
}

interface IDexibleView {
    function revshareSplitRatio() external view returns (uint8);

    function stdBpsRate() external view returns (uint16);

    function minBpsRate() external view returns (uint16);

    function minFeeUSD() external view returns (uint112);

    function communityVault() external view returns (address);

    function treasury() external view returns (address);

    function dxblToken() external view returns (address);

    function arbitrumGasOracle() external view returns (address);
}

interface IArbitrumGasOracle {
    function calculateGasCost(uint callDataSize, uint l2GasUsed) external view returns (uint);
}

interface IOptimismGasOracle {
    function getL1Fee(bytes calldata data) external view returns (uint);
}

interface IStandardGasAdjustments {
    function adjustment(string memory adjType) external view returns (uint);
}

library console {
    address internal constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);

    function _sendLogPayload(bytes memory payload) private view {
        uint256 payloadLength = payload.length;
        address consoleAddress = CONSOLE_ADDRESS;
        assembly {
            let payloadStart := add(payload, 32)
            let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
        }
    }

    function log() internal view {
        _sendLogPayload(abi.encodeWithSignature("log()"));
    }

    function logInt(int256 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(int256)", p0));
    }

    function logUint(uint256 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
    }

    function logString(string memory p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
    }

    function logBool(bool p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
    }

    function logAddress(address p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
    }

    function logBytes(bytes memory p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
    }

    function logBytes1(bytes1 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
    }

    function logBytes2(bytes2 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
    }

    function logBytes3(bytes3 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
    }

    function logBytes4(bytes4 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
    }

    function logBytes5(bytes5 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
    }

    function logBytes6(bytes6 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
    }

    function logBytes7(bytes7 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
    }

    function logBytes8(bytes8 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
    }

    function logBytes9(bytes9 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
    }

    function logBytes10(bytes10 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
    }

    function logBytes11(bytes11 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
    }

    function logBytes12(bytes12 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
    }

    function logBytes13(bytes13 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
    }

    function logBytes14(bytes14 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
    }

    function logBytes15(bytes15 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
    }

    function logBytes16(bytes16 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
    }

    function logBytes17(bytes17 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
    }

    function logBytes18(bytes18 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
    }

    function logBytes19(bytes19 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
    }

    function logBytes20(bytes20 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
    }

    function logBytes21(bytes21 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
    }

    function logBytes22(bytes22 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
    }

    function logBytes23(bytes23 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
    }

    function logBytes24(bytes24 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
    }

    function logBytes25(bytes25 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
    }

    function logBytes26(bytes26 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
    }

    function logBytes27(bytes27 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
    }

    function logBytes28(bytes28 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
    }

    function logBytes29(bytes29 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
    }

    function logBytes30(bytes30 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
    }

    function logBytes31(bytes31 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
    }

    function logBytes32(bytes32 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
    }

    function log(uint256 p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
    }

    function log(string memory p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
    }

    function log(bool p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
    }

    function log(address p0) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
    }

    function log(uint256 p0, uint256 p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256)", p0, p1));
    }

    function log(uint256 p0, string memory p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string)", p0, p1));
    }

    function log(uint256 p0, bool p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool)", p0, p1));
    }

    function log(uint256 p0, address p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address)", p0, p1));
    }

    function log(string memory p0, uint256 p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
    }

    function log(string memory p0, string memory p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
    }

    function log(string memory p0, bool p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
    }

    function log(string memory p0, address p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
    }

    function log(bool p0, uint256 p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256)", p0, p1));
    }

    function log(bool p0, string memory p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
    }

    function log(bool p0, bool p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
    }

    function log(bool p0, address p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
    }

    function log(address p0, uint256 p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256)", p0, p1));
    }

    function log(address p0, string memory p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
    }

    function log(address p0, bool p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
    }

    function log(address p0, address p1) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
    }

    function log(uint256 p0, uint256 p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256)", p0, p1, p2));
    }

    function log(uint256 p0, uint256 p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string)", p0, p1, p2));
    }

    function log(uint256 p0, uint256 p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool)", p0, p1, p2));
    }

    function log(uint256 p0, uint256 p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address)", p0, p1, p2));
    }

    function log(uint256 p0, string memory p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256)", p0, p1, p2));
    }

    function log(uint256 p0, string memory p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,string)", p0, p1, p2));
    }

    function log(uint256 p0, string memory p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool)", p0, p1, p2));
    }

    function log(uint256 p0, string memory p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,address)", p0, p1, p2));
    }

    function log(uint256 p0, bool p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256)", p0, p1, p2));
    }

    function log(uint256 p0, bool p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string)", p0, p1, p2));
    }

    function log(uint256 p0, bool p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool)", p0, p1, p2));
    }

    function log(uint256 p0, bool p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address)", p0, p1, p2));
    }

    function log(uint256 p0, address p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256)", p0, p1, p2));
    }

    function log(uint256 p0, address p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,string)", p0, p1, p2));
    }

    function log(uint256 p0, address p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool)", p0, p1, p2));
    }

    function log(uint256 p0, address p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,address)", p0, p1, p2));
    }

    function log(string memory p0, uint256 p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256)", p0, p1, p2));
    }

    function log(string memory p0, uint256 p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,string)", p0, p1, p2));
    }

    function log(string memory p0, uint256 p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool)", p0, p1, p2));
    }

    function log(string memory p0, uint256 p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,address)", p0, p1, p2));
    }

    function log(string memory p0, string memory p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,uint256)", p0, p1, p2));
    }

    function log(string memory p0, string memory p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
    }

    function log(string memory p0, string memory p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
    }

    function log(string memory p0, string memory p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
    }

    function log(string memory p0, bool p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256)", p0, p1, p2));
    }

    function log(string memory p0, bool p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
    }

    function log(string memory p0, bool p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
    }

    function log(string memory p0, bool p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
    }

    function log(string memory p0, address p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,uint256)", p0, p1, p2));
    }

    function log(string memory p0, address p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
    }

    function log(string memory p0, address p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
    }

    function log(string memory p0, address p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
    }

    function log(bool p0, uint256 p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256)", p0, p1, p2));
    }

    function log(bool p0, uint256 p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string)", p0, p1, p2));
    }

    function log(bool p0, uint256 p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool)", p0, p1, p2));
    }

    function log(bool p0, uint256 p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address)", p0, p1, p2));
    }

    function log(bool p0, string memory p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256)", p0, p1, p2));
    }

    function log(bool p0, string memory p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
    }

    function log(bool p0, string memory p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
    }

    function log(bool p0, string memory p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
    }

    function log(bool p0, bool p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256)", p0, p1, p2));
    }

    function log(bool p0, bool p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
    }

    function log(bool p0, bool p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
    }

    function log(bool p0, bool p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
    }

    function log(bool p0, address p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256)", p0, p1, p2));
    }

    function log(bool p0, address p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
    }

    function log(bool p0, address p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
    }

    function log(bool p0, address p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
    }

    function log(address p0, uint256 p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256)", p0, p1, p2));
    }

    function log(address p0, uint256 p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,string)", p0, p1, p2));
    }

    function log(address p0, uint256 p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool)", p0, p1, p2));
    }

    function log(address p0, uint256 p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,address)", p0, p1, p2));
    }

    function log(address p0, string memory p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,uint256)", p0, p1, p2));
    }

    function log(address p0, string memory p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
    }

    function log(address p0, string memory p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
    }

    function log(address p0, string memory p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
    }

    function log(address p0, bool p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256)", p0, p1, p2));
    }

    function log(address p0, bool p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
    }

    function log(address p0, bool p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
    }

    function log(address p0, bool p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
    }

    function log(address p0, address p1, uint256 p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,uint256)", p0, p1, p2));
    }

    function log(address p0, address p1, string memory p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
    }

    function log(address p0, address p1, bool p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
    }

    function log(address p0, address p1, address p2) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
    }

    function log(uint256 p0, uint256 p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, uint256 p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, string memory p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, bool p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,address)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,uint256)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,string)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,bool)", p0, p1, p2, p3));
    }

    function log(uint256 p0, address p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, uint256 p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, string memory p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, bool p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint256)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
    }

    function log(string memory p0, address p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,string)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,address)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,string)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,address)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,string)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,address)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,string)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, uint256 p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,address)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,string)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,address)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, string memory p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,string)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,address)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, bool p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,string)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,address)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint256)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
    }

    function log(bool p0, address p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,string)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,bool)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,address)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,string)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,bool)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,address)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,string)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,bool)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,address)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,string)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,bool)", p0, p1, p2, p3));
    }

    function log(address p0, uint256 p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,address)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,string)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,bool)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,address)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
    }

    function log(address p0, string memory p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,string)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,bool)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,address)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
    }

    function log(address p0, bool p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, uint256 p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, uint256 p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,string)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, uint256 p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,bool)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, uint256 p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,address)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, string memory p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, string memory p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, string memory p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, string memory p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, bool p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, bool p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, bool p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, bool p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, address p2, uint256 p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint256)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, address p2, string memory p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, address p2, bool p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
    }

    function log(address p0, address p1, address p2, address p3) internal view {
        _sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
    }
}

interface ICommunityVaultEvents {
    event DXBLRedeemed(address holder, uint dxblAmount, address rewardToken, uint rewardAmount);
}

interface IComputationalView {
    struct AssetInfo {
        address token;
        uint balance;
        uint usdValue;
        uint usdPrice;
    }

    function convertGasToFeeToken(address feeToken, uint gasCost) external view returns (uint);

    function estimateRedemption(address feeToken, uint dxblAmount) external view returns (uint);

    function feeTokenPriceUSD(address feeToken) external view returns (uint);

    function aumUSD() external view returns (uint);

    function currentNavUSD() external view returns (uint);

    function assets() external view returns (AssetInfo[] memory);

    function currentMintRateUSD() external view returns (uint);

    function computeVolumeUSD(address feeToken, uint amount) external view returns (uint);
}

///  Interface for Chainlink oracle feeds
interface IPriceFeed {
    function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

    function decimals() external view returns (uint8);
}

interface IRewardHandler {
    ///  Modification functions
    function rewardTrader(address trader, address feeToken, uint amount) external;
}

interface IStorageView {
    ///  Storage variable view functions
    function isFeeTokenAllowed(address tokens) external view returns (bool);

    function discountBps() external view returns (uint32);

    function dailyVolumeUSD() external view returns (uint);

    function paused() external view returns (bool);

    function adminMultiSig() external view returns (address);

    function dxblToken() external view returns (address);

    function dexibleContract() external view returns (address);

    function wrappedNativeToken() external view returns (address);

    function timelockSeconds() external view returns (uint32);

    function baseMintThreshold() external view returns (uint);
}

///  @dev Interface for the optional metadata functions from the ERC20 standard.
///  _Available since v4.1._
interface IERC20Metadata is IERC20 {
    ///  @dev Returns the name of the token.
    function name() external view returns (string memory);

    ///  @dev Returns the symbol of the token.
    function symbol() external view returns (string memory);

    ///  @dev Returns the decimals places of the token.
    function decimals() external view returns (uint8);
}

///  @dev String operations.
library Strings {
    bytes16 private constant _SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    ///  @dev Converts a `uint256` to its ASCII `string` decimal representation.
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    ///  @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    ///  @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes((2 * length) + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = (2 * length) + 1; i > 1; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    ///  @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}

interface IDXBL is IERC20, IERC20Metadata {
    struct FeeRequest {
        bool referred;
        address trader;
        uint amt;
        uint dxblBalance;
        uint16 stdBpsRate;
        uint16 minBpsRate;
    }

    function minter() external view returns (address);

    function discountPerTokenBps() external view returns (uint32);

    function mint(address acct, uint amt) external;

    function burn(address holder, uint amt) external;

    function setDiscountRate(uint32 discount) external;

    function setNewMinter(address minter) external;

    function computeDiscountedFee(FeeRequest calldata request) external view returns (uint);
}

///  @dev Implementation of the {IERC20} interface.
///  This implementation is agnostic to the way tokens are created. This means
///  that a supply mechanism has to be added in a derived contract using {_mint}.
///  For a generic mechanism see {ERC20PresetMinterPauser}.
///  TIP: For a detailed writeup see our guide
///  https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
///  to implement supply mechanisms].
///  We have followed general OpenZeppelin Contracts guidelines: functions revert
///  instead returning `false` on failure. This behavior is nonetheless
///  conventional and does not conflict with the expectations of ERC20
///  applications.
///  Additionally, an {Approval} event is emitted on calls to {transferFrom}.
///  This allows applications to reconstruct the allowance for all accounts just
///  by listening to said events. Other implementations of the EIP may not emit
///  these events, as it isn't required by the specification.
///  Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
///  functions have been added to mitigate the well-known issues around setting
///  allowances. See {IERC20-approve}.
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    ///  @dev Sets the values for {name} and {symbol}.
    ///  The default value of {decimals} is 18. To select a different value for
    ///  {decimals} you should overload it.
    ///  All two of these values are immutable: they can only be set once during
    ///  construction.
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    ///  @dev Returns the name of the token.
    function name() virtual override public view returns (string memory) {
        return _name;
    }

    ///  @dev Returns the symbol of the token, usually a shorter version of the
    ///  name.
    function symbol() virtual override public view returns (string memory) {
        return _symbol;
    }

    ///  @dev Returns the number of decimals used to get its user representation.
    ///  For example, if `decimals` equals `2`, a balance of `505` tokens should
    ///  be displayed to a user as `5.05` (`505 / 10 ** 2`).
    ///  Tokens usually opt for a value of 18, imitating the relationship between
    ///  Ether and Wei. This is the value {ERC20} uses, unless this function is
    ///  overridden;
    ///  NOTE: This information is only used for _display_ purposes: it in
    ///  no way affects any of the arithmetic of the contract, including
    ///  {IERC20-balanceOf} and {IERC20-transfer}.
    function decimals() virtual override public view returns (uint8) {
        return 18;
    }

    ///  @dev See {IERC20-totalSupply}.
    function totalSupply() virtual override public view returns (uint256) {
        return _totalSupply;
    }

    ///  @dev See {IERC20-balanceOf}.
    function balanceOf(address account) virtual override public view returns (uint256) {
        return _balances[account];
    }

    ///  @dev See {IERC20-transfer}.
    ///  Requirements:
    ///  - `to` cannot be the zero address.
    ///  - the caller must have a balance of at least `amount`.
    function transfer(address to, uint256 amount) virtual override public returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    ///  @dev See {IERC20-allowance}.
    function allowance(address owner, address spender) virtual override public view returns (uint256) {
        return _allowances[owner][spender];
    }

    ///  @dev See {IERC20-approve}.
    ///  NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
    ///  `transferFrom`. This is semantically equivalent to an infinite approval.
    ///  Requirements:
    ///  - `spender` cannot be the zero address.
    function approve(address spender, uint256 amount) virtual override public returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    ///  @dev See {IERC20-transferFrom}.
    ///  Emits an {Approval} event indicating the updated allowance. This is not
    ///  required by the EIP. See the note at the beginning of {ERC20}.
    ///  NOTE: Does not update the allowance if the current allowance
    ///  is the maximum `uint256`.
    ///  Requirements:
    ///  - `from` and `to` cannot be the zero address.
    ///  - `from` must have a balance of at least `amount`.
    ///  - the caller must have allowance for ``from``'s tokens of at least
    ///  `amount`.
    function transferFrom(address from, address to, uint256 amount) virtual override public returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    ///  @dev Atomically increases the allowance granted to `spender` by the caller.
    ///  This is an alternative to {approve} that can be used as a mitigation for
    ///  problems described in {IERC20-approve}.
    ///  Emits an {Approval} event indicating the updated allowance.
    ///  Requirements:
    ///  - `spender` cannot be the zero address.
    function increaseAllowance(address spender, uint256 addedValue) virtual public returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    ///  @dev Atomically decreases the allowance granted to `spender` by the caller.
    ///  This is an alternative to {approve} that can be used as a mitigation for
    ///  problems described in {IERC20-approve}.
    ///  Emits an {Approval} event indicating the updated allowance.
    ///  Requirements:
    ///  - `spender` cannot be the zero address.
    ///  - `spender` must have allowance for the caller of at least
    ///  `subtractedValue`.
    function decreaseAllowance(address spender, uint256 subtractedValue) virtual public returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    ///  @dev Moves `amount` of tokens from `from` to `to`.
    ///  This internal function is equivalent to {transfer}, and can be used to
    ///  e.g. implement automatic token fees, slashing mechanisms, etc.
    ///  Emits a {Transfer} event.
    ///  Requirements:
    ///  - `from` cannot be the zero address.
    ///  - `to` cannot be the zero address.
    ///  - `from` must have a balance of at least `amount`.
    function _transfer(address from, address to, uint256 amount) virtual internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        _beforeTokenTransfer(from, to, amount);
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    /// @dev Creates `amount` tokens and assigns them to `account`, increasing
    ///  the total supply.
    ///  Emits a {Transfer} event with `from` set to the zero address.
    ///  Requirements:
    ///  - `account` cannot be the zero address.
    function _mint(address account, uint256 amount) virtual internal {
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    ///  @dev Destroys `amount` tokens from `account`, reducing the
    ///  total supply.
    ///  Emits a {Transfer} event with `to` set to the zero address.
    ///  Requirements:
    ///  - `account` cannot be the zero address.
    ///  - `account` must have at least `amount` tokens.
    function _burn(address account, uint256 amount) virtual internal {
        require(account != address(0), "ERC20: burn from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            _totalSupply -= amount;
        }
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);
    }

    ///  @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
    ///  This internal function is equivalent to `approve`, and can be used to
    ///  e.g. set automatic allowances for certain subsystems, etc.
    ///  Emits an {Approval} event.
    ///  Requirements:
    ///  - `owner` cannot be the zero address.
    ///  - `spender` cannot be the zero address.
    function _approve(address owner, address spender, uint256 amount) virtual internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    ///  @dev Updates `owner` s allowance for `spender` based on spent `amount`.
    ///  Does not update the allowance amount in case of infinite allowance.
    ///  Revert if not enough allowance is available.
    ///  Might emit an {Approval} event.
    function _spendAllowance(address owner, address spender, uint256 amount) virtual internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    ///  @dev Hook that is called before any transfer of tokens. This includes
    ///  minting and burning.
    ///  Calling conditions:
    ///  - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
    ///  will be transferred to `to`.
    ///  - when `from` is zero, `amount` tokens will be minted for `to`.
    ///  - when `to` is zero, `amount` of ``from``'s tokens will be burned.
    ///  - `from` and `to` are never both zero.
    ///  To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
    function _beforeTokenTransfer(address from, address to, uint256 amount) virtual internal {}

    ///  @dev Hook that is called after any transfer of tokens. This includes
    ///  minting and burning.
    ///  Calling conditions:
    ///  - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
    ///  has been transferred to `to`.
    ///  - when `from` is zero, `amount` tokens have been minted for `to`.
    ///  - when `to` is zero, `amount` of ``from``'s tokens have been burned.
    ///  - `from` and `to` are never both zero.
    ///  To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
    function _afterTokenTransfer(address from, address to, uint256 amount) virtual internal {}
}

///  @title SafeERC20
///  @dev Wrappers around ERC20 operations that throw on failure (when the token
///  contract returns false). Tokens that return no value (and instead revert or
///  throw on failure) are also supported, non-reverting calls are assumed to be
///  successful.
///  To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
///  which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
library SafeERC20 {
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    ///  @dev Deprecated. This function has issues similar to the ones found in
    ///  {IERC20-approve}, and its usage is discouraged.
    ///  Whenever possible, use {safeIncreaseAllowance} and
    ///  {safeDecreaseAllowance} instead.
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(IERC20Permit token, address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == (nonceBefore + 1), "SafeERC20: permit did not succeed");
    }

    ///  @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
    ///  on the return value: the return value is optional (but if data is returned, it must not be false).
    ///  @param token The token targeted by the call.
    ///  @param data The call data (encoded using abi.encode or one of its variants).
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

library TokenTypes {
    struct TokenAmount {
        uint112 amount;
        IERC20 token;
    }
}

library VaultStorage {
    struct MintRateRangeConfig {
        uint16 minMMVolume;
        uint16 maxMMVolume;
        uint rate;
    }

    struct FeeTokenConfig {
        address[] feeTokens;
        address[] priceFeeds;
    }

    struct VaultConfig {
        address wrappedNativeToken;
        address adminMultiSig;
        uint32 timelockSeconds;
        uint baseMintThreshold;
        MintRateRangeConfig[] rateRanges;
        FeeTokenConfig feeTokenConfig;
    }

    struct MintRateRange {
        uint16 minMMVolume;
        uint16 maxMMVolume;
        uint rate;
        uint index;
    }

    struct PriceFeed {
        IPriceFeed feed;
        uint8 decimals;
    }

    struct VaultData {
        bool paused;
        address adminMultiSig;
        IDXBL dxbl;
        address dexible;
        address wrappedNativeToken;
        address pendingMigrationTarget;
        uint32 timelockSeconds;
        uint baseMintThreshold;
        uint currentVolume;
        uint lastTradeTimestamp;
        uint migrateAfterTime;
        IERC20[] feeTokens;
        MintRateRange currentMintRate;
        MintRateRange[] mintRateRanges;
        uint[24] hourlyVolume;
        mapping(address => uint8) tokenDecimals;
        mapping(address => PriceFeed) allowedFeeTokens;
    }

    struct VaultMigrationV1 {
        uint currentVolume;
        uint lastTradeTimestamp;
        uint[24] hourlyVolume;
        MintRateRange currentMintRate;
    }

    bytes32 internal constant VAULT_STORAGE_KEY = 0xbfa76ec2967ed7f8d3d40cd552f1451ab03573b596bfce931a6a016f7733078c;

    function load() internal pure returns (VaultData storage ds) {
        assembly {
            ds.slot := VAULT_STORAGE_KEY
        }
    }
}

///  These types only relevant for relay-based submissions through protocol
library ExecutionTypes {
    struct FeeDetails {
        IERC20 feeToken;
        address affiliate;
        uint affiliatePortion;
    }

    struct ExecutionRequest {
        address requester;
        FeeDetails fee;
    }
}

interface V1MigrationTarget {
    ///  Call from current vault to migrate the state of the old vault to the new one.
    function migrationFromV1(VaultStorage.VaultMigrationV1 memory data) external;
}

interface V1Migrateable {
    event MigrationScheduled(address indexed newVault, uint afterTime);

    event MigrationCancelled(address indexed newVault);

    event VaultMigrated(address indexed newVault);

    function scheduleMigration(V1MigrationTarget target) external;

    function cancelMigration() external;

    function canMigrate() external view returns (bool);

    ///  Migrate the vault to a new vault address that implements the target interface
    ///  to receive this vault's state. This will transfer all fee token assets to the
    ///  new vault. This can only be called after timelock is expired.
    function migrateV1() external;
}

///  Swap data strutures to submit for execution
library SwapTypes {
    struct RouterRequest {
        address router;
        address spender;
        TokenTypes.TokenAmount routeAmount;
        bytes routerData;
    }

    struct SwapRequest {
        ExecutionTypes.ExecutionRequest executionRequest;
        TokenTypes.TokenAmount tokenIn;
        TokenTypes.TokenAmount tokenOut;
        RouterRequest[] routes;
    }

    struct SelfSwap {
        IERC20 feeToken;
        TokenTypes.TokenAmount tokenIn;
        TokenTypes.TokenAmount tokenOut;
        RouterRequest[] routes;
    }
}

interface ISwapHandler is IDexibleEvents {
    function swap(SwapTypes.SwapRequest calldata request) external;

    function selfSwap(SwapTypes.SelfSwap calldata request) external;
}

interface ICommunityVault is IStorageView, IComputationalView, IRewardHandler, ICommunityVaultEvents, IPausable, V1Migrateable {
    function redeemDXBL(address feeToken, uint dxblAmount, uint minOutAmount, bool unwrapNative) external;
}

interface IDexibleConfig is IPausable {
    event SplitRatioChanged(uint8 newRate);

    event StdBpsChanged(uint16 newRate);

    event MinBpsChanged(uint16 newRate);

    event MinFeeChanged(uint112 newMin);

    event VaultChanged(address newVault);

    event TreasuryChanged(address newTreasury);

    event ArbGasOracleChanged(address newVault);

    function setRevshareSplitRatio(uint8 bps) external;

    function setStdBpsRate(uint16 bps) external;

    function setMinBpsRate(uint16 bps) external;

    function setMinFeeUSD(uint112 minFee) external;

    function setCommunityVault(ICommunityVault vault) external;

    function setTreasury(address t) external;

    function setArbitrumGasOracle(IArbitrumGasOracle oracle) external;
}

library DexibleStorage {
    struct DexibleConfig {
        uint8 revshareSplitRatio;
        uint16 stdBpsRate;
        uint16 minBpsRate;
        address adminMultiSig;
        address communityVault;
        address treasury;
        address dxblToken;
        address arbGasOracle;
        address stdGasAdjustment;
        uint112 minFeeUSD;
        address[] initialRelays;
    }

    struct DexibleData {
        bool paused;
        uint8 revshareSplitRatio;
        uint16 stdBpsRate;
        uint16 minBpsRate;
        uint112 minFeeUSD;
        ICommunityVault communityVault;
        address treasury;
        address adminMultiSig;
        IDXBL dxblToken;
        IArbitrumGasOracle arbitrumGasOracle;
        IStandardGasAdjustments stdGasAdjustment;
        mapping(address => bool) relays;
    }

    bytes32 internal constant DEXIBLE_STORAGE_KEY = 0x949817a987a8e038ef345d3c9d4fd28e49d8e4e09456e57c05a8b2ce2e62866c;

    function load() internal pure returns (DexibleData storage ds) {
        assembly {
            ds.slot := DEXIBLE_STORAGE_KEY
        }
    }
}

abstract contract AdminBase {
    modifier notPaused() {
        require(!DexibleStorage.load().paused, "Contract operations are paused");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == DexibleStorage.load().adminMultiSig, "Unauthorized");
        _;
    }

    modifier onlyVault() {
        require(msg.sender == address(DexibleStorage.load().communityVault), "Only vault can execute this function");
        _;
    }

    modifier onlyRelay() {
        DexibleStorage.DexibleData storage dd = DexibleStorage.load();
        require(dd.relays[msg.sender], "Only relay allowed to call");
        _;
    }

    modifier onlySelf() {
        require(msg.sender == address(this), "Only allowed as internal call");
        _;
    }
}

abstract contract DexibleView is IDexibleView {
    function revshareSplitRatio() external view returns (uint8) {
        return DexibleStorage.load().revshareSplitRatio;
    }

    function stdBpsRate() external view returns (uint16) {
        return DexibleStorage.load().stdBpsRate;
    }

    function minBpsRate() external view returns (uint16) {
        return DexibleStorage.load().minBpsRate;
    }

    function minFeeUSD() external view returns (uint112) {
        return DexibleStorage.load().minFeeUSD;
    }

    function communityVault() external view returns (address) {
        return address(DexibleStorage.load().communityVault);
    }

    function adminMultiSig() external view returns (address) {
        return DexibleStorage.load().adminMultiSig;
    }

    function treasury() external view returns (address) {
        return DexibleStorage.load().treasury;
    }

    function dxblToken() external view returns (address) {
        return address(DexibleStorage.load().dxblToken);
    }

    function arbitrumGasOracle() external view returns (address) {
        return address(DexibleStorage.load().arbitrumGasOracle);
    }

    function stdGasAdjustmentContract() external view returns (address) {
        return address(DexibleStorage.load().stdGasAdjustment);
    }
}

abstract contract ConfigBase is AdminBase, IDexibleConfig {
    event ConfigChanged(DexibleStorage.DexibleConfig config);

    event RelayAdded(address relay);

    event RelayRemoved(address relay);

    event StdGasAdjustmentChanged(address newContract);

    function configure(DexibleStorage.DexibleConfig calldata config) public {
        DexibleStorage.DexibleData storage ds = DexibleStorage.load();
        if (ds.adminMultiSig != address(0)) {
            require(msg.sender == ds.adminMultiSig, "Unauthorized");
        }
        require(config.communityVault != address(0), "Invalid CommunityVault address");
        require(config.treasury != address(0), "Invalid treasury");
        require(config.dxblToken != address(0), "Invalid DXBL token address");
        require(config.revshareSplitRatio > 0, "Invalid revshare split ratio");
        require(config.stdBpsRate > 0, "Must provide a standard bps fee rate");
        require(config.minBpsRate > 0, "minBpsRate is required");
        require(config.minBpsRate < config.stdBpsRate, "Min bps rate must be less than std");
        require(config.stdGasAdjustment != address(0), "Invalid stdGasAdjustment address");
        ds.adminMultiSig = config.adminMultiSig;
        ds.revshareSplitRatio = config.revshareSplitRatio;
        ds.communityVault = ICommunityVault(config.communityVault);
        ds.treasury = config.treasury;
        ds.dxblToken = IDXBL(config.dxblToken);
        ds.stdBpsRate = config.stdBpsRate;
        ds.minBpsRate = config.minBpsRate;
        ds.minFeeUSD = config.minFeeUSD;
        ds.arbitrumGasOracle = IArbitrumGasOracle(config.arbGasOracle);
        ds.stdGasAdjustment = IStandardGasAdjustments(config.stdGasAdjustment);
        for (uint i = 0; i < config.initialRelays.length; ++i) {
            ds.relays[config.initialRelays[i]] = true;
        }
        emit ConfigChanged(config);
    }

    function addRelays(address[] calldata relays) external onlyAdmin() {
        DexibleStorage.DexibleData storage ds = DexibleStorage.load();
        for (uint i = 0; i < relays.length; ++i) {
            ds.relays[relays[i]] = true;
            emit RelayAdded(relays[i]);
        }
    }

    function removeRelay(address relay) external onlyAdmin() {
        DexibleStorage.DexibleData storage ds = DexibleStorage.load();
        delete ds.relays[relay];
        emit RelayRemoved(relay);
    }

    function setRevshareSplitRatio(uint8 bps) external onlyAdmin() {
        DexibleStorage.load().revshareSplitRatio = bps;
        emit SplitRatioChanged(bps);
    }

    function setStdBpsRate(uint16 bps) external onlyAdmin() {
        DexibleStorage.load().stdBpsRate = bps;
        emit StdBpsChanged(bps);
    }

    function setMinBpsRate(uint16 bps) external onlyAdmin() {
        DexibleStorage.load().minBpsRate = bps;
        emit MinBpsChanged(bps);
    }

    function setMinFeeUSD(uint112 minFee) external onlyAdmin() {
        DexibleStorage.load().minFeeUSD = minFee;
        emit MinFeeChanged(minFee);
    }

    function setCommunityVault(ICommunityVault vault) external onlyVault() {
        DexibleStorage.load().communityVault = vault;
        emit VaultChanged(address(vault));
    }

    function setTreasury(address t) external onlyAdmin() {
        DexibleStorage.load().treasury = t;
        emit TreasuryChanged(t);
    }

    function setArbitrumGasOracle(IArbitrumGasOracle oracle) external onlyAdmin() {
        DexibleStorage.load().arbitrumGasOracle = oracle;
        emit ArbGasOracleChanged(address(oracle));
    }

    function pause() external onlyAdmin() {
        DexibleStorage.load().paused = true;
        emit Paused();
    }

    function resume() external onlyAdmin() {
        DexibleStorage.load().paused = false;
        emit Resumed();
    }

    function setStdGasAdjustmentContract(address con) external onlyAdmin() {
        require(con != address(0), "Invalid contract address");
        DexibleStorage.load().stdGasAdjustment = IStandardGasAdjustments(con);
        emit StdGasAdjustmentChanged(con);
    }
}

library LibFees {
    uint internal constant ARB = 42161;
    uint internal constant OPT = 10;
    IOptimismGasOracle internal constant optGasOracle = IOptimismGasOracle(0x420000000000000000000000000000000000000F);

    function computeGasCost(uint gasUsed, bool success) internal view returns (uint) {
        DexibleStorage.DexibleData storage ds = DexibleStorage.load();
        uint add = ds.stdGasAdjustment.adjustment(success ? LibConstants.SWAP_SUCCESS : LibConstants.SWAP_FAILURE);
        gasUsed += add;
        uint cid;
        assembly {
            cid := chainid()
        }
        if (cid == ARB) {
            return ds.arbitrumGasOracle.calculateGasCost(msg.data.length, gasUsed);
        }
        if (cid == OPT) {
            return (tx.gasprice * gasUsed) + optGasOracle.getL1Fee(msg.data);
        }
        return tx.gasprice * gasUsed;
    }

    function computeMinFeeUnits(address feeToken) internal view returns (uint) {
        DexibleStorage.DexibleData storage rs = DexibleStorage.load();
        if (rs.minFeeUSD == 0) {
            return 0;
        }
        uint usdPrice = rs.communityVault.feeTokenPriceUSD(feeToken);
        uint8 ftDecs = IERC20Metadata(feeToken).decimals();
        uint minFeeUSD = (rs.minFeeUSD * ((ftDecs != 18) ? ((10 ** ftDecs) / 1e18) : 1)) * LibConstants.PRICE_PRECISION;
        return minFeeUSD / usdPrice;
    }
}

interface IDexible is IDexibleView, IDexibleConfig, ISwapHandler {}

abstract contract SwapHandler is AdminBase, ISwapHandler {
    using SafeERC20 for IERC20;

    struct SwapMeta {
        bool feeIsInput;
        bool isSelfSwap;
        address preSwapVault;
        uint startGas;
        uint toProtocol;
        uint toRevshare;
        uint outToTrader;
        uint outAmount;
        uint bpsAmount;
        uint gasAmount;
        uint nativeGasAmount;
        uint preDXBLBalance;
        uint inputAmountDue;
    }

    function _checkRequest(SwapTypes.SwapRequest calldata request) internal returns (bool) {
        uint256 n = request.routes.length;
        for (uint i = 0; i < n; ++i) {
            SwapTypes.RouterRequest calldata rr = request.routes[i];
            if (bytes4(rr.routerData[:4]) == bytes4(0x23b872dd)) {
                return false;
            }
        }
        return true;
    }

    /// @custom:consol
    ///  {fill(request, meta1) returns (meta2)
    ///      requires {_checkRequest(request)}
    ///      ensures {meta2.outAmount >= request.tokenOut.amount}}
    function fill_original(SwapTypes.SwapRequest calldata request, SwapMeta memory meta) private onlySelf() returns (SwapMeta memory) {
        preCheck(request, meta);
        meta.outAmount = request.tokenOut.token.balanceOf(address(this));
        for (uint i = 0; i < request.routes.length; ++i) {
            SwapTypes.RouterRequest calldata rr = request.routes[i];
            IERC20(rr.routeAmount.token).safeApprove(rr.spender, rr.routeAmount.amount);
            (bool s, ) = rr.router.call(rr.routerData);
            if (!s) {
                revert("Failed to swap");
            }
        }
        uint out = request.tokenOut.token.balanceOf(address(this));
        if (meta.outAmount < out) {
            meta.outAmount = out - meta.outAmount;
        } else {
            meta.outAmount = 0;
        }
        console.log("Expected", request.tokenOut.amount, "Received", meta.outAmount);
        require(meta.outAmount >= request.tokenOut.amount, "Insufficient output generated");
        return meta;
    }

    function postFill(SwapTypes.SwapRequest memory request, SwapMeta memory meta, bool success) internal {
        if (success) {
            handleSwapSuccess(request, meta);
        } else {
            handleSwapFailure(request, meta);
        }
        payRelayGas(meta.nativeGasAmount);
    }

    ///  When a relay-based swap fails, we need to account for failure gas fees if the input
    ///  token is the fee token. That's what this function does
    function handleSwapFailure(SwapTypes.SwapRequest memory request, SwapMeta memory meta) internal {
        DexibleStorage.DexibleData storage dd = DexibleStorage.load();
        uint gasInFeeToken = 0;
        if (meta.feeIsInput) {
            unchecked {
                uint totalGas = (meta.startGas - gasleft());
                console.log("Estimated gas used for failed gas payment", totalGas);
                meta.nativeGasAmount = LibFees.computeGasCost(totalGas, false);
            }
            gasInFeeToken = dd.communityVault.convertGasToFeeToken(address(request.executionRequest.fee.feeToken), meta.nativeGasAmount);
            request.executionRequest.fee.feeToken.safeTransferFrom(request.executionRequest.requester, dd.treasury, gasInFeeToken);
        }
        emit SwapFailed(request.executionRequest.requester, address(request.executionRequest.fee.feeToken), gasInFeeToken);
    }

    ///  This is called when a relay-based swap is successful. It basically rewards DXBL tokens
    ///  to trader and pays appropriate fees.
    function handleSwapSuccess(SwapTypes.SwapRequest memory request, SwapMeta memory meta) internal {
        collectDXBL(request, meta.feeIsInput, meta.outAmount);
        payAndDistribute(request, meta);
    }

    ///  Reward DXBL to the trader
    function collectDXBL(SwapTypes.SwapRequest memory request, bool feeIsInput, uint outAmount) internal {
        DexibleStorage.DexibleData storage dd = DexibleStorage.load();
        uint value = 0;
        if (feeIsInput) {
            value = request.tokenIn.amount;
        } else {
            value = outAmount;
        }
        dd.communityVault.rewardTrader(request.executionRequest.requester, address(request.executionRequest.fee.feeToken), value);
    }

    ///  Distribute payments to revshare pool, affiliates, treasury, and trader
    function payAndDistribute(SwapTypes.SwapRequest memory request, SwapMeta memory meta) internal {
        allocateRevshareAndAffiliate(request, meta);
        payProtocolAndTrader(request, meta);
    }

    ///  Allocate bps portions to revshare pool and any associated affiliate
    function allocateRevshareAndAffiliate(SwapTypes.SwapRequest memory request, SwapMeta memory meta) internal view {
        DexibleStorage.DexibleData storage dd = DexibleStorage.load();
        meta.outToTrader = meta.outAmount;
        meta.bpsAmount = computeBpsFee(request, meta.feeIsInput, meta.preDXBLBalance, meta.outAmount);
        uint minFee = LibFees.computeMinFeeUnits(address(request.executionRequest.fee.feeToken));
        if (minFee > meta.bpsAmount) {
            meta.bpsAmount = minFee;
        }
        meta.toRevshare = (meta.bpsAmount * dd.revshareSplitRatio) / 100;
        require(request.executionRequest.fee.affiliatePortion < (meta.bpsAmount - meta.toRevshare), "Miscalculated affiliate portion");
        meta.toProtocol = (meta.bpsAmount - meta.toRevshare) - request.executionRequest.fee.affiliatePortion;
        uint total = (meta.toRevshare + meta.toProtocol) + request.executionRequest.fee.affiliatePortion;
        if (!meta.feeIsInput) {
            if (meta.outAmount < total) {
                revert(string(abi.encodePacked(_concatUintString("Insufficient output to pay bps fees. Required: ", total), _concatUintString(" Output amount: ", meta.outAmount))));
            }
            meta.outToTrader = meta.outAmount - total;
        } else {
            meta.inputAmountDue = total;
        }
    }

    ///  Final step to compute gas consumption for trader and pay the vault, protocol, affiliate, and trader
    ///  their portions.
    function payProtocolAndTrader(SwapTypes.SwapRequest memory request, SwapMeta memory meta) internal {
        DexibleStorage.DexibleData storage dd = DexibleStorage.load();
        if (!meta.isSelfSwap) {
            unchecked {
                uint totalGas = (meta.startGas - gasleft());
                if ((address(dd.communityVault) != meta.preSwapVault) && (totalGas > 200_000)) {
                    totalGas -= 200_000;
                }
                console.log("Estimated gas used for trader gas payment", totalGas);
                meta.nativeGasAmount = LibFees.computeGasCost(totalGas, true);
            }
            meta.gasAmount = dd.communityVault.convertGasToFeeToken(address(request.executionRequest.fee.feeToken), meta.nativeGasAmount);
            meta.toProtocol += meta.gasAmount;
            if (!meta.feeIsInput) {
                if (meta.outToTrader <= meta.gasAmount) {
                    revert(string(abi.encodePacked(_concatUintString("Insufficient output to pay gas fees. Required: ", meta.gasAmount), _concatUintString(" Trader output proceeds: ", meta.outToTrader))));
                }
                meta.outToTrader -= meta.gasAmount;
            } else {
                meta.inputAmountDue += meta.gasAmount;
            }
        }
        IERC20 feeToken = request.executionRequest.fee.feeToken;
        if (meta.feeIsInput) {
            uint totalInputSpent = request.routes[0].routeAmount.amount + meta.inputAmountDue;
            if (totalInputSpent > request.tokenIn.amount) {
                revert(string(abi.encodePacked(_concatUintString("Attempt to spend more input than anticipated. Total required: ", totalInputSpent), _concatUintString(" Max input: ", request.tokenIn.amount))));
            }
            feeToken.safeTransferFrom(request.executionRequest.requester, dd.treasury, meta.toProtocol);
            feeToken.safeTransferFrom(request.executionRequest.requester, address(dd.communityVault), meta.toRevshare);
            if (request.executionRequest.fee.affiliatePortion > 0) {
                feeToken.safeTransferFrom(request.executionRequest.requester, request.executionRequest.fee.affiliate, request.executionRequest.fee.affiliatePortion);
                emit AffiliatePaid(request.executionRequest.fee.affiliate, address(feeToken), request.executionRequest.fee.affiliatePortion);
            }
        } else {
            feeToken.safeTransfer(dd.treasury, meta.toProtocol);
            feeToken.safeTransfer(address(dd.communityVault), meta.toRevshare);
            if (request.executionRequest.fee.affiliatePortion > 0) {
                feeToken.safeTransfer(request.executionRequest.fee.affiliate, request.executionRequest.fee.affiliatePortion);
                emit AffiliatePaid(request.executionRequest.fee.affiliate, address(feeToken), request.executionRequest.fee.affiliatePortion);
            }
        }
        request.tokenOut.token.safeTransfer(request.executionRequest.requester, meta.outToTrader);
        emit SwapSuccess(request.executionRequest.requester, request.executionRequest.fee.affiliate, request.tokenOut.amount, meta.outToTrader, address(request.executionRequest.fee.feeToken), meta.gasAmount, request.executionRequest.fee.affiliatePortion, meta.bpsAmount);
    }

    function preCheck(SwapTypes.SwapRequest calldata request, SwapMeta memory meta) internal {
        address fToken = address(request.executionRequest.fee.feeToken);
        DexibleStorage.DexibleData storage dd = DexibleStorage.load();
        require(dd.communityVault.isFeeTokenAllowed(fToken), "Fee token is not allowed");
        require((fToken == address(request.tokenIn.token)) || (fToken == address(request.tokenOut.token)), "Fee token must be input or output token");
        meta.preDXBLBalance = dd.dxblToken.balanceOf(request.executionRequest.requester);
        meta.feeIsInput = address(request.tokenIn.token) == address(request.executionRequest.fee.feeToken);
        request.tokenIn.token.safeTransferFrom(request.executionRequest.requester, address(this), request.routes[0].routeAmount.amount);
    }

    ///  Pay the relay with gas funds stored in this contract. The gas used provided
    ///  does not include arbitrum multiplier but may include additional amount for post-op
    ///  gas estimates.
    function payRelayGas(uint gasFee) internal {
        if (gasFee == 0) {
            return;
        }
        if (address(this).balance < gasFee) {
            emit InsufficientGasFunds(msg.sender, gasFee);
        } else {
            payable(msg.sender).transfer(gasFee);
            emit PaidGasFunds(msg.sender, gasFee);
        }
    }

    ///  Compute the bps to charge for the swap. This leverages the DXBL token to compute discounts
    ///  based on trader balances and discount rates applied per DXBL token.
    function computeBpsFee(SwapTypes.SwapRequest memory request, bool feeIsInput, uint preDXBL, uint outAmount) internal view returns (uint) {
        DexibleStorage.DexibleData storage ds = DexibleStorage.load();
        return ds.dxblToken.computeDiscountedFee(IDXBL.FeeRequest({trader: request.executionRequest.requester, amt: feeIsInput ? request.tokenIn.amount : outAmount, referred: request.executionRequest.fee.affiliate != address(0), dxblBalance: preDXBL, stdBpsRate: ds.stdBpsRate, minBpsRate: ds.minBpsRate}));
    }

    function _concatUintString(string memory s, uint val) private pure returns (string memory) {
        return string(abi.encodePacked(s, Strings.toString(val)));
    }

    function _fill_pre(SwapTypes.SwapRequest calldata request, SwapMeta memory meta1) private {
        if (!(_checkRequest(request))) revert();
    }

    function _fill_post(SwapTypes.SwapRequest calldata request, SwapMeta memory meta1, SwapMeta memory meta2) private {
        if (!(meta2.outAmount>=request.tokenOut.amount)) revert();
    }

    function fill(SwapTypes.SwapRequest calldata request, SwapMeta memory meta) external returns (SwapMeta memory) {
        _fill_pre(request, meta);
        SwapMeta meta2 = fill_original(request, meta);
        _fill_post(request, meta, meta2);
        return (meta2);
    }
}

contract Dexible is DexibleView, ConfigBase, SwapHandler, IDexible {
    event ReceivedFunds(address from, uint amount);

    event WithdrewETH(address indexed admin, uint amount);

    function initialize(DexibleStorage.DexibleConfig calldata config) public {
        configure(config);
    }

    receive() external payable {
        emit ReceivedFunds(msg.sender, msg.value);
    }

    function swap(SwapTypes.SwapRequest calldata request) external onlyRelay() notPaused() {
        uint startGas = gasleft();
        SwapMeta memory details = SwapMeta({feeIsInput: false, isSelfSwap: false, startGas: startGas, preSwapVault: address(DexibleStorage.load().communityVault), bpsAmount: 0, gasAmount: 0, nativeGasAmount: 0, toProtocol: 0, toRevshare: 0, outToTrader: 0, preDXBLBalance: 0, outAmount: 0, inputAmountDue: 0});
        bool success = false;
        try this.fill{gas: gasleft() - 80_000}(request, details) returns (SwapMeta memory sd) {
            details = sd;
            success = true;
        } catch {
            console.log("Swap failed");
            success = false;
        }
        postFill(request, details, success);
    }

    function selfSwap(SwapTypes.SelfSwap calldata request) external notPaused() {
        SwapTypes.SwapRequest memory swapReq = SwapTypes.SwapRequest({executionRequest: ExecutionTypes.ExecutionRequest({fee: ExecutionTypes.FeeDetails({feeToken: request.feeToken, affiliate: address(0), affiliatePortion: 0}), requester: msg.sender}), tokenIn: request.tokenIn, tokenOut: request.tokenOut, routes: request.routes});
        SwapMeta memory details = SwapMeta({feeIsInput: false, isSelfSwap: true, startGas: 0, preSwapVault: address(DexibleStorage.load().communityVault), bpsAmount: 0, gasAmount: 0, nativeGasAmount: 0, toProtocol: 0, toRevshare: 0, outToTrader: 0, preDXBLBalance: 0, outAmount: 0, inputAmountDue: 0});
        details = this.fill(swapReq, details);
        postFill(swapReq, details, true);
    }

    function withdraw(uint amount) public onlyAdmin() {
        address payable rec = payable(msg.sender);
        require(rec.send(amount), "Transfer failed");
        emit WithdrewETH(msg.sender, amount);
    }
}
