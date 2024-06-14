/// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity <0.9.0>=0.7.0^0.8.0;
pragma experimental ABIEncoderV2;

interface IAuthentication {
    ///  @dev Returns the action identifier associated with the external function described by `selector`.
    function getActionId(bytes4 selector) external view returns (bytes32);
}

///  @dev Interface for the SignatureValidator helper, used to support meta-transactions.
interface ISignaturesValidator {
    ///  @dev Returns the EIP712 domain separator.
    function getDomainSeparator() external view returns (bytes32);

    ///  @dev Returns the next nonce used by an address to sign messages.
    function getNextNonce(address user) external view returns (uint256);
}

///  @dev Interface for the TemporarilyPausable helper.
interface ITemporarilyPausable {
    ///  @dev Emitted every time the pause state changes by `_setPaused`.
    event PausedStateChanged(bool paused);

    ///  @dev Returns the current paused state.
    function getPausedState() external view returns (bool paused, uint256 pauseWindowEndTime, uint256 bufferPeriodEndTime);
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

    ///  @dev Moves `amount` tokens from the caller's account to `recipient`.
    ///  Returns a boolean value indicating whether the operation succeeded.
    ///  Emits a {Transfer} event.
    function transfer(address recipient, uint256 amount) external returns (bool);

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

    ///  @dev Moves `amount` tokens from `sender` to `recipient` using the
    ///  allowance mechanism. `amount` is then deducted from the caller's
    ///  allowance.
    ///  Returns a boolean value indicating whether the operation succeeded.
    ///  Emits a {Transfer} event.
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

///  @dev This is an empty interface used to represent either ERC20-conforming token contracts or ETH (using the zero
///  address sentinel value). We're just relying on the fact that `interface` can be used to declare new address-like
///  types.
///  This concept is unrelated to a Pool's Asset Managers.
interface IAsset {}

interface IAuthorizer {
    ///  @dev Returns true if `account` can perform the action described by `actionId` in the contract `where`.
    function canPerform(bytes32 actionId, address account, address where) external view returns (bool);
}

///  @dev Standard math utilities missing in the Solidity language.
library Math {
    ///  @dev Returns the largest of two numbers.
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a >= b) ? a : b;
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
        return (a / b) + (((a % b) == 0) ? 0 : 1);
    }
}

interface IBalancerStablePool {
    function getRate() external view returns (uint256);

    function getLatest(uint x) external view returns (uint256);
}

interface IChainlinkAggregator {
    event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 updatedAt);

    event NewRound(uint256 indexed roundId, address indexed startedBy);

    function decimals() external view returns (uint8);

    function latestAnswer() external view returns (int256);

    function latestTimestamp() external view returns (uint256);

    function latestRound() external view returns (uint256);

    function getAnswer(uint256 roundId) external view returns (int256);

    function getTimestamp(uint256 roundId) external view returns (uint256);

    function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

interface IOracle {
    /// @notice Get the latest price.
    ///  @return success if no valid (recent) rate is available, return false else true.
    ///  @return rate The rate of the requested asset / pair / pool.
    function get() external returns (bool success, uint256 rate);

    /// @notice Check the last price without any state changes.
    ///  @return success if no valid (recent) rate is available, return false else true.
    ///  @return rate The rate of the requested asset / pair / pool.
    function peek() external view returns (bool success, int256 rate);

    /// @notice Check the current spot price without any state changes. For oracles like TWAP this will be different from peek().
    ///  @return rate The rate of the requested asset / pair / pool.
    function latestAnswer() external view returns (int256 rate);
}

interface IOracleValidate {
    /// @notice Check the oracle (re-entrancy)
    function check() external;
}

