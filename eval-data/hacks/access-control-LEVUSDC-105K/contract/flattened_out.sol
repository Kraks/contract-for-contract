pragma solidity ^0.8.0^0.8.1^0.8.10^0.8.2^0.8.9;

///  @dev Collection of functions related to the address type
library AddressUpgradeable {
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

interface CurveContractInterface {}

///  @title ERC 20 Token Standard Interface
///   https://eips.ethereum.org/EIPS/eip-20
interface EIP20Interface {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    ///  @notice Get the total number of tokens in circulation
    ///  @return The supply of tokens
    function totalSupply() external view returns (uint256);

    ///  @notice Gets the balance of the specified address
    ///  @param owner The address from which the balance will be retrieved
    ///  @return balance The balance
    function balanceOf(address owner) external view returns (uint256 balance);

    ///  @notice Transfer `amount` tokens from `msg.sender` to `dst`
    ///  @param dst The address of the destination account
    ///  @param amount The number of tokens to transfer
    ///  @return success Whether or not the transfer succeeded
    function transfer(address dst, uint256 amount) external returns (bool success);

    ///  @notice Transfer `amount` tokens from `src` to `dst`
    ///  @param src The address of the source account
    ///  @param dst The address of the destination account
    ///  @param amount The number of tokens to transfer
    ///  @return success Whether or not the transfer succeeded
    function transferFrom(address src, address dst, uint256 amount) external returns (bool success);

    ///  @notice Approve `spender` to transfer up to `amount` from `src`
    ///  @dev This will overwrite the approval amount for `spender`
    ///   and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
    ///  @param spender The address of the account which may transfer tokens
    ///  @param amount The number of tokens that are approved (-1 means infinite)
    ///  @return success Whether or not the approval succeeded
    function approve(address spender, uint256 amount) external returns (bool success);

    ///  @notice Get the current allowance from `owner` for `spender`
    ///  @param owner The address of the account which owns the tokens to be spent
    ///  @param spender The address of the account which may transfer tokens
    ///  @return remaining The number of tokens allowed to be spent (-1 means infinite)
    function allowance(address owner, address spender) external view returns (uint256 remaining);
}

///  @title EIP20NonStandardInterface
///  @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
///   See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
interface EIP20NonStandardInterface {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    ///  @notice Get the total number of tokens in circulation
    ///  @return The supply of tokens
    function totalSupply() external view returns (uint256);

    ///  @notice Gets the balance of the specified address
    ///  @param owner The address from which the balance will be retrieved
    ///  @return balance The balance
    function balanceOf(address owner) external view returns (uint256 balance);

    ///  @notice Transfer `amount` tokens from `msg.sender` to `dst`
    ///  @param dst The address of the destination account
    ///  @param amount The number of tokens to transfer
    function transfer(address dst, uint256 amount) external;

    ///  @notice Transfer `amount` tokens from `src` to `dst`
    ///  @param src The address of the source account
    ///  @param dst The address of the destination account
    ///  @param amount The number of tokens to transfer
    function transferFrom(address src, address dst, uint256 amount) external;

    ///  @notice Approve `spender` to transfer up to `amount` from `src`
    ///  @dev This will overwrite the approval amount for `spender`
    ///   and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
    ///  @param spender The address of the account which may transfer tokens
    ///  @param amount The number of tokens that are approved
    ///  @return success Whether or not the approval succeeded
    function approve(address spender, uint256 amount) external returns (bool success);

    ///  @notice Get the current allowance from `owner` for `spender`
    ///  @param owner The address of the account which owns the tokens to be spent
    ///  @param spender The address of the account which may transfer tokens
    ///  @return remaining The number of tokens allowed to be spent
    function allowance(address owner, address spender) external view returns (uint256 remaining);
}

contract managerErrorReporter {
    enum Error { NO_ERROR, UNAUTHORIZED, MATRIXPRICER_MISMATCH, INSUFFICIENT_SHORTFALL, INSUFFICIENT_LIQUIDITY, INVALID_CLOSE_FACTOR, INVALID_COLLATERAL_FACTOR, INVALID_LIQUIDATION_INCENTIVE, MARKET_NOT_ENTERED, MARKET_NOT_LISTED, MARKET_ALREADY_LISTED, MATH_ERROR, NONZERO_BORROW_BALANCE, PRICE_ERROR, REJECTION, SNAPSHOT_ERROR, TOO_MANY_ASSETS, TOO_MUCH_REPAY }

    enum FailureInfo { ACCEPT_ADMIN_PENDING_ADMIN_CHECK, ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK, EXIT_MARKET_BALANCE_OWED, EXIT_MARKET_REJECTION, SET_CLOSE_FACTOR_OWNER_CHECK, SET_CLOSE_FACTOR_VALIDATION, SET_COLLATERAL_FACTOR_OWNER_CHECK, SET_COLLATERAL_FACTOR_NO_EXISTS, SET_COLLATERAL_FACTOR_VALIDATION, SET_COLLATERAL_FACTOR_WITHOUT_PRICE, SET_IMPLEMENTATION_OWNER_CHECK, SET_LIQUIDATION_INCENTIVE_OWNER_CHECK, SET_LIQUIDATION_INCENTIVE_VALIDATION, SET_MAX_ASSETS_OWNER_CHECK, SET_PAUSE_GUARDIAN_OWNER_CHECK, SET_PENDING_ADMIN_OWNER_CHECK, SET_PENDING_IMPLEMENTATION_OWNER_CHECK, SET_PRICE_ORACLE_OWNER_CHECK, SUPPORT_MARKET_EXISTS, SUPPORT_MARKET_OWNER_CHECK }

    ///  @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
    ///  contract-specific code that enables us to report opaque error codes from upgradeable contracts.*
    event Failure(uint error, uint info, uint detail);

    ///  @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
    function fail(Error err, FailureInfo info) internal returns (uint) {
        emit Failure(uint(err), uint(info), 0);
        return uint(err);
    }

    ///  @dev use this when reporting an opaque error from an upgradeable collaborator contract
    function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
        emit Failure(uint(err), uint(info), opaqueError);
        return uint(err);
    }
}

contract TokenErrorReporter {
    error TransferMatrixpricerRejection(uint256 errorCode);

    error TransferTensorpricerRejection(uint256 errorCode);

    error TransferNotAllowed();

    error TransferNotEnough();

    error TransferNotEnoughAllowance();

    error TransferTooMuch();

    error MintMatrixpricerRejection(uint256 errorCode);

    error MintTensorpricerRejection(uint256 errorCode);

    error MintFreshnessCheck();

    error RedeemMatrixpricerRejection(uint256 errorCode);

    error RedeemTensorpricerRejection(uint256 errorCode);

    error RedeemFreshnessCheck();

    error RedeemTransferOutNotPossible();

    error BorrowMatrixpricerRejection(uint256 errorCode);

    error BorrowFreshnessCheck();

    error BorrowCashNotAvailable();

    error RepayBorrowMatrixpricerRejection(uint256 errorCode);

    error RepayBorrowFreshnessCheck();

    error LiquidateMatrixpricerRejection(uint256 errorCode);

    error LiquidateFreshnessCheck();

    error LiquidateCollateralFreshnessCheck();

    error LiquidateAccrueBorrowInterestFailed(uint256 errorCode);

    error LiquidateAccrueCollateralInterestFailed(uint256 errorCode);

    error LiquidateLiquidatorIsBorrower();

    error LiquidateCloseAmountIsZero();

    error LiquidateCloseAmountIsUintMax();

    error LiquidateRepayBorrowFreshFailed(uint256 errorCode);

    error LiquidateSeizeMatrixpricerRejection(uint256 errorCode);

    error LiquidateSeizeLiquidatorIsBorrower();

    error AcceptAdminPendingAdminCheck();

    error SetMatrixpricerOwnerCheck();

    error SetTensorpricerOwnerCheck();

    error SetPendingAdminOwnerCheck();

    error SetReserveFactorAdminCheck();

    error SetReserveFactorFreshCheck();

    error SetReserveFactorBoundsCheck();

    error AddReservesFactorFreshCheck(uint256 actualAddAmount);

    error ReduceReservesAdminCheck();

    error ReduceReservesFreshCheck();

    error ReduceReservesCashNotAvailable();

    error ReduceReservesCashValidation();

    error SetInterestRateModelOwnerCheck();

    error SetInterestRateModelFreshCheck();

    uint public constant NO_ERROR = 0;
}