///  @title Errors library
///  @author Sturdy, inspiration from Aave
///  @notice Defines the error messages emitted by the different contracts of the Sturdy protocol
///  @dev Error messages prefix glossary:
///   - VL = ValidationLogic
///   - MATH = Math libraries
///   - CT = Common errors between tokens (AToken, VariableDebtToken and StableDebtToken)
///   - AT = AToken
///   - SDT = StableDebtToken
///   - VDT = VariableDebtToken
///   - LP = LendingPool
///   - LPAPR = LendingPoolAddressesProviderRegistry
///   - LPC = LendingPoolConfiguration
///   - RL = ReserveLogic
///   - LPCM = LendingPoolCollateralManager
///   - P = Pausable
library Errors {
    enum CollateralManagerErrors {
        NO_ERROR,
        NO_COLLATERAL_AVAILABLE,
        COLLATERAL_CANNOT_BE_LIQUIDATED,
        CURRRENCY_NOT_BORROWED,
        HEALTH_FACTOR_ABOVE_THRESHOLD,
        NOT_ENOUGH_LIQUIDITY,
        NO_ACTIVE_RESERVE,
        HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD,
        INVALID_EQUAL_ASSETS_TO_SWAP,
        FROZEN_RESERVE
    }

    string internal constant CALLER_NOT_POOL_ADMIN = "33";
    string internal constant BORROW_ALLOWANCE_NOT_ENOUGH = "59";
    string internal constant VL_INVALID_AMOUNT = "1";
    string internal constant VL_NO_ACTIVE_RESERVE = "2";
    string internal constant VL_RESERVE_FROZEN = "3";
    string internal constant VL_CURRENT_AVAILABLE_LIQUIDITY_NOT_ENOUGH = "4";
    string internal constant VL_NOT_ENOUGH_AVAILABLE_USER_BALANCE = "5";
    string internal constant VL_TRANSFER_NOT_ALLOWED = "6";
    string internal constant VL_BORROWING_NOT_ENABLED = "7";
    string internal constant VL_INVALID_INTEREST_RATE_MODE_SELECTED = "8";
    string internal constant VL_COLLATERAL_BALANCE_IS_0 = "9";
    string internal constant VL_HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD = "10";
    string internal constant VL_COLLATERAL_CANNOT_COVER_NEW_BORROW = "11";
    string internal constant VL_STABLE_BORROWING_NOT_ENABLED = "12";
    string internal constant VL_COLLATERAL_SAME_AS_BORROWING_CURRENCY = "13";
    string internal constant VL_AMOUNT_BIGGER_THAN_MAX_LOAN_SIZE_STABLE = "14";
    string internal constant VL_NO_DEBT_OF_SELECTED_TYPE = "15";
    string internal constant VL_NO_EXPLICIT_AMOUNT_TO_REPAY_ON_BEHALF = "16";
    string internal constant VL_NO_STABLE_RATE_LOAN_IN_RESERVE = "17";
    string internal constant VL_NO_VARIABLE_RATE_LOAN_IN_RESERVE = "18";
    string internal constant VL_UNDERLYING_BALANCE_NOT_GREATER_THAN_0 = "19";
    string internal constant VL_DEPOSIT_ALREADY_IN_USE = "20";
    string internal constant LP_NOT_ENOUGH_STABLE_BORROW_BALANCE = "21";
    string internal constant LP_INTEREST_RATE_REBALANCE_CONDITIONS_NOT_MET = "22";
    string internal constant LP_LIQUIDATION_CALL_FAILED = "23";
    string internal constant LP_NOT_ENOUGH_LIQUIDITY_TO_BORROW = "24";
    string internal constant LP_REQUESTED_AMOUNT_TOO_SMALL = "25";
    string internal constant LP_INCONSISTENT_PROTOCOL_ACTUAL_BALANCE = "26";
    string internal constant LP_CALLER_NOT_LENDING_POOL_CONFIGURATOR = "27";
    string internal constant LP_INCONSISTENT_FLASHLOAN_PARAMS = "28";
    string internal constant CT_CALLER_MUST_BE_LENDING_POOL = "29";
    string internal constant CT_CANNOT_GIVE_ALLOWANCE_TO_HIMSELF = "30";
    string internal constant CT_TRANSFER_AMOUNT_NOT_GT_0 = "31";
    string internal constant RL_RESERVE_ALREADY_INITIALIZED = "32";
    string internal constant LPC_RESERVE_LIQUIDITY_NOT_0 = "34";
    string internal constant LPC_INVALID_ATOKEN_POOL_ADDRESS = "35";
    string internal constant LPC_INVALID_STABLE_DEBT_TOKEN_POOL_ADDRESS = "36";
    string internal constant LPC_INVALID_VARIABLE_DEBT_TOKEN_POOL_ADDRESS = "37";
    string internal constant LPC_INVALID_STABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = "38";
    string internal constant LPC_INVALID_VARIABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = "39";
    string internal constant LPC_INVALID_ADDRESSES_PROVIDER_ID = "40";
    string internal constant LPC_INVALID_CONFIGURATION = "75";
    string internal constant LPC_CALLER_NOT_EMERGENCY_ADMIN = "76";
    string internal constant LPAPR_PROVIDER_NOT_REGISTERED = "41";
    string internal constant LPCM_HEALTH_FACTOR_NOT_BELOW_THRESHOLD = "42";
    string internal constant LPCM_COLLATERAL_CANNOT_BE_LIQUIDATED = "43";
    string internal constant LPCM_SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = "44";
    string internal constant LPCM_NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = "45";
    string internal constant LPCM_NO_ERRORS = "46";
    string internal constant LP_INVALID_FLASHLOAN_MODE = "47";
    string internal constant MATH_MULTIPLICATION_OVERFLOW = "48";
    string internal constant MATH_ADDITION_OVERFLOW = "49";
    string internal constant MATH_DIVISION_BY_ZERO = "50";
    string internal constant RL_LIQUIDITY_INDEX_OVERFLOW = "51";
    string internal constant RL_VARIABLE_BORROW_INDEX_OVERFLOW = "52";
    string internal constant RL_LIQUIDITY_RATE_OVERFLOW = "53";
    string internal constant RL_VARIABLE_BORROW_RATE_OVERFLOW = "54";
    string internal constant RL_STABLE_BORROW_RATE_OVERFLOW = "55";
    string internal constant CT_INVALID_MINT_AMOUNT = "56";
    string internal constant LP_FAILED_REPAY_WITH_COLLATERAL = "57";
    string internal constant CT_INVALID_BURN_AMOUNT = "58";
    string internal constant LP_FAILED_COLLATERAL_SWAP = "60";
    string internal constant LP_INVALID_EQUAL_ASSETS_TO_SWAP = "61";
    string internal constant LP_REENTRANCY_NOT_ALLOWED = "62";
    string internal constant LP_CALLER_MUST_BE_AN_ATOKEN = "63";
    string internal constant LP_IS_PAUSED = "64";
    string internal constant LP_NO_MORE_RESERVES_ALLOWED = "65";
    string internal constant LP_INVALID_FLASH_LOAN_EXECUTOR_RETURN = "66";
    string internal constant RC_INVALID_LTV = "67";
    string internal constant RC_INVALID_LIQ_THRESHOLD = "68";
    string internal constant RC_INVALID_LIQ_BONUS = "69";
    string internal constant RC_INVALID_DECIMALS = "70";
    string internal constant RC_INVALID_RESERVE_FACTOR = "71";
    string internal constant LPAPR_INVALID_ADDRESSES_PROVIDER_ID = "72";
    string internal constant VL_INCONSISTENT_FLASHLOAN_PARAMS = "73";
    string internal constant LP_INCONSISTENT_PARAMS_LENGTH = "74";
    string internal constant UL_INVALID_INDEX = "77";
    string internal constant LP_NOT_CONTRACT = "78";
    string internal constant SDT_STABLE_DEBT_OVERFLOW = "79";
    string internal constant SDT_BURN_EXCEEDS_BALANCE = "80";
    string internal constant VT_COLLATERAL_DEPOSIT_REQUIRE_ETH = "81";
    string internal constant VT_COLLATERAL_DEPOSIT_INVALID = "82";
    string internal constant VT_LIQUIDITY_DEPOSIT_INVALID = "83";
    string internal constant VT_COLLATERAL_WITHDRAW_INVALID = "84";
    string internal constant VT_COLLATERAL_WITHDRAW_INVALID_AMOUNT = "85";
    string internal constant VT_CONVERT_ASSET_BY_CURVE_INVALID = "86";
    string internal constant VT_PROCESS_YIELD_INVALID = "87";
    string internal constant VT_TREASURY_INVALID = "88";
    string internal constant LP_ATOKEN_INIT_INVALID = "89";
    string internal constant VT_FEE_TOO_BIG = "90";
    string internal constant VT_COLLATERAL_DEPOSIT_VAULT_UNAVAILABLE = "91";
    string internal constant LP_LIQUIDATION_CONVERT_FAILED = "92";
    string internal constant VT_DEPLOY_FAILED = "93";
    string internal constant VT_INVALID_CONFIGURATION = "94";
    string internal constant VL_OVERFLOW_MAX_RESERVE_CAPACITY = "95";
    string internal constant VT_WITHDRAW_AMOUNT_MISMATCH = "96";
    string internal constant VT_SWAP_MISMATCH_RETURNED_AMOUNT = "97";
    string internal constant CALLER_NOT_YIELD_PROCESSOR = "98";
    string internal constant VT_EXTRA_REWARDS_INDEX_INVALID = "99";
    string internal constant VT_SWAP_PATH_LENGTH_INVALID = "100";
    string internal constant VT_SWAP_PATH_TOKEN_INVALID = "101";
    string internal constant CLAIMER_UNAUTHORIZED = "102";
    string internal constant YD_INVALID_CONFIGURATION = "103";
    string internal constant CALLER_NOT_EMISSION_MANAGER = "104";
    string internal constant CALLER_NOT_INCENTIVE_CONTROLLER = "105";
    string internal constant YD_VR_ASSET_ALREADY_IN_USE = "106";
    string internal constant YD_VR_INVALID_VAULT = "107";
    string internal constant YD_VR_INVALID_REWARDS_AMOUNT = "108";
    string internal constant YD_VR_REWARD_TOKEN_NOT_VALID = "109";
    string internal constant YD_VR_ASSET_NOT_REGISTERED = "110";
    string internal constant YD_VR_CALLER_NOT_VAULT = "111";
    string internal constant LS_INVALID_CONFIGURATION = "112";
    string internal constant LS_SWAP_AMOUNT_NOT_GT_0 = "113";
    string internal constant LS_BORROWING_ASSET_NOT_SUPPORTED = "114";
    string internal constant LS_SUPPLY_NOT_ALLOWED = "115";
    string internal constant LS_SUPPLY_FAILED = "116";
    string internal constant LS_REPAY_FAILED = "117";
    string internal constant O_WRONG_PRICE = "118";
}

///  @dev Interface for WETH9.
///  See https://github.com/gnosis/canonical-weth/blob/0dd1ea3e295eef916d0c6223ec63141137d22d67/contracts/WETH9.sol
interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint256 amount) external;
}

interface IFlashLoanRecipient {
    ///  @dev When `flashLoan` is called on the Vault, it invokes the `receiveFlashLoan` hook on the recipient.
    ///  At the time of the call, the Vault will have transferred `amounts` for `tokens` to the recipient. Before this
    ///  call returns, the recipient must have transferred `amounts` plus `feeAmounts` for each token back to the
    ///  Vault, or else the entire flash loan will revert.
    ///  `userData` is the same value passed in the `IVault.flashLoan` call.
    function receiveFlashLoan(IERC20[] memory tokens, uint256[] memory amounts, uint256[] memory feeAmounts, bytes memory userData) external;
}

interface IProtocolFeesCollector {
    event SwapFeePercentageChanged(uint256 newSwapFeePercentage);

    event FlashLoanFeePercentageChanged(uint256 newFlashLoanFeePercentage);

    function withdrawCollectedFees(IERC20[] calldata tokens, uint256[] calldata amounts, address recipient) external;

    function setSwapFeePercentage(uint256 newSwapFeePercentage) external;

    function setFlashLoanFeePercentage(uint256 newFlashLoanFeePercentage) external;

    function getSwapFeePercentage() external view returns (uint256);