///  @title Exponential module for storing fixed-precision decimals
///  @author Compound
///  @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
///          Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
///          `Exp({mantissa: 5100000000000000000})`.
contract ExponentialNoError {
    struct Exp {
        uint mantissa;
    }

    struct Double {
        uint mantissa;
    }

    uint internal constant expScale = 1e18;
    uint internal constant doubleScale = 1e36;
    uint internal constant halfExpScale = expScale / 2;
    uint internal constant mantissaOne = expScale;

    ///  @dev Truncates the given exp to a whole number value.
    ///       For example, truncate(Exp{mantissa: 15 * expScale}) = 15
    function truncate(Exp memory exp) internal pure returns (uint) {
        return exp.mantissa / expScale;
    }

    ///  @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
    function mul_ScalarTruncate(Exp memory a, uint scalar) internal pure returns (uint) {
        Exp memory product = mul_(a, scalar);
        return truncate(product);
    }

    ///  @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
    function mul_ScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) internal pure returns (uint) {
        Exp memory product = mul_(a, scalar);
        return add_(truncate(product), addend);
    }

    ///  @dev Checks if first Exp is less than second Exp.
    function lessThanExp(Exp memory left, Exp memory right) internal pure returns (bool) {
        return left.mantissa < right.mantissa;
    }

    ///  @dev Checks if left Exp <= right Exp.
    function lessThanOrEqualExp(Exp memory left, Exp memory right) internal pure returns (bool) {
        return left.mantissa <= right.mantissa;
    }

    ///  @dev Checks if left Exp > right Exp.
    function greaterThanExp(Exp memory left, Exp memory right) internal pure returns (bool) {
        return left.mantissa > right.mantissa;
    }

    ///  @dev returns true if Exp is exactly zero
    function isZeroExp(Exp memory value) internal pure returns (bool) {
        return value.mantissa == 0;
    }

    function safe224(uint n, string memory errorMessage) internal pure returns (uint224) {
        require(n < (2 ** 224), errorMessage);
        return uint224(n);
    }

    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
        require(n < (2 ** 32), errorMessage);
        return uint32(n);
    }

    function add_(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
        return Exp({mantissa: add_(a.mantissa, b.mantissa)});
    }

    function add_(Double memory a, Double memory b) internal pure returns (Double memory) {
        return Double({mantissa: add_(a.mantissa, b.mantissa)});
    }

    function add_(uint a, uint b) internal pure returns (uint) {
        return a + b;
    }

    function sub_(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
        return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
    }

    function sub_(Double memory a, Double memory b) internal pure returns (Double memory) {
        return Double({mantissa: sub_(a.mantissa, b.mantissa)});
    }

    function sub_(uint a, uint b) internal pure returns (uint) {
        return a - b;
    }

    function mul_(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
        return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
    }

    function mul_(Exp memory a, uint b) internal pure returns (Exp memory) {
        return Exp({mantissa: mul_(a.mantissa, b)});
    }

    function mul_(uint a, Exp memory b) internal pure returns (uint) {
        return mul_(a, b.mantissa) / expScale;
    }

    function mul_(Double memory a, Double memory b) internal pure returns (Double memory) {
        return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
    }

    function mul_(Double memory a, uint b) internal pure returns (Double memory) {
        return Double({mantissa: mul_(a.mantissa, b)});
    }

    function mul_(uint a, Double memory b) internal pure returns (uint) {
        return mul_(a, b.mantissa) / doubleScale;
    }

    function mul_(uint a, uint b) internal pure returns (uint) {
        return a * b;
    }

    function div_(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
        return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
    }

    function div_(Exp memory a, uint b) internal pure returns (Exp memory) {
        return Exp({mantissa: div_(a.mantissa, b)});
    }

    function div_(uint a, Exp memory b) internal pure returns (uint) {
        return div_(mul_(a, expScale), b.mantissa);
    }

    function div_(Double memory a, Double memory b) internal pure returns (Double memory) {
        return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
    }

    function div_(Double memory a, uint b) internal pure returns (Double memory) {
        return Double({mantissa: div_(a.mantissa, b)});
    }

    function div_(uint a, Double memory b) internal pure returns (uint) {
        return div_(mul_(a, doubleScale), b.mantissa);
    }

    function div_(uint a, uint b) internal pure returns (uint) {
        return a / b;
    }

    function fraction(uint a, uint b) internal pure returns (Double memory) {
        return Double({mantissa: div_(mul_(a, doubleScale), b)});
    }
}

///  @title Vortex's InterestRateModel Interface
///  @author Vortex
abstract contract InterestRateModel {
    /// @notice contract property
    bool public constant isInterestRateModel = true;

    ///  @notice Calculates the current borrow interest rate per block
    ///  @param iur ideal utilisation rate
    ///  @param cRatePerBlock compound rate
    ///  @return The borrow rate per block (as a percentage, and scaled by 1e18)
    function getBorrowRate(uint iur, uint cRatePerBlock) virtual external view returns (uint);

    ///  @notice Calculates the current supply interest rate per block
    ///  @param iur ideal utilisation rate
    ///  @param cRatePerBlock compound rate
    ///  @return The supply rate per block (as a percentage, and scaled by 1e18)
    function getSupplyRate(uint iur, uint cRatePerBlock) virtual external view returns (uint);
}

abstract contract MatrixpricerInterface {
    /// @notice Indicator that this is a Matrixpricer contract (for inspection)
    bool public constant isMatrixpricer = true;

    function mintAllowed(address depToken, address minter) virtual external returns (uint);

    function redeemAllowed(address depToken, address redeemer, uint redeemTokens) virtual external returns (uint);

    function borrowAllowed(address depToken, address borrower) virtual external returns (uint);

    function repayBorrowAllowed(address depToken, address borrower) virtual external returns (uint);

    function transferAllowed(address depToken, address src, address dst, uint transferTokens) virtual external returns (uint);
}