    function getFlashLoanFeePercentage() external view returns (uint256);

    function getCollectedFeeAmounts(IERC20[] memory tokens) external view returns (uint256[] memory feeAmounts);

    function getAuthorizer() external view returns (IAuthorizer);

    function vault() external view returns (IVault);
}

///  @dev Full external interface for the Vault core contract - no external or public methods exist in the contract that
///  don't override one of these declarations.
interface IVault is ISignaturesValidator, ITemporarilyPausable, IAuthentication {
    enum UserBalanceOpKind {
        DEPOSIT_INTERNAL,
        WITHDRAW_INTERNAL,
        TRANSFER_INTERNAL,
        TRANSFER_EXTERNAL
    }

    enum PoolSpecialization {
        GENERAL,
        MINIMAL_SWAP_INFO,
        TWO_TOKEN
    }

    enum PoolBalanceChangeKind {
        JOIN,
        EXIT
    }

    enum SwapKind {
        GIVEN_IN,
        GIVEN_OUT
    }

    ///  Withdrawals decrease the Pool's cash, but increase its managed balance, leaving the total balance unchanged.
    ///  Deposits increase the Pool's cash, but decrease its managed balance, leaving the total balance unchanged.
    ///  Updates don't affect the Pool's cash balance, but because the managed balance changes, it does alter the total.
    ///  The external amount can be either increased or decreased by this call (i.e., reporting a gain or a loss).
    enum PoolBalanceOpKind {
        WITHDRAW,
        DEPOSIT,
        UPDATE
    }

    ///  @dev Emitted when a new authorizer is set by `setAuthorizer`.
    event AuthorizerChanged(IAuthorizer indexed newAuthorizer);

    ///  @dev Emitted every time a relayer is approved or disapproved by `setRelayerApproval`.
    event RelayerApprovalChanged(address indexed relayer, address indexed sender, bool approved);

    ///  @dev Emitted when a user's Internal Balance changes, either from calls to `manageUserBalance`, or through
    ///  interacting with Pools using Internal Balance.
    ///  Because Internal Balance works exclusively with ERC20 tokens, ETH deposits and withdrawals will use the WETH
    ///  address.
    event InternalBalanceChanged(address indexed user, IERC20 indexed token, int256 delta);

    ///  @dev Emitted when a user's Vault ERC20 allowance is used by the Vault to transfer tokens to an external account.
    event ExternalBalanceTransfer(IERC20 indexed token, address indexed sender, address recipient, uint256 amount);

    ///  @dev Emitted when a Pool is registered by calling `registerPool`.
    event PoolRegistered(bytes32 indexed poolId, address indexed poolAddress, PoolSpecialization specialization);

    ///  @dev Emitted when a Pool registers tokens by calling `registerTokens`.
    event TokensRegistered(bytes32 indexed poolId, IERC20[] tokens, address[] assetManagers);

    ///  @dev Emitted when a Pool deregisters tokens by calling `deregisterTokens`.
    event TokensDeregistered(bytes32 indexed poolId, IERC20[] tokens);

    ///  @dev Emitted when a user joins or exits a Pool by calling `joinPool` or `exitPool`, respectively.
    event PoolBalanceChanged(bytes32 indexed poolId, address indexed liquidityProvider, IERC20[] tokens, int256[] deltas, uint256[] protocolFeeAmounts);

    ///  @dev Emitted for each individual swap performed by `swap` or `batchSwap`.
    event Swap(bytes32 indexed poolId, IERC20 indexed tokenIn, IERC20 indexed tokenOut, uint256 amountIn, uint256 amountOut);

    ///  @dev Emitted for each individual flash loan performed by `flashLoan`.
    event FlashLoan(IFlashLoanRecipient indexed recipient, IERC20 indexed token, uint256 amount, uint256 feeAmount);

    ///  @dev Emitted when a Pool's token Asset Manager alters its balance via `managePoolBalance`.
    event PoolBalanceManaged(bytes32 indexed poolId, address indexed assetManager, IERC20 indexed token, int256 cashDelta, int256 managedDelta);

    ///  @dev Data for `manageUserBalance` operations, which include the possibility for ETH to be sent and received
    /// without manual WETH wrapping or unwrapping.
    struct UserBalanceOp {
        UserBalanceOpKind kind;
        IAsset asset;
        uint256 amount;
        address sender;
        address payable recipient;
    }

    struct JoinPoolRequest {
        IAsset[] assets;
        uint256[] maxAmountsIn;
        bytes userData;
        bool fromInternalBalance;
    }

    struct ExitPoolRequest {
        IAsset[] assets;
        uint256[] minAmountsOut;
        bytes userData;
        bool toInternalBalance;
    }

    ///  @dev Data for a single swap executed by `swap`. `amount` is either `amountIn` or `amountOut` depending on
    ///  the `kind` value.
    ///  `assetIn` and `assetOut` are either token addresses, or the IAsset sentinel value for ETH (the zero address).
    ///  Note that Pools never interact with ETH directly: it will be wrapped to or unwrapped from WETH by the Vault.
    ///  The `userData` field is ignored by the Vault, but forwarded to the Pool in the `onSwap` hook, and may be
    ///  used to extend swap behavior.
    struct SingleSwap {
        bytes32 poolId;
        SwapKind kind;
        IAsset assetIn;
        IAsset assetOut;
        uint256 amount;
        bytes userData;
    }

    ///  @dev Data for each individual swap executed by `batchSwap`. The asset in and out fields are indexes into the
    ///  `assets` array passed to that function, and ETH assets are converted to WETH.
    ///  If `amount` is zero, the multihop mechanism is used to determine the actual amount based on the amount in/out
    ///  from the previous swap, depending on the swap kind.
    ///  The `userData` field is ignored by the Vault, but forwarded to the Pool in the `onSwap` hook, and may be
    ///  used to extend swap behavior.
    struct BatchSwapStep {
        bytes32 poolId;
        uint256 assetInIndex;
        uint256 assetOutIndex;
        uint256 amount;
        bytes userData;
    }

    ///  @dev All tokens in a swap are either sent from the `sender` account to the Vault, or from the Vault to the
    ///  `recipient` account.
    ///  If the caller is not `sender`, it must be an authorized relayer for them.
    ///  If `fromInternalBalance` is true, the `sender`'s Internal Balance will be preferred, performing an ERC20
    ///  transfer for the difference between the requested amount and the User's Internal Balance (if any). The `sender`
    ///  must have allowed the Vault to use their tokens via `IERC20.approve()`. This matches the behavior of
    ///  `joinPool`.
    ///  If `toInternalBalance` is true, tokens will be deposited to `recipient`'s internal balance instead of
    ///  transferred. This matches the behavior of `exitPool`.
    ///  Note that ETH cannot be deposited to or withdrawn from Internal Balance: attempting to do so will trigger a
    ///  revert.
    struct FundManagement {
        address sender;
        bool fromInternalBalance;
        address payable recipient;
        bool toInternalBalance;
    }

    struct PoolBalanceOp {
        PoolBalanceOpKind kind;
        bytes32 poolId;
        IERC20 token;
        uint256 amount;
    }

    ///  @dev Returns the Vault's Authorizer.
    function getAuthorizer() external view returns (IAuthorizer);

    ///  @dev Sets a new Authorizer for the Vault. The caller must be allowed by the current Authorizer to do this.
    ///  Emits an `AuthorizerChanged` event.
    function setAuthorizer(IAuthorizer newAuthorizer) external;

    ///  @dev Returns true if `user` has approved `relayer` to act as a relayer for them.
    function hasApprovedRelayer(address user, address relayer) external view returns (bool);

    ///  @dev Allows `relayer` to act as a relayer for `sender` if `approved` is true, and disallows it otherwise.
    ///  Emits a `RelayerApprovalChanged` event.
    function setRelayerApproval(address sender, address relayer, bool approved) external;

    ///  @dev Returns `user`'s Internal Balance for a set of tokens.
    function getInternalBalance(address user, IERC20[] memory tokens) external view returns (uint256[] memory);

    ///  @dev Performs a set of user balance operations, which involve Internal Balance (deposit, withdraw or transfer)
    ///  and plain ERC20 transfers using the Vault's allowance. This last feature is particularly useful for relayers, as
    ///  it lets integrators reuse a user's Vault allowance.
    ///  For each operation, if the caller is not `sender`, it must be an authorized relayer for them.
    function manageUserBalance(UserBalanceOp[] memory ops) external payable;

    ///  @dev Registers the caller account as a Pool with a given specialization setting. Returns the Pool's ID, which
    ///  is used in all Pool-related functions. Pools cannot be deregistered, nor can the Pool's specialization be
    ///  changed.
    ///  The caller is expected to be a smart contract that implements either `IGeneralPool` or `IMinimalSwapInfoPool`,
    ///  depending on the chosen specialization setting. This contract is known as the Pool's contract.
    ///  Note that the same contract may register itself as multiple Pools with unique Pool IDs, or in other words,
    ///  multiple Pools may share the same contract.
    ///  Emits a `PoolRegistered` event.
    function registerPool(PoolSpecialization specialization) external returns (bytes32);

    ///  @dev Returns a Pool's contract address and specialization setting.
    function getPool(bytes32 poolId) external view returns (address, PoolSpecialization);

    ///  @dev Registers `tokens` for the `poolId` Pool. Must be called by the Pool's contract.
    ///  Pools can only interact with tokens they have registered. Users join a Pool by transferring registered tokens,
    ///  exit by receiving registered tokens, and can only swap registered tokens.
    ///  Each token can only be registered once. For Pools with the Two Token specialization, `tokens` must have a length
    ///  of two, that is, both tokens must be registered in the same `registerTokens` call, and they must be sorted in
    ///  ascending order.
    ///  The `tokens` and `assetManagers` arrays must have the same length, and each entry in these indicates the Asset
    ///  Manager for the corresponding token. Asset Managers can manage a Pool's tokens via `managePoolBalance`,
    ///  depositing and withdrawing them directly, and can even set their balance to arbitrary amounts. They are therefore
    ///  expected to be highly secured smart contracts with sound design principles, and the decision to register an
    ///  Asset Manager should not be made lightly.
    ///  Pools can choose not to assign an Asset Manager to a given token by passing in the zero address. Once an Asset
    ///  Manager is set, it cannot be changed except by deregistering the associated token and registering again with a
    ///  different Asset Manager.
    ///  Emits a `TokensRegistered` event.
    function registerTokens(bytes32 poolId, IERC20[] memory tokens, address[] memory assetManagers) external;