abstract contract TensorpricerInterface {
    /// @notice Indicator that this is a Tensorpricer contract (for inspection)
    bool public constant isTensorpricer = true;
    uint public fxMult = 100;

    function mintAllowed(address levToken, address minter) virtual external returns (uint);

    function redeemAllowed(address levToken, address redeemer, uint redeemTokens) virtual external returns (uint);

    function transferAllowed(address levToken, address src, address dst, uint transferTokens) virtual external returns (uint);

    function getFx(string memory fxname) virtual external view returns (uint);

    function _setMintPausedLev(address levToken, bool state) virtual public returns (bool);

    function _setRedeemPausedLev(address levToken, bool state) virtual public returns (bool);

    function setFxMult(uint mult) virtual external;
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
    ///  https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
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

interface IAddressProvider {
    function get_registry() external view;

    function get_address(uint id) external view returns (address);
}

interface ICurveFi {
    function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external;

    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
}

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

interface IRegistry {
    function get_decimals(address pool) external view returns (uint[8] memory);

    function exchange(address _pool, address _from, address _to, uint _amound, uint _expected, address _receiver) external returns (uint);

    function get_exchange_amount(address _pool, address _from, address _to, uint _amount) external view returns (uint);
}

///  @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
///  behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
///  external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
///  function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
///  The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
///  reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
///  case an upgrade adds a module that needs to be initialized.
///  For example:
///  [.hljs-theme-light.nopadding]
///  ```
///  contract MyToken is ERC20Upgradeable {
///      function initialize() initializer public {
///          __ERC20_init("MyToken", "MTK");
///      }
///  }
///  contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
///      function initializeV2() reinitializer(2) public {
///          __ERC20Permit_init("MyToken");
///      }
///  }
///  ```
///  TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
///  possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
///  CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
///  that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
///  [CAUTION]
///  ====
///  Avoid leaving a contract uninitialized.
///  An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
///  contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
///  the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
///  [.hljs-theme-light.nopadding]
///  ```
///  /// @custom:oz-upgrades-unsafe-allow constructor
///  constructor() {
///      _disableInitializers();
///  }
///  ```
///  ====
abstract contract Initializable {
    ///  @dev Triggered when the contract has been initialized or reinitialized.
    event Initialized(uint8 version);

    ///  @dev Indicates that the contract has been initialized.
    ///  @custom:oz-retyped-from bool
    uint8 private _initialized;
    ///  @dev Indicates that the contract is in the process of being initialized.
    bool private _initializing;

    ///  @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
    ///  `onlyInitializing` functions can be used to initialize parent contracts.
    ///  Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
    ///  constructor.
    ///  Emits an {Initialized} event.
    modifier initializer() {
        bool isTopLevelCall = !_initializing;
        require((isTopLevelCall && (_initialized < 1)) || ((!AddressUpgradeable.isContract(address(this))) && (_initialized == 1)), "Initializable: contract is already initialized");
        _initialized = 1;
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    ///  @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
    ///  contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
    ///  used to initialize parent contracts.
    ///  A reinitializer may be used after the original initialization step. This is essential to configure modules that
    ///  are added through upgrades and that require initialization.
    ///  When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
    ///  cannot be nested. If one is invoked in the context of another, execution will revert.
    ///  Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
    ///  a contract, executing them in the right order is up to the developer or operator.
    ///  WARNING: setting the version to 255 will prevent any future reinitialization.
    ///  Emits an {Initialized} event.
    modifier reinitializer(uint8 version) {
        require((!_initializing) && (_initialized < version), "Initializable: contract is already initialized");
        _initialized = version;
        _initializing = true;
        _;
        _initializing = false;
        emit Initialized(version);
    }

    ///  @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
    ///  {initializer} and {reinitializer} modifiers, directly or indirectly.
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    ///  @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
    ///  Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
    ///  to any version. It is recommended to use this to lock implementation contracts that are designed to be called
    ///  through proxies.
    ///  Emits an {Initialized} event the first time it is successfully executed.
    function _disableInitializers() virtual internal {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized < type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }

    ///  @dev Returns the highest version that has been initialized. See {reinitializer}.
    function _getInitializedVersion() internal view returns (uint8) {
        return _initialized;
    }

    ///  @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
    function _isInitializing() internal view returns (bool) {
        return _initializing;
    }
}

interface ICompoundV2 {
    function mint(uint mintAmount) external returns (uint);

    function redeem(uint redeemTokens) external returns (uint);

    function redeemUnderlying(uint redeemAmount) external returns (uint);

    function balanceOf(address owner) external view returns (uint256);

    function borrowRatePerBlock() external view returns (uint);

    function supplyRatePerBlock() external view returns (uint);

    function exchangeRateStored() external view returns (uint);
}

interface INNERIERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
}

interface DepositWithdrawInterface {}

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

contract DepositWithdraw is DepositWithdrawInterface {
    using SafeERC20 for IERC20;

    address internal compoundV2cUSDCAddress;
    address internal compoundV2cUSDTAddress;
    address internal USDCAddress;
    address internal USDTAddress;

    function setAddresses(address compoundV2cUSDCAddress_, address compoundV2cUSDTAddress_, address USDCAddress_, address USDTAddress_) internal {
        compoundV2cUSDCAddress = compoundV2cUSDCAddress_;
        compoundV2cUSDTAddress = compoundV2cUSDTAddress_;
        USDCAddress = USDCAddress_;
        USDTAddress = USDTAddress_;
    }

    function getCUSDTNumber() internal view returns (uint) {
        uint value = ICompoundV2(compoundV2cUSDTAddress).balanceOf(address(this));
        return value;
    }

    function getCmpUSDTExchRate() virtual public view returns (uint) {
        uint value = ICompoundV2(compoundV2cUSDTAddress).exchangeRateStored();
        return value;
    }

    function getCUSDCNumber() internal view returns (uint) {
        uint value = ICompoundV2(compoundV2cUSDCAddress).balanceOf(address(this));
        return value;
    }

    function getCmpUSDCExchRate() internal view returns (uint) {
        uint value = ICompoundV2(compoundV2cUSDCAddress).exchangeRateStored();
        return value;
    }

    function getCmpUSDTSupplyRate() virtual public view returns (uint) {
        return ICompoundV2(compoundV2cUSDTAddress).supplyRatePerBlock();
    }

    function supplyUSDC(uint amount) internal {
        IERC20(USDCAddress).safeApprove(compoundV2cUSDCAddress, amount);
        ICompoundV2(compoundV2cUSDCAddress).mint(amount);
    }

    function withdrawcUSDC(uint amount) internal {
        ICompoundV2(compoundV2cUSDCAddress).redeem(amount);
    }

    function withdrawUSDCfromCmp(uint amount) internal {
        ICompoundV2(compoundV2cUSDCAddress).redeemUnderlying(amount);
    }

    function supplyUSDT2Cmp(uint amount) internal {
        IERC20(USDTAddress).safeApprove(compoundV2cUSDTAddress, amount);
        ICompoundV2(compoundV2cUSDTAddress).mint(amount);
    }

    function withdrawcUSDT(uint amount) internal {
        ICompoundV2(compoundV2cUSDTAddress).redeem(amount);
    }

    function withdrawUSDTfromCmp(uint amount) internal {
        ICompoundV2(compoundV2cUSDTAddress).redeemUnderlying(amount);
    }
}

contract CurveSwap is CurveContractInterface {
    using SafeERC20 for IERC20;

    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    address public TriPool;
    address public ADDRESSPROVIDER;
    address public USDC_ADDRESS;
    address public USDT_ADDRESS;

    function setAddressesCurve(address TriPool_, address ADDRESSPROVIDER_, address USDC_ADDRESS_, address USDT_ADDRESS_) internal {
        TriPool = TriPool_;
        ADDRESSPROVIDER = ADDRESSPROVIDER_;
        USDC_ADDRESS = USDC_ADDRESS_;
        USDT_ADDRESS = USDT_ADDRESS_;
    }

    function QueryAddressProvider(uint id) internal view returns (address) {
        return IAddressProvider(ADDRESSPROVIDER).get_address(id);
    }

    function PerformExchange(address _from, address _to, uint _amount, uint _expected, address _receiver) internal returns (uint256) {
        address Registry = QueryAddressProvider(2);
        uint receToken = IRegistry(Registry).exchange(TriPool, _from, _to, _amount, _expected, _receiver);
        return receToken;
    }

    function changeUSDT2USDC(uint _amount, uint _expected, address _receiver) virtual internal returns (uint256) {
        address Registry = QueryAddressProvider(2);
        approveToken(USDT_ADDRESS, Registry, _amount);
        uint receToken = IRegistry(Registry).exchange(TriPool, USDT_ADDRESS, USDC_ADDRESS, _amount, _expected, _receiver);
        return receToken;
    }

    function changeUSDC2USDT(uint _amount, uint _expected, address _receiver) internal returns (uint256) {
        address Registry = QueryAddressProvider(2);
        approveToken(USDC_ADDRESS, Registry, _amount);
        uint receToken = IRegistry(Registry).exchange(TriPool, USDC_ADDRESS, USDT_ADDRESS, _amount, _expected, _receiver);
        return receToken;
    }

    /// @custom:consol
    ///  {approveToken(token, spender, _amount) returns (ret)
    ///      requires {spender == QueryAddressProvider(2)}}
    function approveToken_original(address token, address spender, uint _amount) private returns (bool) {
        IERC20(token).safeApprove(spender, _amount);
        return true;
    }

    function _approveToken_pre(address token, address spender, uint _amount) private {
        if (!(spender==QueryAddressProvider(2))) revert preViolation("approveToken");
    }

    function approveToken(address token, address spender, uint _amount) public returns (bool) {
        _approveToken_pre(token, spender, _amount);
        bool ret = approveToken_original(token, spender, _amount);
        return (ret);
    }
}

contract DepTokenStorage {
    struct BorrowSnapshot {
        uint principal;
        uint interestIndex;
    }

    ///  @dev protection against contract calling itself (re-entrancy check)
    bool internal _notEntered;
    ///  @notice EIP-20 token name for this token
    string public name;
    ///  @notice EIP-20 token symbol for this token
    string public symbol;
    ///  @notice EIP-20 token decimals for this token, we use 6 to stay consistent with usdt
    uint8 public decimals;
    uint internal constant reserveFactorMaxMantissa = 1e18;
    ///  @notice Administrator for this contract
    address payable public admin;
    ///  @notice Pending administrator for this contract
    address payable public pendingAdmin;
    ///  @notice the brain of this contract
    MatrixpricerInterface public matrixpricer;
    ///  @notice Model that computes deposit and lending rate
    InterestRateModel public interestRateModel;
    ///  @notice associated levErc20
    LevErc20Interface public levErc20;
    uint internal initialExchangeRateMantissa;
    ///  @notice Fraction of interest currently set aside for reserves
    uint public reserveFactorMantissa;
    ///  @notice Block number that interest was last accrued at
    uint public accrualBlockNumber;
    ///  @notice Accumulator of the total earned interest rate since the opening of the market
    uint public borrowIndex;
    ///  @notice Total amount of outstanding borrows of the underlying in this market
    uint public totalBorrows;
    ///  @notice Total amount of reserves of the underlying held in this market
    uint public totalReserves;
    ///  @notice Total number of tokens in circulation
    uint public totalSupply;
    mapping(address => uint) internal accountTokens;
    mapping(address => mapping(address => uint)) internal transferAllowances;
    uint internal constant minTransferAmtUSDT = 50000e6;
    uint internal constant thresholdUSDT = 300000e6;
    uint internal constant extraUSDT = 100000e6;
    mapping(address => BorrowSnapshot) internal accountBorrows;
    ///  @notice Share of seized collateral that is added to reserves
    uint public constant protocolSeizeShareMantissa = 2.8e16;
}

abstract contract DepTokenInterface is DepTokenStorage {
    ///  @notice Event emitted when interest is accrued
    event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);

    ///  @notice Event emitted when tokens are minted
    event Mint(address minter, uint mintAmount, uint mintTokens, uint apy);

    ///  @notice Event emitted when tokens are redeemed
    event Redeem(address redeemer, uint redeemAmount, uint redeemTokens, uint apy);

    ///  @notice Event emitted when underlying is borrowed
    event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);

    ///  @notice Event emitted when a borrow is repaid
    event RepayBorrow(address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows, bool liquidate);

    ///  @notice Event emitted when pendingAdmin is changed
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);

    ///  @notice Event emitted when pendingAdmin is accepted, which means admin is updated
    event NewAdmin(address oldAdmin, address newAdmin);

    ///  @notice Event emitted when matrixpricer is changed
    event NewMatrixpricer(MatrixpricerInterface oldMatrixpricer, MatrixpricerInterface newMatrixpricer);

    ///  @notice Event emitted when the reserve factor is changed
    event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);

    ///  @notice Event emitted when the reserves are added
    event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);

    ///  @notice Event emitted when the reserves are reduced
    event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);

    ///  @notice EIP20 Transfer event
    event Transfer(address indexed from, address indexed to, uint amount);

    ///  @notice EIP20 Approval event
    event Approval(address indexed owner, address indexed spender, uint amount);

    ///  @notice Indicator that this is a DepToken contract (for inspection)
    bool public constant isDepToken = true;

    function transfer(address dst, uint amount) virtual external returns (bool);

    function transferFrom(address src, address dst, uint amount) virtual external returns (bool);

    function approve(address spender, uint amount) virtual external returns (bool);

    function allowance(address owner, address spender) virtual external view returns (uint);

    function balanceOf(address owner) virtual external view returns (uint);

    function balanceOfUnderlying(address owner) virtual external returns (uint);

    function balanceOfUnderlyingView(address owner) virtual external view returns (uint);

    function getAccountSnapshot(address account) virtual external view returns (uint, uint, uint, uint);

    function borrowRatePerBlock() virtual external view returns (uint);

    function supplyRatePerBlock() virtual public view returns (uint);

    function totalBorrowsCurrent() virtual external returns (uint);

    function exchangeRateCurrent() virtual external returns (uint);

    function exchangeRateStored() virtual external view returns (uint);

    function getCash() virtual external view returns (uint);

    function getCompoundBalance() virtual external view returns (uint);

    function accrueInterest() virtual external returns (uint);

    function _setPendingAdmin(address payable newPendingAdmin) virtual external returns (uint);

    function _acceptAdmin() virtual external returns (uint);

    function _setMatrixpricer(MatrixpricerInterface newMatrixpricer) virtual external returns (uint);

    function _setReserveFactor(uint newReserveFactorMantissa) virtual external returns (uint);

    function _reduceReserves(uint reduceAmount) virtual external returns (uint);

    function _setInterestRateModel(InterestRateModel newInterestRateModel) virtual external returns (uint);
}