    ///  @dev Deregisters `tokens` for the `poolId` Pool. Must be called by the Pool's contract.
    ///  Only registered tokens (via `registerTokens`) can be deregistered. Additionally, they must have zero total
    ///  balance. For Pools with the Two Token specialization, `tokens` must have a length of two, that is, both tokens
    ///  must be deregistered in the same `deregisterTokens` call.
    ///  A deregistered token can be re-registered later on, possibly with a different Asset Manager.
    ///  Emits a `TokensDeregistered` event.
    function deregisterTokens(bytes32 poolId, IERC20[] memory tokens) external;

    ///  @dev Returns detailed information for a Pool's registered token.
    ///  `cash` is the number of tokens the Vault currently holds for the Pool. `managed` is the number of tokens
    ///  withdrawn and held outside the Vault by the Pool's token Asset Manager. The Pool's total balance for `token`
    ///  equals the sum of `cash` and `managed`.
    ///  Internally, `cash` and `managed` are stored using 112 bits. No action can ever cause a Pool's token `cash`,
    ///  `managed` or `total` balance to be greater than 2^112 - 1.
    ///  `lastChangeBlock` is the number of the block in which `token`'s total balance was last modified (via either a
    ///  join, exit, swap, or Asset Manager update). This value is useful to avoid so-called 'sandwich attacks', for
    ///  example when developing price oracles. A change of zero (e.g. caused by a swap with amount zero) is considered a
    ///  change for this purpose, and will update `lastChangeBlock`.
    ///  `assetManager` is the Pool's token Asset Manager.
    function getPoolTokenInfo(bytes32 poolId, IERC20 token) external view returns (uint256 cash, uint256 managed, uint256 lastChangeBlock, address assetManager);

    ///  @dev Returns a Pool's registered tokens, the total balance for each, and the latest block when *any* of
    ///  the tokens' `balances` changed.
    ///  The order of the `tokens` array is the same order that will be used in `joinPool`, `exitPool`, as well as in all
    ///  Pool hooks (where applicable). Calls to `registerTokens` and `deregisterTokens` may change this order.
    ///  If a Pool only registers tokens once, and these are sorted in ascending order, they will be stored in the same
    ///  order as passed to `registerTokens`.
    ///  Total balances include both tokens held by the Vault and those withdrawn by the Pool's Asset Managers. These are
    ///  the amounts used by joins, exits and swaps. For a detailed breakdown of token balances, use `getPoolTokenInfo`
    ///  instead.
    function getPoolTokens(bytes32 poolId) external view returns (IERC20[] memory tokens, uint256[] memory balances, uint256 lastChangeBlock);

    ///  @dev Called by users to join a Pool, which transfers tokens from `sender` into the Pool's balance. This will
    ///  trigger custom Pool behavior, which will typically grant something in return to `recipient` - often tokenized
    ///  Pool shares.
    ///  If the caller is not `sender`, it must be an authorized relayer for them.
    ///  The `assets` and `maxAmountsIn` arrays must have the same length, and each entry indicates the maximum amount
    ///  to send for each asset. The amounts to send are decided by the Pool and not the Vault: it just enforces
    ///  these maximums.
    ///  If joining a Pool that holds WETH, it is possible to send ETH directly: the Vault will do the wrapping. To enable
    ///  this mechanism, the IAsset sentinel value (the zero address) must be passed in the `assets` array instead of the
    ///  WETH address. Note that it is not possible to combine ETH and WETH in the same join. Any excess ETH will be sent
    ///  back to the caller (not the sender, which is important for relayers).
    ///  `assets` must have the same length and order as the array returned by `getPoolTokens`. This prevents issues when
    ///  interacting with Pools that register and deregister tokens frequently. If sending ETH however, the array must be
    ///  sorted *before* replacing the WETH address with the ETH sentinel value (the zero address), which means the final
    ///  `assets` array might not be sorted. Pools with no registered tokens cannot be joined.
    ///  If `fromInternalBalance` is true, the caller's Internal Balance will be preferred: ERC20 transfers will only
    ///  be made for the difference between the requested amount and Internal Balance (if any). Note that ETH cannot be
    ///  withdrawn from Internal Balance: attempting to do so will trigger a revert.
    ///  This causes the Vault to call the `IBasePool.onJoinPool` hook on the Pool's contract, where Pools implement
    ///  their own custom logic. This typically requires additional information from the user (such as the expected number
    ///  of Pool shares). This can be encoded in the `userData` argument, which is ignored by the Vault and passed
    ///  directly to the Pool's contract, as is `recipient`.
    ///  Emits a `PoolBalanceChanged` event.
    function joinPool(bytes32 poolId, address sender, address recipient, JoinPoolRequest memory request) external payable;

    ///  @dev Called by users to exit a Pool, which transfers tokens from the Pool's balance to `recipient`. This will
    ///  trigger custom Pool behavior, which will typically ask for something in return from `sender` - often tokenized
    ///  Pool shares. The amount of tokens that can be withdrawn is limited by the Pool's `cash` balance (see
    ///  `getPoolTokenInfo`).
    ///  If the caller is not `sender`, it must be an authorized relayer for them.
    ///  The `tokens` and `minAmountsOut` arrays must have the same length, and each entry in these indicates the minimum
    ///  token amount to receive for each token contract. The amounts to send are decided by the Pool and not the Vault:
    ///  it just enforces these minimums.
    ///  If exiting a Pool that holds WETH, it is possible to receive ETH directly: the Vault will do the unwrapping. To
    ///  enable this mechanism, the IAsset sentinel value (the zero address) must be passed in the `assets` array instead
    ///  of the WETH address. Note that it is not possible to combine ETH and WETH in the same exit.
    ///  `assets` must have the same length and order as the array returned by `getPoolTokens`. This prevents issues when
    ///  interacting with Pools that register and deregister tokens frequently. If receiving ETH however, the array must
    ///  be sorted *before* replacing the WETH address with the ETH sentinel value (the zero address), which means the
    ///  final `assets` array might not be sorted. Pools with no registered tokens cannot be exited.
    ///  If `toInternalBalance` is true, the tokens will be deposited to `recipient`'s Internal Balance. Otherwise,
    ///  an ERC20 transfer will be performed. Note that ETH cannot be deposited to Internal Balance: attempting to
    ///  do so will trigger a revert.
    ///  `minAmountsOut` is the minimum amount of tokens the user expects to get out of the Pool, for each token in the
    ///  `tokens` array. This array must match the Pool's registered tokens.
    ///  This causes the Vault to call the `IBasePool.onExitPool` hook on the Pool's contract, where Pools implement
    ///  their own custom logic. This typically requires additional information from the user (such as the expected number
    ///  of Pool shares to return). This can be encoded in the `userData` argument, which is ignored by the Vault and
    ///  passed directly to the Pool's contract.
    ///  Emits a `PoolBalanceChanged` event.
    function exitPool(bytes32 poolId, address sender, address payable recipient, ExitPoolRequest memory request) external;

    ///  @dev Performs a swap with a single Pool.
    ///  If the swap is 'given in' (the number of tokens to send to the Pool is known), it returns the amount of tokens
    ///  taken from the Pool, which must be greater than or equal to `limit`.
    ///  If the swap is 'given out' (the number of tokens to take from the Pool is known), it returns the amount of tokens
    ///  sent to the Pool, which must be less than or equal to `limit`.
    ///  Internal Balance usage and the recipient are determined by the `funds` struct.
    ///  Emits a `Swap` event.
    function swap(SingleSwap memory singleSwap, FundManagement memory funds, uint256 limit, uint256 deadline) external payable returns (uint256);

    ///  @dev Performs a series of swaps with one or multiple Pools. In each individual swap, the caller determines either
    ///  the amount of tokens sent to or received from the Pool, depending on the `kind` value.
    ///  Returns an array with the net Vault asset balance deltas. Positive amounts represent tokens (or ETH) sent to the
    ///  Vault, and negative amounts represent tokens (or ETH) sent by the Vault. Each delta corresponds to the asset at
    ///  the same index in the `assets` array.
    ///  Swaps are executed sequentially, in the order specified by the `swaps` array. Each array element describes a
    ///  Pool, the token to be sent to this Pool, the token to receive from it, and an amount that is either `amountIn` or
    ///  `amountOut` depending on the swap kind.
    ///  Multihop swaps can be executed by passing an `amount` value of zero for a swap. This will cause the amount in/out
    ///  of the previous swap to be used as the amount in for the current one. In a 'given in' swap, 'tokenIn' must equal
    ///  the previous swap's `tokenOut`. For a 'given out' swap, `tokenOut` must equal the previous swap's `tokenIn`.
    ///  The `assets` array contains the addresses of all assets involved in the swaps. These are either token addresses,
    ///  or the IAsset sentinel value for ETH (the zero address). Each entry in the `swaps` array specifies tokens in and
    ///  out by referencing an index in `assets`. Note that Pools never interact with ETH directly: it will be wrapped to
    ///  or unwrapped from WETH by the Vault.
    ///  Internal Balance usage, sender, and recipient are determined by the `funds` struct. The `limits` array specifies
    ///  the minimum or maximum amount of each token the vault is allowed to transfer.
    ///  `batchSwap` can be used to make a single swap, like `swap` does, but doing so requires more gas than the
    ///  equivalent `swap` call.
    ///  Emits `Swap` events.
    function batchSwap(SwapKind kind, BatchSwapStep[] memory swaps, IAsset[] memory assets, FundManagement memory funds, int256[] memory limits, uint256 deadline) external payable returns (int256[] memory);

    ///  @dev Simulates a call to `batchSwap`, returning an array of Vault asset deltas. Calls to `swap` cannot be
    ///  simulated directly, but an equivalent `batchSwap` call can and will yield the exact same result.
    ///  Each element in the array corresponds to the asset at the same index, and indicates the number of tokens (or ETH)
    ///  the Vault would take from the sender (if positive) or send to the recipient (if negative). The arguments it
    ///  receives are the same that an equivalent `batchSwap` call would receive.
    ///  Unlike `batchSwap`, this function performs no checks on the sender or recipient field in the `funds` struct.
    ///  This makes it suitable to be called by off-chain applications via eth_call without needing to hold tokens,
    ///  approve them for the Vault, or even know a user's address.
    ///  Note that this function is not 'view' (due to implementation details): the client code must explicitly execute
    ///  eth_call instead of eth_sendTransaction.
    function queryBatchSwap(SwapKind kind, BatchSwapStep[] memory swaps, IAsset[] memory assets, FundManagement memory funds) external returns (int256[] memory assetDeltas);