contract DepErc20Storage {
    ///  @notice Underlying asset for this DepToken
    address public underlying;
}

abstract contract DepErc20Interface is DepErc20Storage {
    function mint(uint mintAmount) virtual external returns (uint);

    function redeem(uint redeemTokens, uint redeemAmount) virtual external returns (uint);

    function borrow(uint borrowAmount) virtual external returns (uint);

    function repayBorrow(uint repayAmount, bool liquidate) virtual external returns (uint);

    function getUnborrowedUSDTBalance() virtual external view returns (uint);

    function getTotalBorrows() virtual external view returns (uint);

    function getTotalBorrowsAfterAccrueInterest() virtual external returns (uint);

    function _addReserves(uint addAmount) virtual external returns (uint);
}

contract LevTokenStorage {
    struct checkRebalanceRes {
        uint res;
        uint targetLevRatio;
        uint tmpBorrowBalanceUSDC;
        uint tmpTotalAssetValue;
        uint tmpLevRatio;
    }

    ///  @dev protection against contract calling itself (re-entrancy check)
    bool internal _notEntered;
    ///  @notice EIP-20 token name for this token
    string public name;
    ///  @notice EIP-20 token symbol for this token
    string public symbol;
    ///  @notice EIP-20 token decimals for this token, we use 6 to stay consistent with usdc
    uint8 public decimals;
    ///  @notice Administrator for this contract
    address payable public admin;
    ///  @notice Pending administrator for this contract
    address payable public pendingAdmin;
    ///  @notice the brain of this contract
    TensorpricerInterface public tensorpricer;
    ///  @notice associated depErc20
    DepErc20Interface public depErc20;
    uint internal constant initialNetAssetValueMantissa = 1e18;
    uint internal constant initialTargetLevRatio = 5e18;
    ///  @notice Total number of tokens in circulation
    uint public totalSupply;
    ///  @notice Total amount of outstanding borrow in USDT in this market
    uint public borrowBalanceUSDT;
    ///  @notice Total amount of outstanding borrow valued in USDC in this market
    uint public borrowBalanceUSDC;
    ///  @notice Total asset value in USDC
    uint public totalAssetValue;
    ///  @notice net asset value in USDC
    uint public netAssetValue;
    ///  @notice leverage ratio
    uint public levRatio;
    ///  @notice
    uint public extraBorrowDemand;
    ///  @notice
    uint public extraBorrowSupply;
    uint public targetLevRatio;
    mapping(address => uint) internal accountTokens;
    mapping(address => mapping(address => uint)) internal transferAllowances;
    uint internal constant minTransferAmtUSDC = 50000e6;
    uint internal constant thresholdUSDC = 300000e6;
    uint internal constant extraUSDC = 100000e6;
    uint internal hisHighNav;
    uint internal levReserve;
    uint internal constant redeemFeePC = 1e15;
    uint internal constant perfPC = 1e17;
    uint internal redeemAmountInUSDC;
}

abstract contract LevTokenInterface is LevTokenStorage {
    ///  @notice Event emitted when tokens are minted
    event Mint(address minter, uint mintAmount, uint mintTokens, uint nav);

    ///  @notice Event emitted when tokens are redeemed
    event Redeem(address redeemer, uint redeemAmount, uint redeemTokens, uint nav);

    ///  @notice Event emitted when forceRepay is triggered
    event ForceRepay(address forcer, uint repayAmount);

    ///  @notice Event emitted when pendingAdmin is changed
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);

    ///  @notice Event emitted when pendingAdmin is accepted, which means admin is updated
    event NewAdmin(address oldAdmin, address newAdmin);

    ///  @notice Event emitted when tensorpricer is changed
    event NewTensorpricer(TensorpricerInterface oldTensorpricer, TensorpricerInterface newTensorpricer);

    ///  @notice EIP20 Transfer event
    event Transfer(address indexed from, address indexed to, uint amount);

    ///  @notice EIP20 Approval event
    event Approval(address indexed owner, address indexed spender, uint amount);

    ///  @notice Event emitted when the reserves are reduced
    event ReservesReduced(address admin, uint reduceAmount, uint newLevReserve);

    ///  @notice Indicator that this is a LevToken contract (for inspection)
    bool public constant isLevToken = true;

    function transfer(address dst, uint amount) virtual external returns (bool);

    function transferFrom(address src, address dst, uint amount) virtual external returns (bool);

    function approve(address spender, uint amount) virtual external returns (bool);

    function allowance(address owner, address spender) virtual external view returns (uint);

    function balanceOf(address owner) virtual external view returns (uint);

    function getNAV(address owner) virtual external view returns (uint);

    function getAccountSnapshot(address account) virtual external view returns (uint, uint);

    function getCash() virtual external view returns (uint);

    function getCompoundBalance() virtual external view returns (uint);

    function getLevReserve() virtual external view returns (uint);

    function getHisHighNav() virtual external view returns (uint);

    function _setPendingAdmin(address payable newPendingAdmin) virtual external returns (uint);

    function _acceptAdmin() virtual external returns (uint);

    function _setTensorpricer(TensorpricerInterface newTensorpricer) virtual external returns (uint);

    function _reduceReserves(uint reduceAmount) virtual external returns (uint);
}

contract LevErc20Storage {
    ///  @notice Underlying asset for this LevToken
    address public underlying;
    address public borrowUnderlying;
}

abstract contract LevErc20Interface is LevErc20Storage {
    function getAdmin() virtual external returns (address payable);

    function mint(uint mintAmount) virtual external returns (uint);

    function redeem(uint redeemTokens) virtual external returns (uint);

    function sweepToken(EIP20NonStandardInterface token) virtual external;

    function getExtraBorrowDemand() virtual external view returns (uint256);

    function getExtraBorrowSupply() virtual external view returns (uint256);

    function forceRepay(uint256 repayAmount) virtual external returns (uint);

    function updateLedger() virtual external;
}