    ///  @dev Performs a 'flash loan', sending tokens to `recipient`, executing the `receiveFlashLoan` hook on it,
    ///  and then reverting unless the tokens plus a proportional protocol fee have been returned.
    ///  The `tokens` and `amounts` arrays must have the same length, and each entry in these indicates the loan amount
    ///  for each token contract. `tokens` must be sorted in ascending order.
    ///  The 'userData' field is ignored by the Vault, and forwarded as-is to `recipient` as part of the
    ///  `receiveFlashLoan` call.
    ///  Emits `FlashLoan` events.
    function flashLoan(IFlashLoanRecipient recipient, IERC20[] memory tokens, uint256[] memory amounts, bytes memory userData) external;

    ///  @dev Performs a set of Pool balance operations, which may be either withdrawals, deposits or updates.
    ///  Pool Balance management features batching, which means a single contract call can be used to perform multiple
    ///  operations of different kinds, with different Pools and tokens, at once.
    ///  For each operation, the caller must be registered as the Asset Manager for `token` in `poolId`.
    function managePoolBalance(PoolBalanceOp[] memory ops) external;

    ///  @dev Returns the current protocol fee module.
    function getProtocolFeesCollector() external view returns (IProtocolFeesCollector);

    ///  @dev Safety mechanism to pause most Vault operations in the event of an emergency - typically detection of an
    ///  error in some part of the system.
    ///  The Vault can only be paused during an initial time period, after which pausing is forever disabled.
    ///  While the contract is paused, the following features are disabled:
    ///  - depositing and transferring internal balance
    ///  - transferring external balance (using the Vault's allowance)
    ///  - swaps
    ///  - joining Pools
    ///  - Asset Manager interactions
    ///  Internal Balance can still be withdrawn, and Pools exited.
    function setPaused(bool paused) external;

    ///  @dev Returns the Vault's WETH instance.
    function WETH() external view returns (IWETH);
}

///  @dev Oracle contract for BALWSTETHWETH LP Token
contract BALWSTETHWETHOracle is IOracle, IOracleValidate {
    IBalancerStablePool private constant BALWSTETHWETH = IBalancerStablePool(0x32296969Ef14EB0c6d29669C550D4a0449130230);
    /// @custom:consol {IChainlinkAggregator(STETH).latestRoundData{value: v, gas: g}() returns (roundId, answer, startedAt, updatedAt, answeredInRound) ensures {(updatedAt > block.timestamp - 1 days) && (answer > 0)}}
    uint256 private STETH = _wrap_STETH(0x86392dC19c0b719886221c78AB11eb8Cf5c52812);
    address private constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;

    /// @custom:consol
    ///  {_get() returns (ret)
    ///    ensures {(ret * 95 / 100 < BALWSTETHWETH.getLatest(1)) && 
    ///        (ret * 105 / 100 > BALWSTETHWETH.getLatest(1))}}
    function _get_original() private view returns (uint256) {
        (, int256 stETHPrice, , uint256 updatedAt, ) = _dispatch_IChainlinkAggregator_latestRoundData(STETH, 0, gasleft());
        require(updatedAt > (block.timestamp - 1 days), Errors.O_WRONG_PRICE);
        require(stETHPrice > 0, Errors.O_WRONG_PRICE);
        uint256 minValue = Math.min(uint256(stETHPrice), 1e18);
        return (BALWSTETHWETH.getRate() * minValue) / 1e18;
    }

    /// @inheritdoc IOracle
    function get() override external view returns (bool, uint256) {
        return (true, _get());
    }

    /// @inheritdoc IOracle
    function peek() override external view returns (bool, int256) {
        return (true, int256(_get()));
    }

    /// @inheritdoc IOracle
    function latestAnswer() override external view returns (int256 rate) {
        return int256(_get());
    }

    /// @inheritdoc IOracleValidate
    function check() external {
        IVault.UserBalanceOp[] memory ops = new IVault.UserBalanceOp[](1);
        ops[0].kind = IVault.UserBalanceOpKind.WITHDRAW_INTERNAL;
        ops[0].sender = address(this);
        IVault(BALANCER_VAULT).manageUserBalance(ops);
    }

    function __get_post(uint256 ret) private view {
        if (!((ret * 95 / 100 < BALWSTETHWETH.getLatest(1)) && 
       (ret * 105 / 100 > BALWSTETHWETH.getLatest(1)))) revert();
    }

    function _get() internal view returns (uint256) {
        uint256 ret = _get_original();
        __get_post(ret);
        return (ret);
    }

    function _wrap_STETH(address addr) private pure returns (uint256) {
        uint256 _addr = uint256(uint160(addr));
        _addr = _addr | (uint96(1 << 0) << 160);
        return _addr;
    }

    function _IChainlinkAggregator_latestRoundData_0_post(address STETH, uint256 v, uint256 g, uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) private view {
        if (!((updatedAt > block.timestamp - 1 days) && (answer > 0))) revert();
    }

    function _dispatch_IChainlinkAggregator_latestRoundData(uint256 addr, uint256 value, uint256 gas) private view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) {
        uint96 specId = uint96(addr >> 160);
        (uint80 _cs_0, int256 _cs_1, uint256 _cs_2, uint256 _cs_3, uint80 _cs_4) = IChainlinkAggregator(address(uint160(addr))).latestRoundData{gas: gas}();
        if ((specId & uint96(1 << 0)) != 0) _IChainlinkAggregator_latestRoundData_0_post(address(uint160(addr)), value, gas, _cs_0, _cs_1, _cs_2, _cs_3, _cs_4);
        return (_cs_0, _cs_1, _cs_2, _cs_3, _cs_4);
    }
}