///  @title DepToken Contract
///  @notice Abstract base for DepTokens
///  @author Vortex
abstract contract DepToken is DepTokenInterface, DepositWithdraw, CurveSwap, ExponentialNoError, TokenErrorReporter, Initializable {
    ///  @dev Prevents a contract from calling itself, directly or indirectly.
    modifier nonReentrant() {
        require(_notEntered, "re-entered");
        _notEntered = false;
        _;
        _notEntered = true;
    }

    ///  @notice Initialize the money market
    ///  @param matrixpricer_ The address of the Matrixpricer
    ///  @param interestRateModel_ The address of the interest rate model
    ///  @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
    ///  @param name_ EIP-20 name of this token
    ///  @param symbol_ EIP-20 symbol of this token
    ///  @param decimals_ EIP-20 decimal precision of this token
    ///  @param levErc20_ The address of the associated levErc20
    function initialize(address underlying_, MatrixpricerInterface matrixpricer_, InterestRateModel interestRateModel_, uint initialExchangeRateMantissa_, string memory name_, string memory symbol_, uint8 decimals_, LevErc20Interface levErc20_) virtual public onlyInitializing() {
        require(msg.sender == admin, "only admin may initialize the market");
        require((accrualBlockNumber == 0) && (borrowIndex == 0), "market may only be initialized once");
        initialExchangeRateMantissa = initialExchangeRateMantissa_;
        require(initialExchangeRateMantissa > 0, "initial exchange rate must be greater than zero.");
        uint err = _setMatrixpricer(matrixpricer_);
        require(err == NO_ERROR, "setting matrixpricer failed");
        accrualBlockNumber = getBlockNumber();
        borrowIndex = mantissaOne;
        err = _setInterestRateModelFresh(interestRateModel_);
        require(err == NO_ERROR, "setting interest rate model failed");
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
        levErc20 = levErc20_;
        _notEntered = true;
    }

    ///  @notice Initialize the compound portion
    ///  @param compoundV2cUSDCAddress_ The address of the cUSDC
    ///  @param compoundV2cUSDTAddress_ The address of the cUSDT
    ///  @param USDCAddress_ The address of USDC
    ///  @param USDTAddress_ The address of USDT
    function setAddressesForCompound(address compoundV2cUSDCAddress_, address compoundV2cUSDTAddress_, address USDCAddress_, address USDTAddress_) public {
        require(msg.sender == admin, "only admin can set addresses in general");
        setAddresses(compoundV2cUSDCAddress_, compoundV2cUSDTAddress_, USDCAddress_, USDTAddress_);
    }

    ///  @notice Initialize the curve portion
    ///  @param TriPool_ The address of the Tripool
    ///  @param ADDRESSPROVIDER_ The address of the curve provider
    ///  @param USDC_ADDRESS_ The address of USDC
    ///  @param USDT_ADDRESS_ The address of USDT
    function setAddressesForCurve(address TriPool_, address ADDRESSPROVIDER_, address USDC_ADDRESS_, address USDT_ADDRESS_) public {
        require(msg.sender == admin, "only admin can set addresses in general");
        setAddressesCurve(TriPool_, ADDRESSPROVIDER_, USDC_ADDRESS_, USDT_ADDRESS_);
    }

    ///  @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
    ///  @dev Called by both `transfer` and `transferFrom` internally
    ///  @param spender The address of the account performing the transfer
    ///  @param src The address of the source account
    ///  @param dst The address of the destination account
    ///  @param tokens The number of tokens to transfer
    ///  @return 0 if the transfer succeeded, else revert
    function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
        uint allowed = matrixpricer.transferAllowed(address(this), src, dst, tokens);
        if (allowed != 0) {
            revert TransferMatrixpricerRejection(allowed);
        }
        if (src == dst) {
            revert TransferNotAllowed();
        }
        uint startingAllowance = 0;
        if (spender == src) {
            startingAllowance = type(uint).max;
        } else {
            startingAllowance = transferAllowances[src][spender];
            if (startingAllowance < tokens) {
                revert TransferNotEnoughAllowance();
            }
        }
        uint allowanceNew = startingAllowance - tokens;
        uint srDepTokensNew = accountTokens[src] - tokens;
        uint dstTokensNew = accountTokens[dst] + tokens;
        accountTokens[src] = srDepTokensNew;
        accountTokens[dst] = dstTokensNew;
        if (startingAllowance != type(uint).max) {
            transferAllowances[src][spender] = allowanceNew;
        }
        emit Transfer(src, dst, tokens);
        return NO_ERROR;
    }

    ///  @notice Transfer `amount` tokens from `msg.sender` to `dst`
    ///  @param dst The address of the destination account
    ///  @param amount The number of tokens to transfer
    ///  @return Whether or not the transfer succeeded
    function transfer(address dst, uint256 amount) override external nonReentrant() returns (bool) {
        return transferTokens(msg.sender, msg.sender, dst, amount) == NO_ERROR;
    }

    ///  @notice Transfer `amount` tokens from `src` to `dst`
    ///  @param src The address of the source account
    ///  @param dst The address of the destination account
    ///  @param amount The number of tokens to transfer
    ///  @return Whether or not the transfer succeeded
    function transferFrom(address src, address dst, uint256 amount) override external nonReentrant() returns (bool) {
        return transferTokens(msg.sender, src, dst, amount) == NO_ERROR;
    }

    ///  @notice Approve `spender` to transfer up to `amount` from `src`
    ///  @dev This will overwrite the approval amount for `spender`
    ///   and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
    ///  @param spender The address of the account which may transfer tokens
    ///  @param amount The number of tokens that are approved (uint256.max means infinite)
    ///  @return Whether or not the approval succeeded
    function approve(address spender, uint256 amount) override external returns (bool) {
        address src = msg.sender;
        transferAllowances[src][spender] = amount;
        emit Approval(src, spender, amount);
        return true;
    }

    ///  @notice Get the current allowance from `owner` for `spender`
    ///  @param owner The address of the account which owns the tokens to be spent
    ///  @param spender The address of the account which may transfer tokens
    ///  @return The number of tokens allowed to be spent (-1 means infinite)
    function allowance(address owner, address spender) override external view returns (uint256) {
        return transferAllowances[owner][spender];
    }

    ///  @notice Get the token balance of the `owner`
    ///  @param owner The address of the account to query
    ///  @return The number of tokens owned by `owner`
    function balanceOf(address owner) override external view returns (uint256) {
        return accountTokens[owner];
    }

    ///  @notice Get the underlying balance of the `owner`
    ///  @dev This also accrues interest in a transaction
    ///  @param owner The address of the account to query
    ///  @return The amount of underlying owned by `owner`
    function balanceOfUnderlying(address owner) override external returns (uint) {
        Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
        return mul_ScalarTruncate(exchangeRate, accountTokens[owner]);
    }

    ///  @notice Get the underlying balance of the `owner`, view only
    ///  @dev This also accrues interest in a transaction
    ///  @param owner The address of the account to query
    ///  @return The amount of underlying owned by `owner`
    function balanceOfUnderlyingView(address owner) override external view returns (uint) {
        return balanceOfUnderlyingViewInternal(owner);
    }

    function balanceOfUnderlyingViewInternal(address owner) internal view returns (uint) {
        Exp memory exchangeRate = Exp({mantissa: exchangeRateStoredInternal()});
        return mul_ScalarTruncate(exchangeRate, accountTokens[owner]);
    }

    ///  @notice Get a snapshot of the account's balances, and the cached exchange rate
    ///  @dev This is used by matrixpricer to more efficiently perform liquidity checks.
    ///  @param account Address of the account to snapshot
    ///  @return (possible error, token balance, borrow balance, exchange rate mantissa)
    function getAccountSnapshot(address account) override external view returns (uint, uint, uint, uint) {
        return (NO_ERROR, accountTokens[account], borrowBalanceStoredInternal(account), exchangeRateStoredInternal());
    }

    ///  @dev Function to simply retrieve block number
    ///   This exists mainly for inheriting test contracts to stub this result.
    function getBlockNumber() virtual internal view returns (uint) {
        return block.number;
    }

    function getBNumber() public view returns (uint) {
        return block.number;
    }

    ///  notice Returns the current per-block borrow interest rate for this DepToken
    ///  return The borrow interest rate per block, scaled by 1e18
    function borrowRatePerBlock() override external view returns (uint) {
        uint iur = idealUtilizationRate();
        return interestRateModel.getBorrowRate(iur, getCmpUSDTSupplyRate());
    }

    ///  notice Returns the current per-block supply interest rate for this DepToken
    ///  return The supply interest rate per block, scaled by 1e18
    function supplyRatePerBlock() override public view returns (uint) {
        uint iur = idealUtilizationRate();
        uint ownSupplyRatePerBlock = interestRateModel.getSupplyRate(iur, getCmpUSDTSupplyRate());
        uint avgRate;
        if (totalSupply > 0) {
            uint unusedCash = getCashExReserves();
            uint compoundUSDTBalance = getCmpBalanceInternal();
            uint compoundSupplyRatePerBlock = getCmpUSDTSupplyRate();
            avgRate = ((ownSupplyRatePerBlock * totalBorrows) + (compoundUSDTBalance * compoundSupplyRatePerBlock)) / ((unusedCash + totalBorrows) + compoundUSDTBalance);
        } else {
            avgRate = ownSupplyRatePerBlock;
        }
        return avgRate;
    }

    ///  @notice Returns the current total borrows plus accrued interest
    ///  @return The total borrows with interest
    function totalBorrowsCurrent() override external nonReentrant() returns (uint) {
        accrueInterest();
        return totalBorrows;
    }

    ///  @notice Returns the current total borrows
    ///  @return The total borrows
    function getTotalBorrowsInternal() internal view returns (uint) {
        return totalBorrows;
    }

    function getTotalBorrowsAfterAccrueInterestInternal() internal returns (uint) {
        accrueInterest();
        return totalBorrows;
    }

    ///  @notice Return the borrow balance of account based on stored data
    ///  @param account The address whose balance should be calculated
    ///  @return (error code, the calculated balance or 0 if error code is non-zero)
    function borrowBalanceStoredInternal(address account) internal view returns (uint) {
        BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
        if (borrowSnapshot.principal == 0) {
            return 0;
        }
        uint principalTimesIndex = borrowSnapshot.principal * borrowIndex;
        return principalTimesIndex / borrowSnapshot.interestIndex;
    }

    ///  @notice Accrue interest then return the up-to-date exchange rate
    ///  @return Calculated exchange rate scaled by 1e18
    function exchangeRateCurrent() override public nonReentrant() returns (uint) {
        accrueInterest();
        return exchangeRateStored();
    }

    ///  @notice Calculates the exchange rate from the underlying to the DepToken
    ///  @dev This function does not accrue interest before calculating the exchange rate
    ///  @return Calculated exchange rate scaled by 1e18
    function exchangeRateStored() override public view returns (uint) {
        return exchangeRateStoredInternal();
    }

    ///  @notice Calculates the exchange rate from the underlying to the DepToken
    ///  @dev This function does not accrue interest before calculating the exchange rate
    ///  @return calculated exchange rate scaled by expScale (=1e18)
    function exchangeRateStoredInternal() virtual internal view returns (uint) {
        uint _totalSupply = totalSupply;
        if (_totalSupply == 0) {
            return initialExchangeRateMantissa;
        } else {
            uint totalCashMinusReserves = getCashExReserves() + getCmpBalanceInternal();
            uint cashPlusBorrowsMinusReserves = totalCashMinusReserves + totalBorrows;
            uint exchangeRate = (cashPlusBorrowsMinusReserves * expScale) / _totalSupply;
            return exchangeRate;
        }
    }

    ///  @notice Get cash balance of this DepToken in the underlying asset
    ///  @return The quantity of underlying asset owned by this contract
    function getCash() override external view returns (uint) {
        return getCashPrior();
    }

    function getCashExReserves() internal view returns (uint) {
        uint allCash = getCashPrior();
        if (allCash > totalReserves) {
            return allCash - totalReserves;
        } else {
            return 0;
        }
    }

    ///  @notice Get cash balance deposited at compound
    ///  @return The quantity of underlying asset owned by this contract
    function getCompoundBalance() override external view returns (uint) {
        return getCmpBalanceInternal();
    }

    function getCmpBalanceInternal() virtual internal view returns (uint) {
        Exp memory exchangeRate = Exp({mantissa: getCmpUSDTExchRate()});
        return mul_ScalarTruncate(exchangeRate, getCUSDTNumber());
    }

    ///  @notice Applies accrued interest to total borrows and reserves
    ///  @dev This calculates interest accrued from the last checkpoint block
    ///    up to the current block and writes new checkpoint to storage.
    function accrueInterest() virtual override public returns (uint) {
        uint currentBlockNumber = getBlockNumber();
        uint accrualBlockNumberPrior = accrualBlockNumber;
        if (accrualBlockNumberPrior == currentBlockNumber) {
            return NO_ERROR;
        }
        uint cashPrior = getCashExReserves();
        uint borrowsPrior = totalBorrows;
        uint reservesPrior = totalReserves;
        uint borrowIndexPrior = borrowIndex;
        uint compoundBorrowRatePerBlock = getCmpUSDTSupplyRate();
        uint iur = idealUtilizationRate();
        uint borrowRateMantissa = interestRateModel.getBorrowRate(iur, compoundBorrowRatePerBlock);
        uint blockDelta = currentBlockNumber - accrualBlockNumberPrior;
        Exp memory simpleInterestFactor = mul_(Exp({mantissa: borrowRateMantissa}), blockDelta);
        uint interestAccumulated = mul_ScalarTruncate(simpleInterestFactor, borrowsPrior);
        uint totalBorrowsNew = interestAccumulated + borrowsPrior;
        uint totalReservesNew = mul_ScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), interestAccumulated, reservesPrior);
        uint borrowIndexNew = mul_ScalarTruncateAddUInt(simpleInterestFactor, borrowIndexPrior, borrowIndexPrior);
        accrualBlockNumber = currentBlockNumber;
        borrowIndex = borrowIndexNew;
        totalBorrows = totalBorrowsNew;
        totalReserves = totalReservesNew;
        emit AccrueInterest(cashPrior, interestAccumulated, borrowIndexNew, totalBorrowsNew);
        return NO_ERROR;
    }

    ///  @notice Sender supplies assets into the market and receives DepTokens in exchange
    ///  @dev Accrues interest whether or not the operation succeeds, unless reverted
    ///  @param mintAmount The amount of the underlying asset to supply
    function mintInternal(uint mintAmount) internal nonReentrant() {
        accrueInterest();
        mintFresh(msg.sender, mintAmount);
    }

    ///  @notice check if sufficient USDT to push to compound
    ///  @dev
    ///  @return if true, then transfer
    function checkCompound(uint currUSDTBalance) internal pure returns (bool) {
        if (currUSDTBalance > (minTransferAmtUSDT + thresholdUSDT)) {
            return true;
        } else {
            return false;
        }
    }

    ///  @notice User supplies assets into the market and receives DepTokens in exchange
    ///  @dev Assumes interest has already been accrued up to the current block
    ///  @param minter The address of the account which is supplying the assets
    ///  @param mintAmount The amount of the underlying asset to supply
    function mintFresh(address minter, uint mintAmount) internal {
        uint allowed = matrixpricer.mintAllowed(address(this), minter);
        if (allowed != 0) {
            revert MintMatrixpricerRejection(allowed);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            revert MintFreshnessCheck();
        }
        Exp memory exchangeRate = Exp({mantissa: exchangeRateStoredInternal()});
        uint actualMintAmount = doTransferIn(minter, mintAmount);
        uint mintTokens = div_(actualMintAmount, exchangeRate);
        totalSupply = totalSupply + mintTokens;
        accountTokens[minter] = accountTokens[minter] + mintTokens;
        uint currUSDTBalance = getCashExReserves();
        if (checkCompound(currUSDTBalance)) {
            supplyUSDT2Cmp(currUSDTBalance - thresholdUSDT);
        }
        emit Mint(minter, actualMintAmount, mintTokens, supplyRatePerBlock());
        emit Transfer(address(this), minter, mintTokens);
    }

    ///  @notice Sender redeems DepTokens in exchange for the underlying asset
    ///  @dev Accrues interest whether or not the operation succeeds, unless reverted
    ///  @param redeemTokensIn The number of DepTokens to redeem into underlying
    ///  @param redeemAmountIn The amount of underlying to receive from redeeming DepTokens
    function redeemInternal(uint redeemTokensIn, uint redeemAmountIn) internal nonReentrant() {
        accrueInterest();
        require((redeemTokensIn > 0) && (redeemAmountIn == 0), "do not support redeemAmountIn");
        Exp memory exchangeRate = Exp({mantissa: exchangeRateStoredInternal()});
        uint redeemTokens = redeemTokensIn;
        uint redeemAmount = mul_ScalarTruncate(exchangeRate, redeemTokensIn);
        address payable redeemer = payable(msg.sender);
        uint allowed = matrixpricer.redeemAllowed(address(this), redeemer, redeemTokens);
        if (allowed != 0) {
            revert RedeemMatrixpricerRejection(allowed);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            revert RedeemFreshnessCheck();
        }
        uint compoundBalance = getCmpBalanceInternal();
        uint currUSDTBalance = getCashExReserves();
        uint256 totalUndUnborrowed = currUSDTBalance + compoundBalance;
        uint netForceRepayAmt = 0;
        if (totalUndUnborrowed < redeemAmount) {
            uint forceRepayAmtRequest = redeemAmount - totalUndUnborrowed;
            netForceRepayAmt = levErc20.forceRepay(forceRepayAmtRequest);
            if (netForceRepayAmt == 0) {
                revert RedeemTransferOutNotPossible();
            } else {
                updateBorrowLedger(netForceRepayAmt, false, true);
            }
            withdrawUSDTfromCmp(compoundBalance);
        } else if (redeemAmount > currUSDTBalance) {
            uint amtNeeded = redeemAmount - currUSDTBalance;
            if (compoundBalance > (amtNeeded + extraUSDT)) {
                withdrawUSDTfromCmp(amtNeeded + extraUSDT);
            } else {
                withdrawUSDTfromCmp(compoundBalance);
            }
        }
        uint cashAvailToWithdraw = getCashExReserves();
        if (redeemAmount > cashAvailToWithdraw) {
            redeemAmount = cashAvailToWithdraw;
        }
        totalSupply = totalSupply - redeemTokens;
        accountTokens[redeemer] = accountTokens[redeemer] - redeemTokens;
        doTransferOut(redeemer, redeemAmount);
        emit Transfer(redeemer, address(this), redeemTokens);
        emit Redeem(redeemer, redeemAmount, redeemTokens, supplyRatePerBlock());
    }

    ///  @notice Sender borrows assets from the protocol to their own address
    ///  @param origBorrowAmount The amount of the underlying asset to borrow
    function borrowInternal(uint origBorrowAmount) internal nonReentrant() returns (uint) {
        accrueInterest();
        address borrower = msg.sender;
        uint allowed = matrixpricer.borrowAllowed(address(this), borrower);
        if (allowed != 0) {
            revert BorrowMatrixpricerRejection(allowed);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            revert BorrowFreshnessCheck();
        }
        uint currUSDTBalance = getCashExReserves();
        uint compoundBalance = getCmpBalanceInternal();
        uint borrowAmount = origBorrowAmount;
        uint256 totalUndUnborrowed = currUSDTBalance + compoundBalance;
        if (totalUndUnborrowed == 0) {
            revert BorrowCashNotAvailable();
        } else if (totalUndUnborrowed < borrowAmount) {
            borrowAmount = totalUndUnborrowed;
        }
        if (borrowAmount > currUSDTBalance) {
            uint amtNeeded = borrowAmount - currUSDTBalance;
            if (compoundBalance > (amtNeeded + extraUSDT)) {
                withdrawUSDTfromCmp(amtNeeded + extraUSDT);
            } else {
                withdrawUSDTfromCmp(compoundBalance);
            }
        }
        address payable levErc20Addr = payable(address(levErc20));
        uint accountBorrowsPrev = borrowBalanceStoredInternal(levErc20Addr);
        uint accountBorrowsNew = accountBorrowsPrev + borrowAmount;
        uint totalBorrowsNew = totalBorrows + borrowAmount;
        accountBorrows[levErc20Addr].principal = accountBorrowsNew;
        accountBorrows[levErc20Addr].interestIndex = borrowIndex;
        totalBorrows = totalBorrowsNew;
        uint _usdcRec = changeUSDT2USDC(borrowAmount, 0, levErc20Addr);
        uint transFx = (_usdcRec * expScale) / borrowAmount;
        console.log("changed %d usdt into %d usdc", borrowAmount, _usdcRec);
        emit Borrow(levErc20Addr, borrowAmount, accountBorrowsNew, totalBorrowsNew);
        return transFx;
    }

    ///  @notice Sender repays their own borrow
    ///  @param repayAmount The amount to repay
    ///  @param liquidate if levtoken is going thru liquidation
    function repayBorrowInternal(uint repayAmount, bool liquidate) internal nonReentrant() {
        if (!liquidate) {
            accrueInterest();
        }
        updateBorrowLedger(repayAmount, liquidate, false);
        uint currUSDTBalance = getCashExReserves();
        if (checkCompound(currUSDTBalance)) {
            supplyUSDT2Cmp(currUSDTBalance - thresholdUSDT);
        }
    }

    ///  @notice Sender repays their own borrow
    ///  @param repayAmount The amount to repay
    function updateBorrowLedger(uint repayAmount, bool liquidate, bool forced) virtual internal {
        address levErc20Addr = address(levErc20);
        if (liquidate) {
            uint accountBorrowsPrev = borrowBalanceStoredInternal(levErc20Addr);
            if (accountBorrowsPrev < repayAmount) {
                uint extraRepaid = repayAmount - accountBorrowsPrev;
                uint _usdcRec = changeUSDT2USDC(extraRepaid, 0, payable(levErc20Addr));
                console.log("changed back %d usdt into %d usdc", extraRepaid, _usdcRec);
            }
            accountBorrows[levErc20Addr].principal = 0;
            totalBorrows = 0;
            emit RepayBorrow(levErc20Addr, repayAmount, 0, 0, true);
        } else {
            uint accountBorrowsPrev = borrowBalanceStoredInternal(levErc20Addr);
            uint accountBorrowsNew;
            uint totalBorrowsNew;
            if (accountBorrowsPrev >= repayAmount) {
                accountBorrowsNew = accountBorrowsPrev - repayAmount;
                totalBorrowsNew = totalBorrows - repayAmount;
            } else {
                accountBorrowsNew = 0;
                if (totalBorrows > accountBorrowsPrev) {
                    totalBorrowsNew = totalBorrows - accountBorrowsPrev;
                } else {
                    totalBorrowsNew = 0;
                }
                uint extraRepaid = repayAmount - accountBorrowsPrev;
                uint _usdcRec = changeUSDT2USDC(extraRepaid, 0, payable(levErc20Addr));
                console.log("changed back %d usdt into %d usdc", extraRepaid, _usdcRec);
            }
            accountBorrows[levErc20Addr].principal = accountBorrowsNew;
            accountBorrows[levErc20Addr].interestIndex = borrowIndex;
            totalBorrows = totalBorrowsNew;
            if (forced) {
                levErc20.updateLedger();
            }
            emit RepayBorrow(levErc20Addr, repayAmount, accountBorrowsNew, totalBorrowsNew, false);
        }
    }

    ///  @notice Calculates the ideal utilization rate of the market: `idealborrows / (cash + borrows - reserves)`
    ///  @return The utilization rate as a mantissa between [0, MANTISSA]
    function idealUtilizationRate() public view returns (uint) {
        if (totalBorrows == 0) {
            return 0;
        }
        uint unborrowedCash = getCashExReserves() + getCmpBalanceInternal();
        uint idealBorrow;
        if (unborrowedCash > 0) {
            idealBorrow = totalBorrows;
        } else {
            uint extraborrowdemand = levErc20.getExtraBorrowDemand();
            uint extraborrowsupply = levErc20.getExtraBorrowSupply();
            if ((totalBorrows + extraborrowdemand) > extraborrowsupply) {
                idealBorrow = (totalBorrows + extraborrowdemand) - extraborrowsupply;
            } else {
                idealBorrow = 0;
            }
        }
        return (idealBorrow * expScale) / (unborrowedCash + totalBorrows);
    }

    ///  @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
    ///  @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
    ///  @param newPendingAdmin New pending admin.
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _setPendingAdmin(address payable newPendingAdmin) override external returns (uint) {
        if (msg.sender != admin) {
            revert SetPendingAdminOwnerCheck();
        }
        address oldPendingAdmin = pendingAdmin;
        pendingAdmin = newPendingAdmin;
        emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
        return NO_ERROR;
    }

    ///  @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
    ///  @dev Admin function for pending admin to accept role and update admin
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _acceptAdmin() override external returns (uint) {
        if ((msg.sender != pendingAdmin) || (msg.sender == address(0))) {
            revert AcceptAdminPendingAdminCheck();
        }
        address oldAdmin = admin;
        address oldPendingAdmin = pendingAdmin;
        admin = pendingAdmin;
        pendingAdmin = payable(address(0));
        emit NewAdmin(oldAdmin, admin);
        emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
        return NO_ERROR;
    }

    ///  @notice Sets a new matrixpricer for the market
    ///  @dev Admin function to set a new matrixpricer
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _setMatrixpricer(MatrixpricerInterface newMatrixpricer) override public returns (uint) {
        if (msg.sender != admin) {
            revert SetMatrixpricerOwnerCheck();
        }
        MatrixpricerInterface oldMatrixpricer = matrixpricer;
        require(newMatrixpricer.isMatrixpricer(), "marker method returned false");
        matrixpricer = newMatrixpricer;
        emit NewMatrixpricer(oldMatrixpricer, newMatrixpricer);
        return NO_ERROR;
    }

    ///  @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
    ///  @dev Admin function to accrue interest and set a new reserve factor
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _setReserveFactor(uint newReserveFactorMantissa) override external nonReentrant() returns (uint) {
        accrueInterest();
        return _setReserveFactorFresh(newReserveFactorMantissa);
    }

    ///  @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
    ///  @dev Admin function to set a new reserve factor
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
        if (msg.sender != admin) {
            revert SetReserveFactorAdminCheck();
        }
        if (accrualBlockNumber != getBlockNumber()) {
            revert SetReserveFactorFreshCheck();
        }
        if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
            revert SetReserveFactorBoundsCheck();
        }
        uint oldReserveFactorMantissa = reserveFactorMantissa;
        reserveFactorMantissa = newReserveFactorMantissa;
        emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
        return NO_ERROR;
    }

    ///  @notice Accrues interest and reduces reserves by transferring from msg.sender
    ///  @param addAmount Amount of addition to reserves
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _addReservesInternal(uint addAmount) internal nonReentrant() returns (uint) {
        accrueInterest();
        _addReservesFresh(addAmount);
        return NO_ERROR;
    }

    ///  @notice Add reserves by transferring from caller
    ///  @dev Requires fresh interest accrual
    ///  @param addAmount Amount of addition to reserves
    ///  @return (uint, uint) An error code (0=success, otherwise a failure (see ErrorReporter.sol for details)) and the actual amount added, net token fees
    function _addReservesFresh(uint addAmount) internal returns (uint, uint) {
        uint totalReservesNew;
        uint actualAddAmount;
        if (accrualBlockNumber != getBlockNumber()) {
            revert AddReservesFactorFreshCheck(actualAddAmount);
        }
        actualAddAmount = doTransferIn(msg.sender, addAmount);
        totalReservesNew = totalReserves + actualAddAmount;
        totalReserves = totalReservesNew;
        emit ReservesAdded(msg.sender, actualAddAmount, totalReservesNew);
        return (NO_ERROR, actualAddAmount);
    }

    ///  @notice Accrues interest and reduces reserves by transferring to admin
    ///  @param reduceAmount Amount of reduction to reserves
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _reduceReserves(uint reduceAmount) override external nonReentrant() returns (uint) {
        accrueInterest();
        return _reduceReservesFresh(reduceAmount);
    }

    ///  @notice Reduces reserves by transferring to admin
    ///  @dev Requires fresh interest accrual
    ///  @param reduceAmount Amount of reduction to reserves
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _reduceReservesFresh(uint reduceAmount) internal returns (uint) {
        uint totalReservesNew;
        if (msg.sender != admin) {
            revert ReduceReservesAdminCheck();
        }
        if (accrualBlockNumber != getBlockNumber()) {
            revert ReduceReservesFreshCheck();
        }
        if (getCashPrior() < reduceAmount) {
            revert ReduceReservesCashNotAvailable();
        }
        if (reduceAmount > totalReserves) {
            revert ReduceReservesCashValidation();
        }
        totalReservesNew = totalReserves - reduceAmount;
        totalReserves = totalReservesNew;
        doTransferOut(admin, reduceAmount);
        emit ReservesReduced(admin, reduceAmount, totalReservesNew);
        return NO_ERROR;
    }

    ///  @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
    ///  @dev Admin function to accrue interest and update the interest rate model
    ///  @param newInterestRateModel the new interest rate model to use
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _setInterestRateModel(InterestRateModel newInterestRateModel) override public returns (uint) {
        accrueInterest();
        return _setInterestRateModelFresh(newInterestRateModel);
    }

    ///  @notice updates the interest rate model (*requires fresh interest accrual)
    ///  @dev Admin function to update the interest rate model
    ///  @param newInterestRateModel the new interest rate model to use
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
        InterestRateModel oldInterestRateModel;
        if (msg.sender != admin) {
            revert SetInterestRateModelOwnerCheck();
        }
        if (accrualBlockNumber != getBlockNumber()) {
            revert SetInterestRateModelFreshCheck();
        }
        oldInterestRateModel = interestRateModel;
        require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
        interestRateModel = newInterestRateModel;
        return NO_ERROR;
    }

    ///  @notice Gets balance of this contract in terms of the underlying
    ///  @dev This excludes the value of the current message, if any
    ///  @return The quantity of underlying owned by this contract
    function getCashPrior() virtual internal view returns (uint);

    ///  @dev Performs a transfer in, reverting upon failure. Returns the amount actually transferred to the protocol, in case of a fee.
    ///   This may revert due to insufficient balance or insufficient allowance.
    function doTransferIn(address from, uint amount) virtual internal returns (uint);

    ///  @dev Performs a transfer out, ideally returning an explanatory error code upon failure rather than reverting.
    ///   If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
    ///   If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
    function doTransferOut(address payable to, uint amount) virtual internal;
}

///  @title DepErc20 Contract
///  @notice DepTokens which wrap an EIP-20 underlying
///  @author Vortex
contract DepErc20 is DepToken, DepErc20Interface {
    ///  @notice Initialize the new money market
    ///  @param underlying_ The address of the underlying asset
    ///  @param matrixpricer_ The address of the Matrixpricer
    ///  @param interestRateModel_ The address of the interest rate model
    ///  @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
    ///  @param name_ ERC-20 name of this token
    ///  @param symbol_ ERC-20 symbol of this token
    ///  @param decimals_ ERC-20 decimal precision of this token
    ///  @param levErc20_ The address of the associated levErc20
    function initialize(address underlying_, MatrixpricerInterface matrixpricer_, InterestRateModel interestRateModel_, uint initialExchangeRateMantissa_, string memory name_, string memory symbol_, uint8 decimals_, LevErc20Interface levErc20_) override public initializer() {
        admin = payable(msg.sender);
        super.initialize(underlying_, matrixpricer_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_, levErc20_);
        underlying = underlying_;
        EIP20Interface(underlying).totalSupply();
        reserveFactorMantissa = 1e17;
    }

    ///  @notice Sender supplies assets into the market and receives DepTokens in exchange
    ///  @dev Accrues interest whether or not the operation succeeds, unless reverted
    ///  @param mintAmount The amount of the underlying asset to supply
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function mint(uint mintAmount) override external returns (uint) {
        require(mintAmount > 0, "cannot mint <= 0");
        mintInternal(mintAmount);
        return NO_ERROR;
    }

    ///  @notice Sender redeems DepTokens in exchange for the underlying asset
    ///  @dev Accrues interest whether or not the operation succeeds, unless reverted
    ///  @param redeemTokens The number of DepTokens to redeem into underlying
    ///  @param redeemAmount The amount of underlying to redeem
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function redeem(uint redeemTokens, uint redeemAmount) override external returns (uint) {
        redeemInternal(redeemTokens, redeemAmount);
        return NO_ERROR;
    }

    ///  @notice Sender borrows assets from the protocol to their own address
    ///  @param borrowAmount The amount of the underlying asset to borrow
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function borrow(uint borrowAmount) override external returns (uint) {
        require(msg.sender == address(levErc20), "only levToken can call borrow");
        return borrowInternal(borrowAmount);
    }

    function getUnborrowedUSDTBalance() override external view returns (uint) {
        return getCashExReserves() + getCmpBalanceInternal();
    }

    function getTotalBorrows() override external view returns (uint) {
        return getTotalBorrowsInternal();
    }

    function getTotalBorrowsAfterAccrueInterest() override external returns (uint) {
        require(msg.sender == address(levErc20), "only levToken can call getTotalBorrowsAfterAccrueInterest");
        return getTotalBorrowsAfterAccrueInterestInternal();
    }

    ///  @notice Sender repays their own borrow
    ///  @param repayAmount The amount to repay, or -1 for the full outstanding amount
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function repayBorrow(uint repayAmount, bool liquidate) override external returns (uint) {
        require(msg.sender == address(levErc20), "only levToken can call repayBorrow");
        repayBorrowInternal(repayAmount, liquidate);
        return NO_ERROR;
    }

    ///  @notice The sender adds to reserves.
    ///  @param addAmount The amount fo underlying token to add as reserves
    ///  @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _addReserves(uint addAmount) override external returns (uint) {
        return _addReservesInternal(addAmount);
    }

    ///  @notice Gets balance of this contract in terms of the underlying
    ///  @dev This excludes the value of the current message, if any
    ///  @return The quantity of underlying tokens owned by this contract
    function getCashPrior() virtual override internal view returns (uint) {
        EIP20Interface token = EIP20Interface(underlying);
        return token.balanceOf(address(this));
    }

    ///  @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
    ///       This will revert due to insufficient balance or insufficient allowance.
    ///       This function returns the actual amount received,
    ///       which may be less than `amount` if there is a fee attached to the transfer.
    ///       Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
    ///             See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
    function doTransferIn(address from, uint amount) virtual override internal returns (uint) {
        address underlying_ = underlying;
        EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying_);
        uint balanceBefore = EIP20Interface(underlying_).balanceOf(address(this));
        token.transferFrom(from, address(this), amount);
        bool success;
        assembly {
            switch returndatasize()
            case 0 {
                success := not(0)
            }
            case 32 {
                returndatacopy(0, 0, 32)
                success := mload(0)
            }
            default {
                revert(0, 0)
            }
        }
        require(success, "TOKEN_TRANSFER_IN_FAILED");
        uint balanceAfter = EIP20Interface(underlying_).balanceOf(address(this));
        return balanceAfter - balanceBefore;
    }

    ///  @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
    ///       error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
    ///       insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
    ///       it is >= amount, this should not revert in normal conditions.
    ///       Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
    ///             See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
    function doTransferOut(address payable to, uint amount) virtual override internal {
        EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
        token.transfer(to, amount);
        bool success;
        assembly {
            switch returndatasize()
            case 0 {
                success := not(0)
            }
            case 32 {
                returndatacopy(0, 0, 32)
                success := mload(0)
            }
            default {
                revert(0, 0)
            }
        }
        require(success, "TOKEN_TRANSFER_OUT_FAILED");
    }
}