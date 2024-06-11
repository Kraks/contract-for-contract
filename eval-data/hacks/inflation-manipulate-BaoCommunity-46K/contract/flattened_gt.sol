pragma solidity ^0.5.16;

contract ComptrollerErrorReporter {
    enum Error { NO_ERROR, UNAUTHORIZED, COMPTROLLER_MISMATCH, INSUFFICIENT_SHORTFALL, INSUFFICIENT_LIQUIDITY, INVALID_CLOSE_FACTOR, INVALID_COLLATERAL_FACTOR, INVALID_LIQUIDATION_INCENTIVE, MARKET_NOT_ENTERED, MARKET_NOT_LISTED, MARKET_ALREADY_LISTED, MATH_ERROR, NONZERO_BORROW_BALANCE, PRICE_ERROR, REJECTION, SNAPSHOT_ERROR, TOO_MANY_ASSETS, TOO_MUCH_REPAY }

    enum FailureInfo { ACCEPT_ADMIN_PENDING_ADMIN_CHECK, ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK, EXIT_MARKET_BALANCE_OWED, EXIT_MARKET_REJECTION, SET_CLOSE_FACTOR_OWNER_CHECK, SET_CLOSE_FACTOR_VALIDATION, SET_COLLATERAL_FACTOR_OWNER_CHECK, SET_COLLATERAL_FACTOR_NO_EXISTS, SET_COLLATERAL_FACTOR_VALIDATION, SET_COLLATERAL_FACTOR_WITHOUT_PRICE, SET_IMPLEMENTATION_OWNER_CHECK, SET_LIQUIDATION_INCENTIVE_OWNER_CHECK, SET_LIQUIDATION_INCENTIVE_VALIDATION, SET_MAX_ASSETS_OWNER_CHECK, SET_PENDING_ADMIN_OWNER_CHECK, SET_PENDING_IMPLEMENTATION_OWNER_CHECK, SET_PRICE_ORACLE_OWNER_CHECK, SUPPORT_MARKET_EXISTS, SUPPORT_MARKET_OWNER_CHECK, SET_PAUSE_GUARDIAN_OWNER_CHECK }

    event Failure(uint error, uint info, uint detail);

    function fail(Error err, FailureInfo info) internal returns (uint) {
        emit Failure(uint(err), uint(info), 0);
        return uint(err);
    }

    function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
        emit Failure(uint(err), uint(info), opaqueError);
        return uint(err);
    }
}

contract TokenErrorReporter {
    enum Error { NO_ERROR, UNAUTHORIZED, BAD_INPUT, COMPTROLLER_REJECTION, COMPTROLLER_CALCULATION_ERROR, INTEREST_RATE_MODEL_ERROR, INVALID_ACCOUNT_PAIR, INVALID_CLOSE_AMOUNT_REQUESTED, INVALID_COLLATERAL_FACTOR, MATH_ERROR, MARKET_NOT_FRESH, MARKET_NOT_LISTED, TOKEN_INSUFFICIENT_ALLOWANCE, TOKEN_INSUFFICIENT_BALANCE, TOKEN_INSUFFICIENT_CASH, TOKEN_TRANSFER_IN_FAILED, TOKEN_TRANSFER_OUT_FAILED }

    enum FailureInfo { ACCEPT_ADMIN_PENDING_ADMIN_CHECK, ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED, ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, BORROW_ACCRUE_INTEREST_FAILED, BORROW_CASH_NOT_AVAILABLE, BORROW_FRESHNESS_CHECK, BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, BORROW_MARKET_NOT_LISTED, BORROW_COMPTROLLER_REJECTION, LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED, LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED, LIQUIDATE_COLLATERAL_FRESHNESS_CHECK, LIQUIDATE_COMPTROLLER_REJECTION, LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED, LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX, LIQUIDATE_CLOSE_AMOUNT_IS_ZERO, LIQUIDATE_FRESHNESS_CHECK, LIQUIDATE_LIQUIDATOR_IS_BORROWER, LIQUIDATE_REPAY_BORROW_FRESH_FAILED, LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER, LIQUIDATE_SEIZE_TOO_MUCH, MINT_ACCRUE_INTEREST_FAILED, MINT_COMPTROLLER_REJECTION, MINT_EXCHANGE_CALCULATION_FAILED, MINT_EXCHANGE_RATE_READ_FAILED, MINT_FRESHNESS_CHECK, MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, MINT_TRANSFER_IN_FAILED, MINT_TRANSFER_IN_NOT_POSSIBLE, REDEEM_ACCRUE_INTEREST_FAILED, REDEEM_COMPTROLLER_REJECTION, REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, REDEEM_EXCHANGE_RATE_READ_FAILED, REDEEM_FRESHNESS_CHECK, REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, REDEEM_TRANSFER_OUT_NOT_POSSIBLE, REDUCE_RESERVES_ACCRUE_INTEREST_FAILED, REDUCE_RESERVES_ADMIN_CHECK, REDUCE_RESERVES_CASH_NOT_AVAILABLE, REDUCE_RESERVES_FRESH_CHECK, REDUCE_RESERVES_VALIDATION, REPAY_BEHALF_ACCRUE_INTEREST_FAILED, REPAY_BORROW_ACCRUE_INTEREST_FAILED, REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, REPAY_BORROW_COMPTROLLER_REJECTION, REPAY_BORROW_FRESHNESS_CHECK, REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE, SET_COLLATERAL_FACTOR_OWNER_CHECK, SET_COLLATERAL_FACTOR_VALIDATION, SET_COMPTROLLER_OWNER_CHECK, SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED, SET_INTEREST_RATE_MODEL_FRESH_CHECK, SET_INTEREST_RATE_MODEL_OWNER_CHECK, SET_MAX_ASSETS_OWNER_CHECK, SET_ORACLE_MARKET_NOT_LISTED, SET_PENDING_ADMIN_OWNER_CHECK, SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED, SET_RESERVE_FACTOR_ADMIN_CHECK, SET_RESERVE_FACTOR_FRESH_CHECK, SET_RESERVE_FACTOR_BOUNDS_CHECK, TRANSFER_COMPTROLLER_REJECTION, TRANSFER_NOT_ALLOWED, TRANSFER_NOT_ENOUGH, TRANSFER_TOO_MUCH, ADD_RESERVES_ACCRUE_INTEREST_FAILED, ADD_RESERVES_FRESH_CHECK, ADD_RESERVES_TRANSFER_IN_NOT_POSSIBLE }

    event Failure(uint error, uint info, uint detail);

    function fail(Error err, FailureInfo info) internal returns (uint) {
        emit Failure(uint(err), uint(info), 0);
        return uint(err);
    }

    function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
        emit Failure(uint(err), uint(info), opaqueError);
        return uint(err);
    }
}

/// @notice Arithmetic library with operations for fixed-point numbers.
///  @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/FixedPointMathLib.sol)
library FixedPointMathLib {
    uint256 internal constant YAD = 1e8;
    uint256 internal constant WAD = 1e18;
    uint256 internal constant RAY = 1e27;
    uint256 internal constant RAD = 1e45;

    function fmul(uint256 x, uint256 y, uint256 baseUnit) internal pure returns (uint256 z) {
        assembly {
    z := mul(x, y)
    if iszero(or(iszero(x), eq(div(z, x), y))) { revert(0, 0) }
    z := div(z, baseUnit)
}
    }

    function fdiv(uint256 x, uint256 y, uint256 baseUnit) internal pure returns (uint256 z) {
        assembly {
    z := mul(x, baseUnit)
    if iszero(and(iszero(iszero(y)), or(iszero(x), eq(div(z, x), baseUnit)))) { revert(0, 0) }
    z := div(z, y)
}
    }

    function fpow(uint256 x, uint256 n, uint256 baseUnit) internal pure returns (uint256 z) {
        assembly {
    switch x
    case 0 {
        switch n
        case 0 { z := baseUnit }
        default { z := 0 }
    }
    default {
        switch mod(n, 2)
        case 0 { z := baseUnit }
        default { z := x }
        let half := shr(1, baseUnit)
        for { n := shr(1, n) } n { n := shr(1, n) }
        {
            if shr(128, x) { revert(0, 0) }
            let xx := mul(x, x)
            let xxRound := add(xx, half)
            if lt(xxRound, xx) { revert(0, 0) }
            x := div(xxRound, baseUnit)
            if mod(n, 2)
            {
                let zx := mul(z, x)
                if iszero(eq(div(zx, x), z))
                {
                    if iszero(iszero(x)) { revert(0, 0) }
                }
                let zxRound := add(zx, half)
                if lt(zxRound, zx) { revert(0, 0) }
                z := div(zxRound, baseUnit)
            }
        }
    }
}
    }

    function sqrt(uint256 x) internal pure returns (uint256 z) {
        assembly {
    z := 1
    let y := x
    if iszero(lt(y, 0x100000000000000000000000000000000))
    {
        y := shr(128, y)
        z := shl(64, z)
    }
    if iszero(lt(y, 0x10000000000000000))
    {
        y := shr(64, y)
        z := shl(32, z)
    }
    if iszero(lt(y, 0x100000000))
    {
        y := shr(32, y)
        z := shl(16, z)
    }
    if iszero(lt(y, 0x10000))
    {
        y := shr(16, y)
        z := shl(8, z)
    }
    if iszero(lt(y, 0x100))
    {
        y := shr(8, y)
        z := shl(4, z)
    }
    if iszero(lt(y, 0x10))
    {
        y := shr(4, y)
        z := shl(2, z)
    }
    if iszero(lt(y, 0x8)) { z := shl(1, z) }
    z := shr(1, add(z, div(x, z)))
    z := shr(1, add(z, div(x, z)))
    z := shr(1, add(z, div(x, z)))
    z := shr(1, add(z, div(x, z)))
    z := shr(1, add(z, div(x, z)))
    z := shr(1, add(z, div(x, z)))
    z := shr(1, add(z, div(x, z)))
    let zRoundDown := div(x, z)
    if lt(zRoundDown, z) { z := zRoundDown }
}
    }
}

interface EIP20NonStandardInterface {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /// @notice Get the total number of tokens in circulation
    /// @return The supply of tokens
    function totalSupply() external view returns (uint256);

    /// @notice Gets the balance of the specified address
    /// @param owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address owner) external view returns (uint256 balance);

    /// @notice Transfer `amount` tokens from `msg.sender` to `dst`
    /// @param dst The address of the destination account
    /// @param amount The number of tokens to transfer
    function transfer(address dst, uint256 amount) external;

    /// @notice Transfer `amount` tokens from `src` to `dst`
    /// @param src The address of the source account
    /// @param dst The address of the destination account
    /// @param amount The number of tokens to transfer
    function transferFrom(address src, address dst, uint256 amount) external;

    function approve(address spender, uint256 amount) external returns (bool success);

    /// @notice Get the current allowance from `owner` for `spender`
    /// @param owner The address of the account which owns the tokens to be spent
    /// @param spender The address of the account which may transfer tokens
    /// @return The number of tokens allowed to be spent
    function allowance(address owner, address spender) external view returns (uint256 remaining);
}

/// @title ERC 20 Token Standard Interface
///  https://eips.ethereum.org/EIPS/eip-20
interface EIP20Interface {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    /// @notice Get the total number of tokens in circulation
    /// @return The supply of tokens
    function totalSupply() external view returns (uint256);

    /// @notice Gets the balance of the specified address
    /// @param owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address owner) external view returns (uint256 balance);

    /// @notice Transfer `amount` tokens from `msg.sender` to `dst`
    /// @param dst The address of the destination account
    /// @param amount The number of tokens to transfer
    /// @return Whether or not the transfer succeeded
    function transfer(address dst, uint256 amount) external returns (bool success);

    /// @notice Transfer `amount` tokens from `src` to `dst`
    /// @param src The address of the source account
    /// @param dst The address of the destination account
    /// @param amount The number of tokens to transfer
    /// @return Whether or not the transfer succeeded
    function transferFrom(address src, address dst, uint256 amount) external returns (bool success);

    function approve(address spender, uint256 amount) external returns (bool success);

    /// @notice Get the current allowance from `owner` for `spender`
    /// @param owner The address of the account which owns the tokens to be spent
    /// @param spender The address of the account which may transfer tokens
    /// @return The number of tokens allowed to be spent (-1 means infinite)
    function allowance(address owner, address spender) external view returns (uint256 remaining);
}

/// @title Exponential module for storing fixed-precision decimals
/// @author Compound
/// @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
///         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
///         `Exp({mantissa: 5100000000000000000})`.
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

    function truncate(Exp memory exp) internal pure returns (uint) {
        return exp.mantissa / expScale;
    }

    function mul_ScalarTruncate(Exp memory a, uint scalar) internal pure returns (uint) {
        Exp memory product = mul_(a, scalar);
        return truncate(product);
    }

    function mul_ScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) internal pure returns (uint) {
        Exp memory product = mul_(a, scalar);
        return add_(truncate(product), addend);
    }

    function lessThanExp(Exp memory left, Exp memory right) internal pure returns (bool) {
        return left.mantissa < right.mantissa;
    }

    function lessThanOrEqualExp(Exp memory left, Exp memory right) internal pure returns (bool) {
        return left.mantissa <= right.mantissa;
    }

    function greaterThanExp(Exp memory left, Exp memory right) internal pure returns (bool) {
        return left.mantissa > right.mantissa;
    }

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
        return add_(a, b, "addition overflow");
    }

    function add_(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, errorMessage);
        return c;
    }

    function sub_(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
        return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
    }

    function sub_(Double memory a, Double memory b) internal pure returns (Double memory) {
        return Double({mantissa: sub_(a.mantissa, b.mantissa)});
    }

    function sub_(uint a, uint b) internal pure returns (uint) {
        return sub_(a, b, "subtraction underflow");
    }

    function sub_(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
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
        return mul_(a, b, "multiplication overflow");
    }

    function mul_(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        if ((a == 0) || (b == 0)) {
            return 0;
        }
        uint c = a * b;
        require((c / a) == b, errorMessage);
        return c;
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
        return div_(a, b, "divide by zero");
    }

    function div_(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function fraction(uint a, uint b) internal pure returns (Double memory) {
        return Double({mantissa: div_(mul_(a, doubleScale), b)});
    }
}

/// @title Careful Math
/// @author Compound
/// @notice Derived from OpenZeppelin's SafeMath library
///         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
contract CarefulMath {
    enum MathError { NO_ERROR, DIVISION_BY_ZERO, INTEGER_OVERFLOW, INTEGER_UNDERFLOW }

    function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
        if (a == 0) {
            return (MathError.NO_ERROR, 0);
        }
        uint c = a * b;
        if ((c / a) != b) {
            return (MathError.INTEGER_OVERFLOW, 0);
        } else {
            return (MathError.NO_ERROR, c);
        }
    }

    function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
        if (b == 0) {
            return (MathError.DIVISION_BY_ZERO, 0);
        }
        return (MathError.NO_ERROR, a / b);
    }

    function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
        if (b <= a) {
            return (MathError.NO_ERROR, a - b);
        } else {
            return (MathError.INTEGER_UNDERFLOW, 0);
        }
    }

    function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
        uint c = a + b;
        if (c >= a) {
            return (MathError.NO_ERROR, c);
        } else {
            return (MathError.INTEGER_OVERFLOW, 0);
        }
    }

    function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
        (MathError err0, uint sum) = addUInt(a, b);
        if (err0 != MathError.NO_ERROR) {
            return (err0, 0);
        }
        return subUInt(sum, c);
    }
}

contract Exponential is CarefulMath, ExponentialNoError {
    function getExp(uint num, uint denom) internal pure returns (MathError, Exp memory) {
        (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }
        (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
        if (err1 != MathError.NO_ERROR) {
            return (err1, Exp({mantissa: 0}));
        }
        return (MathError.NO_ERROR, Exp({mantissa: rational}));
    }

    function addExp(Exp memory a, Exp memory b) internal pure returns (MathError, Exp memory) {
        (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
        return (error, Exp({mantissa: result}));
    }

    function subExp(Exp memory a, Exp memory b) internal pure returns (MathError, Exp memory) {
        (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
        return (error, Exp({mantissa: result}));
    }

    function mulScalar(Exp memory a, uint scalar) internal pure returns (MathError, Exp memory) {
        (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }
        return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
    }

    function mulScalarTruncate(Exp memory a, uint scalar) internal pure returns (MathError, uint) {
        (MathError err, Exp memory product) = mulScalar(a, scalar);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }
        return (MathError.NO_ERROR, truncate(product));
    }

    function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) internal pure returns (MathError, uint) {
        (MathError err, Exp memory product) = mulScalar(a, scalar);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }
        return addUInt(truncate(product), addend);
    }

    function divScalar(Exp memory a, uint scalar) internal pure returns (MathError, Exp memory) {
        (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }
        return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
    }

    function divScalarByExp(uint scalar, Exp memory divisor) internal pure returns (MathError, Exp memory) {
        (MathError err0, uint numerator) = mulUInt(expScale, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }
        return getExp(numerator, divisor.mantissa);
    }

    function divScalarByExpTruncate(uint scalar, Exp memory divisor) internal pure returns (MathError, uint) {
        (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }
        return (MathError.NO_ERROR, truncate(fraction));
    }

    function mulExp(Exp memory a, Exp memory b) internal pure returns (MathError, Exp memory) {
        (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }
        (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
        if (err1 != MathError.NO_ERROR) {
            return (err1, Exp({mantissa: 0}));
        }
        (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
        assert(err2 == MathError.NO_ERROR);
        return (MathError.NO_ERROR, Exp({mantissa: product}));
    }

    function mulExp(uint a, uint b) internal pure returns (MathError, Exp memory) {
        return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
    }

    function mulExp3(Exp memory a, Exp memory b, Exp memory c) internal pure returns (MathError, Exp memory) {
        (MathError err, Exp memory ab) = mulExp(a, b);
        if (err != MathError.NO_ERROR) {
            return (err, ab);
        }
        return mulExp(ab, c);
    }

    function divExp(Exp memory a, Exp memory b) internal pure returns (MathError, Exp memory) {
        return getExp(a.mantissa, b.mantissa);
    }
}

/// @title Compound's InterestRateModel Interface
/// @author Compound
contract InterestRateModel {
    bool public constant isInterestRateModel = true;

    /// @notice Calculates the current borrow interest rate per block
    /// @param cash The total amount of cash the market has
    /// @param borrows The total amount of borrows the market has outstanding
    /// @param reserves The total amount of reserves the market has
    /// @return The borrow rate per block (as a percentage, and scaled by 1e18)
    function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);

    /// @notice Calculates the current supply interest rate per block
    /// @param cash The total amount of cash the market has
    /// @param borrows The total amount of borrows the market has outstanding
    /// @param reserves The total amount of reserves the market has
    /// @param reserveFactorMantissa The current reserve factor the market has
    /// @return The supply rate per block (as a percentage, and scaled by 1e18)
    function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
}

contract CTokenStorage {
    struct BorrowSnapshot {
        uint principal;
        uint interestIndex;
    }

    bool internal _notEntered;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint internal constant borrowRateMaxMantissa = 0.0005e16;
    uint internal constant reserveFactorMaxMantissa = 1e18;
    address payable public admin;
    address payable public pendingAdmin;
    ComptrollerInterface public comptroller;
    InterestRateModel public interestRateModel;
    uint internal initialExchangeRateMantissa;
    uint public reserveFactorMantissa;
    uint public accrualBlockNumber;
    uint public borrowIndex;
    uint public totalBorrows;
    uint public totalReserves;
    uint public totalSupply;
    mapping(address => uint) internal accountTokens;
    mapping(address => mapping(address => uint)) internal transferAllowances;
    mapping(address => BorrowSnapshot) internal accountBorrows;
    uint public protocolSeizeShareMantissa = 2.8e16;
}

contract CTokenInterface is CTokenStorage {
    /// @notice Event emitted when interest is accrued
    event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);

    /// @notice Event emitted when tokens are minted
    event Mint(address minter, uint mintAmount, uint mintTokens);

    /// @notice Event emitted when tokens are redeemed
    event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);

    /// @notice Event emitted when underlying is borrowed
    event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);

    /// @notice Event emitted when a borrow is repaid
    event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);

    /// @notice Event emitted when a borrow is liquidated
    event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);

    /// @notice Event emitted when pendingAdmin is changed
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);

    /// @notice Event emitted when pendingAdmin is accepted, which means admin is updated
    event NewAdmin(address oldAdmin, address newAdmin);

    /// @notice Event emitted when comptroller is changed
    event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);

    /// @notice Event emitted when interestRateModel is changed
    event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);

    /// @notice Event emitted when the reserve factor is changed
    event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);

    /// @notice Event emitted when the protocol seize share is changed
    event NewProtocolSeizeShare(uint oldProtocolSeizeShareMantissa, uint newProtocolSeizeShareMantissa);

    /// @notice Event emitted when the reserves are added
    event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);

    /// @notice Event emitted when the reserves are reduced
    event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);

    /// @notice EIP20 Transfer event
    event Transfer(address indexed from, address indexed to, uint amount);

    /// @notice EIP20 Approval event
    event Approval(address indexed owner, address indexed spender, uint amount);

    /// @notice Failure event
    event Failure(uint error, uint info, uint detail);

    bool public constant isCToken = true;

    /// * User Interface **
    function transfer(address dst, uint amount) external returns (bool);

    function transferFrom(address src, address dst, uint amount) external returns (bool);

    function approve(address spender, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);

    function borrowRatePerBlock() external view returns (uint);

    function supplyRatePerBlock() external view returns (uint);

    function totalBorrowsCurrent() external returns (uint);

    function borrowBalanceCurrent(address account) external returns (uint);

    function borrowBalanceStored(address account) public view returns (uint);

    function exchangeRateStored() public view returns (uint);

    function getCash() external view returns (uint);

    function accrueInterest() public returns (uint);

    function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);

    /// * Admin Functions **
    function _setPendingAdmin(address payable newPendingAdmin) external returns (uint);

    function _acceptAdmin() external returns (uint);

    function _setComptroller(ComptrollerInterface newComptroller) public returns (uint);

    function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);

    function _reduceReserves(uint reduceAmount) external returns (uint);

    function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint);

    function _setProtocolSeizeShare(uint newProtocolSeizeShareMantissa) external returns (uint);
}

contract CErc20Storage {
    address public underlying;
}

contract CErc20Interface is CErc20Storage {
    /// * User Interface **
    function mint(uint mintAmount, bool enterMarket) external returns (uint);

    function redeem(uint redeemTokens) external returns (uint);

    function redeemUnderlying(uint redeemAmount) external returns (uint);

    function borrow(uint borrowAmount) external returns (uint);

    function repayBorrow(uint repayAmount) external returns (uint);

    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);

    function liquidateBorrow(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) external returns (uint);

    /// * Admin Functions **
    function _addReserves(uint addAmount) external returns (uint);
}

contract CDelegationStorage {
    address public implementation;
}

contract CDelegatorInterface is CDelegationStorage {
    /// @notice Emitted when implementation is changed
    event NewImplementation(address oldImplementation, address newImplementation);

    /// @notice Called by the admin to update the implementation of the delegator
    /// @param implementation_ The address of the new implementation for delegation
    /// @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
    /// @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
    function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
}

contract CDelegateInterface is CDelegationStorage {
    function _becomeImplementation(bytes memory data) public;

    /// @notice Called by the delegator on a delegate to forfeit its responsibility
    function _resignImplementation() public;
}

contract ComptrollerInterface {
    bool public constant isComptroller = true;

    /// * Assets You Are In **
    function enterMarkets(address[] calldata cTokens, address borrower) external returns (uint[] memory);

    function exitMarket(address cToken) external returns (uint);

    /// * Policy Hooks **
    function mintAllowed(address cToken, address minter, uint mintAmount) external returns (uint);

    function mintVerify(address cToken, address minter, uint mintAmount, uint mintTokens) external;

    function redeemAllowed(address cToken, address redeemer, uint redeemTokens) external returns (uint);

    function redeemVerify(address cToken, address redeemer, uint redeemAmount, uint redeemTokens) external;

    function borrowAllowed(address cToken, address borrower, uint borrowAmount) external returns (uint);

    function borrowVerify(address cToken, address borrower, uint borrowAmount) external;

    function repayBorrowAllowed(address cToken, address payer, address borrower, uint repayAmount) external returns (uint);

    function repayBorrowVerify(address cToken, address payer, address borrower, uint repayAmount, uint borrowerIndex) external;

    function liquidateBorrowAllowed(address cTokenBorrowed, address cTokenCollateral, address liquidator, address borrower, uint repayAmount) external returns (uint);

    function liquidateBorrowVerify(address cTokenBorrowed, address cTokenCollateral, address liquidator, address borrower, uint repayAmount, uint seizeTokens) external;

    function seizeAllowed(address cTokenCollateral, address cTokenBorrowed, address liquidator, address borrower, uint seizeTokens) external returns (uint);

    function seizeVerify(address cTokenCollateral, address cTokenBorrowed, address liquidator, address borrower, uint seizeTokens) external;

    function transferAllowed(address cToken, address src, address dst, uint transferTokens) external returns (uint);

    function transferVerify(address cToken, address src, address dst, uint transferTokens) external;

    /// * Liquidity/Liquidation Calculations **
    function liquidateCalculateSeizeTokens(address cTokenBorrowed, address cTokenCollateral, uint repayAmount) external view returns (uint, uint);
}

/// @title Compound's CToken Contract
/// @notice Abstract base for CTokens
/// @author Compound
contract CToken is CTokenInterface, Exponential, TokenErrorReporter {
    using FixedPointMathLib for uint256;

    struct MintLocalVars {
        Error err;
        MathError mathErr;
        uint exchangeRateMantissa;
        uint mintTokens;
        uint totalSupplyNew;
        uint accountTokensNew;
        uint actualMintAmount;
    }

    struct RedeemLocalVars {
        Error err;
        MathError mathErr;
        uint exchangeRateMantissa;
        uint redeemTokens;
        uint redeemAmount;
        uint totalSupplyNew;
        uint accountTokensNew;
    }

    struct BorrowLocalVars {
        MathError mathErr;
        uint accountBorrows;
        uint accountBorrowsNew;
        uint totalBorrowsNew;
    }

    struct RepayBorrowLocalVars {
        Error err;
        MathError mathErr;
        uint repayAmount;
        uint borrowerIndex;
        uint accountBorrows;
        uint accountBorrowsNew;
        uint totalBorrowsNew;
        uint actualRepayAmount;
    }

    struct SeizeInternalLocalVars {
        MathError mathErr;
        uint borrowerTokensNew;
        uint liquidatorTokensNew;
        uint liquidatorSeizeTokens;
        uint protocolSeizeTokens;
        uint protocolSeizeAmount;
        uint exchangeRateMantissa;
        uint totalReservesNew;
        uint totalSupplyNew;
    }

    /// * Reentrancy Guard **
    modifier nonReentrant() {
        require(_notEntered, "re-entered");
        _notEntered = false;
        _;
        _notEntered = true;
    }

    /// @notice Initialize the money market
    /// @param comptroller_ The address of the Comptroller
    /// @param interestRateModel_ The address of the interest rate model
    /// @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
    /// @param name_ EIP-20 name of this token
    /// @param symbol_ EIP-20 symbol of this token
    /// @param decimals_ EIP-20 decimal precision of this token
    function initialize(ComptrollerInterface comptroller_, InterestRateModel interestRateModel_, uint initialExchangeRateMantissa_, string memory name_, string memory symbol_, uint8 decimals_) public {
        require(msg.sender == admin, "only admin may initialize the market");
        require((accrualBlockNumber == 0) && (borrowIndex == 0), "market may only be initialized once");
        initialExchangeRateMantissa = initialExchangeRateMantissa_;
        require(initialExchangeRateMantissa > 0, "initial exchange rate must be greater than zero.");
        uint err = _setComptroller(comptroller_);
        require(err == uint(Error.NO_ERROR), "setting comptroller failed");
        accrualBlockNumber = getBlockNumber();
        borrowIndex = mantissaOne;
        err = _setInterestRateModelFresh(interestRateModel_);
        require(err == uint(Error.NO_ERROR), "setting interest rate model failed");
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
        _notEntered = true;
    }

    function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
        uint allowed = comptroller.transferAllowed(address(this), src, dst, tokens);
        if (allowed != 0) {
            return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.TRANSFER_COMPTROLLER_REJECTION, allowed);
        }
        if (src == dst) {
            return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
        }
        uint startingAllowance = 0;
        if (spender == src) {
            startingAllowance = uint(-1);
        } else {
            startingAllowance = transferAllowances[src][spender];
        }
        MathError mathErr;
        uint allowanceNew;
        uint srcTokensNew;
        uint dstTokensNew;
        (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
        if (mathErr != MathError.NO_ERROR) {
            return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
        }
        (mathErr, srcTokensNew) = subUInt(accountTokens[src], tokens);
        if (mathErr != MathError.NO_ERROR) {
            return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
        }
        (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
        if (mathErr != MathError.NO_ERROR) {
            return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
        }
        accountTokens[src] = srcTokensNew;
        accountTokens[dst] = dstTokensNew;
        if (startingAllowance != uint(-1)) {
            transferAllowances[src][spender] = allowanceNew;
        }
        emit Transfer(src, dst, tokens);
        comptroller.transferVerify(address(this), src, dst, tokens);
        return uint(Error.NO_ERROR);
    }

    /// @notice Transfer `amount` tokens from `msg.sender` to `dst`
    /// @param dst The address of the destination account
    /// @param amount The number of tokens to transfer
    /// @return Whether or not the transfer succeeded
    function transfer(address dst, uint256 amount) external nonReentrant() returns (bool) {
        return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
    }

    /// @notice Transfer `amount` tokens from `src` to `dst`
    /// @param src The address of the source account
    /// @param dst The address of the destination account
    /// @param amount The number of tokens to transfer
    /// @return Whether or not the transfer succeeded
    function transferFrom(address src, address dst, uint256 amount) external nonReentrant() returns (bool) {
        return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        address src = msg.sender;
        transferAllowances[src][spender] = amount;
        emit Approval(src, spender, amount);
        return true;
    }

    /// @notice Get the current allowance from `owner` for `spender`
    /// @param owner The address of the account which owns the tokens to be spent
    /// @param spender The address of the account which may transfer tokens
    /// @return The number of tokens allowed to be spent (-1 means infinite)
    function allowance(address owner, address spender) external view returns (uint256) {
        return transferAllowances[owner][spender];
    }

    /// @notice Get the token balance of the `owner`
    /// @param owner The address of the account to query
    /// @return The number of tokens owned by `owner`
    function balanceOf(address owner) external view returns (uint256) {
        return accountTokens[owner];
    }

    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
        uint cTokenBalance = accountTokens[account];
        uint borrowBalance;
        uint exchangeRateMantissa;
        MathError mErr;
        (mErr, borrowBalance) = borrowBalanceStoredInternal(account);
        if (mErr != MathError.NO_ERROR) {
            return (uint(Error.MATH_ERROR), 0, 0, 0);
        }
        (mErr, exchangeRateMantissa) = exchangeRateStoredInternal();
        if (mErr != MathError.NO_ERROR) {
            return (uint(Error.MATH_ERROR), 0, 0, 0);
        }
        return (uint(Error.NO_ERROR), cTokenBalance, borrowBalance, exchangeRateMantissa);
    }

    function getBlockNumber() internal view returns (uint) {
        return block.number;
    }

    /// @notice Returns the current per-block borrow interest rate for this cToken
    /// @return The borrow interest rate per block, scaled by 1e18
    function borrowRatePerBlock() external view returns (uint) {
        return interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
    }

    /// @notice Returns the current per-block supply interest rate for this cToken
    /// @return The supply interest rate per block, scaled by 1e18
    function supplyRatePerBlock() external view returns (uint) {
        return interestRateModel.getSupplyRate(getCashPrior(), totalBorrows, totalReserves, reserveFactorMantissa);
    }

    /// @notice Returns the current total borrows plus accrued interest
    /// @return The total borrows with interest
    function totalBorrowsCurrent() external nonReentrant() returns (uint) {
        require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
        return totalBorrows;
    }

    /// @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
    /// @param account The address whose balance should be calculated after updating borrowIndex
    /// @return The calculated balance
    function borrowBalanceCurrent(address account) external nonReentrant() returns (uint) {
        require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
        return borrowBalanceStored(account);
    }

    /// @notice Return the borrow balance of account based on stored data
    /// @param account The address whose balance should be calculated
    /// @return The calculated balance
    function borrowBalanceStored(address account) public view returns (uint) {
        (MathError err, uint result) = borrowBalanceStoredInternal(account);
        require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
        return result;
    }

    /// @notice Return the borrow balance of account based on stored data
    /// @param account The address whose balance should be calculated
    /// @return (error code, the calculated balance or 0 if error code is non-zero)
    function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
        MathError mathErr;
        uint principalTimesIndex;
        uint result;
        BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
        if (borrowSnapshot.principal == 0) {
            return (MathError.NO_ERROR, 0);
        }
        (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
        if (mathErr != MathError.NO_ERROR) {
            return (mathErr, 0);
        }
        (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
        if (mathErr != MathError.NO_ERROR) {
            return (mathErr, 0);
        }
        return (MathError.NO_ERROR, result);
    }

    function exchangeRateStored() public view returns (uint) {
        (MathError err, uint result) = exchangeRateStoredInternal();
        require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
        return result;
    }

    function exchangeRateStoredInternal() internal view returns (MathError, uint) {
        uint _totalSupply = totalSupply;
        if (_totalSupply == 0) {
            return (MathError.NO_ERROR, initialExchangeRateMantissa);
        } else {
            uint totalCash = getCashPrior();
            uint cashPlusBorrowsMinusReserves;
            Exp memory exchangeRate;
            MathError mathErr;
            (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
            if (mathErr != MathError.NO_ERROR) {
                return (mathErr, 0);
            }
            (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, _totalSupply);
            if (mathErr != MathError.NO_ERROR) {
                return (mathErr, 0);
            }
            return (MathError.NO_ERROR, exchangeRate.mantissa);
        }
    }

    /// @notice Get cash balance of this cToken in the underlying asset
    /// @return The quantity of underlying asset owned by this contract
    function getCash() external view returns (uint) {
        return getCashPrior();
    }

    function accrueInterest() public returns (uint) {
        uint currentBlockNumber = getBlockNumber();
        uint accrualBlockNumberPrior = accrualBlockNumber;
        if (accrualBlockNumberPrior == currentBlockNumber) {
            return uint(Error.NO_ERROR);
        }
        uint cashPrior = getCashPrior();
        uint borrowsPrior = totalBorrows;
        uint reservesPrior = totalReserves;
        uint borrowIndexPrior = borrowIndex;
        uint borrowRateMantissa = interestRateModel.getBorrowRate(cashPrior, borrowsPrior, reservesPrior);
        require(borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
        (MathError mathErr, uint blockDelta) = subUInt(currentBlockNumber, accrualBlockNumberPrior);
        require(mathErr == MathError.NO_ERROR, "could not calculate block delta");
        Exp memory simpleInterestFactor;
        uint interestAccumulated;
        uint totalBorrowsNew;
        uint totalReservesNew;
        uint borrowIndexNew;
        (mathErr, simpleInterestFactor) = mulScalar(Exp({mantissa: borrowRateMantissa}), blockDelta);
        if (mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(mathErr));
        }
        (mathErr, interestAccumulated) = mulScalarTruncate(simpleInterestFactor, borrowsPrior);
        if (mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(mathErr));
        }
        (mathErr, totalBorrowsNew) = addUInt(interestAccumulated, borrowsPrior);
        if (mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(mathErr));
        }
        (mathErr, totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), interestAccumulated, reservesPrior);
        if (mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(mathErr));
        }
        (mathErr, borrowIndexNew) = mulScalarTruncateAddUInt(simpleInterestFactor, borrowIndexPrior, borrowIndexPrior);
        if (mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(mathErr));
        }
        accrualBlockNumber = currentBlockNumber;
        borrowIndex = borrowIndexNew;
        totalBorrows = totalBorrowsNew;
        totalReserves = totalReservesNew;
        emit AccrueInterest(cashPrior, interestAccumulated, borrowIndexNew, totalBorrowsNew);
        return uint(Error.NO_ERROR);
    }

    function mintInternal(uint mintAmount) internal nonReentrant() returns (uint, uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return (fail(Error(error), FailureInfo.MINT_ACCRUE_INTEREST_FAILED), 0);
        }
        return mintFresh(msg.sender, mintAmount);
    }

    function mintFresh(address minter, uint mintAmount) internal returns (uint, uint) {
        uint allowed = comptroller.mintAllowed(address(this), minter, mintAmount);
        if (allowed != 0) {
            return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.MINT_COMPTROLLER_REJECTION, allowed), 0);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            return (fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK), 0);
        }
        MintLocalVars memory vars;
        (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
        if (vars.mathErr != MathError.NO_ERROR) {
            return (failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr)), 0);
        }
        vars.actualMintAmount = doTransferIn(minter, mintAmount);
        (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
        require(vars.mathErr == MathError.NO_ERROR, "MINT_EXCHANGE_CALCULATION_FAILED");
        (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
        require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED");
        (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
        require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED");
        totalSupply = vars.totalSupplyNew;
        accountTokens[minter] = vars.accountTokensNew;
        emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
        emit Transfer(address(this), minter, vars.mintTokens);
        comptroller.mintVerify(address(this), minter, vars.actualMintAmount, vars.mintTokens);
        return (uint(Error.NO_ERROR), vars.actualMintAmount);
    }

    /// @dev
    ///  {redeemInternal(redeemTokens) returns (error)
    ///      requires {accrueInterest() == uint(Error.NO_ERROR)}
    ///      ensures {totalSupply > 1000}}
    function redeemInternal_original(uint redeemTokens) private nonReentrant() returns (uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
        }
        return redeemFresh(msg.sender, redeemTokens, 0);
    }

    /// @dev
    ///  {redeemUnderlyingInternal(redeemTokens) returns (error)
    ///      requires {accrueInterest() == uint(Error.NO_ERROR)}
    ///      ensures {totalSupply > 1000}}
    function redeemUnderlyingInternal_original(uint redeemAmount) private nonReentrant() returns (uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
        }
        return redeemFresh(msg.sender, 0, redeemAmount);
    }

    function redeemFresh(address payable redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
        require((redeemTokensIn == 0) || (redeemAmountIn == 0), "one of redeemTokensIn or redeemAmountIn must be zero");
        RedeemLocalVars memory vars;
        (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
        if (vars.mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
        }
        if (redeemTokensIn > 0) {
            vars.redeemTokens = redeemTokensIn;
            (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
            if (vars.mathErr != MathError.NO_ERROR) {
                return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
            }
        } else {
            (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
            if (vars.mathErr != MathError.NO_ERROR) {
                return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
            }
            vars.redeemAmount = redeemAmountIn;
        }
        uint allowed = comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens);
        if (allowed != 0) {
            return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REDEEM_COMPTROLLER_REJECTION, allowed);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
        }
        (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
        if (vars.mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
        }
        (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
        if (vars.mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
        }
        if (getCashPrior() < vars.redeemAmount) {
            return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
        }
        doTransferOut(redeemer, vars.redeemAmount);
        totalSupply = vars.totalSupplyNew;
        accountTokens[redeemer] = vars.accountTokensNew;
        emit Transfer(redeemer, address(this), vars.redeemTokens);
        emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
        comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
        return uint(Error.NO_ERROR);
    }

    /// @notice Sender borrows assets from the protocol to their own address
    /// @param borrowAmount The amount of the underlying asset to borrow
    /// @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function borrowInternal(uint borrowAmount) internal nonReentrant() returns (uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return fail(Error(error), FailureInfo.BORROW_ACCRUE_INTEREST_FAILED);
        }
        return borrowFresh(msg.sender, borrowAmount);
    }

    /// @notice Users borrow assets from the protocol to their own address
    /// @param borrowAmount The amount of the underlying asset to borrow
    /// @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function borrowFresh(address payable borrower, uint borrowAmount) internal returns (uint) {
        uint allowed = comptroller.borrowAllowed(address(this), borrower, borrowAmount);
        if (allowed != 0) {
            return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.BORROW_COMPTROLLER_REJECTION, allowed);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            return fail(Error.MARKET_NOT_FRESH, FailureInfo.BORROW_FRESHNESS_CHECK);
        }
        if (getCashPrior() < borrowAmount) {
            return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
        }
        BorrowLocalVars memory vars;
        (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
        if (vars.mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
        }
        (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, borrowAmount);
        if (vars.mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
        }
        (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, borrowAmount);
        if (vars.mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
        }
        doTransferOut(borrower, borrowAmount);
        accountBorrows[borrower].principal = vars.accountBorrowsNew;
        accountBorrows[borrower].interestIndex = borrowIndex;
        totalBorrows = vars.totalBorrowsNew;
        emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
        comptroller.borrowVerify(address(this), borrower, borrowAmount);
        return uint(Error.NO_ERROR);
    }

    /// @notice Sender repays their own borrow
    /// @param repayAmount The amount to repay
    /// @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
    function repayBorrowInternal(uint repayAmount) internal nonReentrant() returns (uint, uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return (fail(Error(error), FailureInfo.REPAY_BORROW_ACCRUE_INTEREST_FAILED), 0);
        }
        return repayBorrowFresh(msg.sender, msg.sender, repayAmount);
    }

    /// @notice Sender repays a borrow belonging to borrower
    /// @param borrower the account with the debt being payed off
    /// @param repayAmount The amount to repay
    /// @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
    function repayBorrowBehalfInternal(address borrower, uint repayAmount) internal nonReentrant() returns (uint, uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return (fail(Error(error), FailureInfo.REPAY_BEHALF_ACCRUE_INTEREST_FAILED), 0);
        }
        return repayBorrowFresh(msg.sender, borrower, repayAmount);
    }

    /// @notice Borrows are repaid by another user (possibly the borrower).
    /// @param payer the account paying off the borrow
    /// @param borrower the account with the debt being payed off
    /// @param repayAmount the amount of undelrying tokens being returned
    /// @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
    function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint, uint) {
        uint allowed = comptroller.repayBorrowAllowed(address(this), payer, borrower, repayAmount);
        if (allowed != 0) {
            return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REPAY_BORROW_COMPTROLLER_REJECTION, allowed), 0);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            return (fail(Error.MARKET_NOT_FRESH, FailureInfo.REPAY_BORROW_FRESHNESS_CHECK), 0);
        }
        RepayBorrowLocalVars memory vars;
        vars.borrowerIndex = accountBorrows[borrower].interestIndex;
        (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
        if (vars.mathErr != MathError.NO_ERROR) {
            return (failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr)), 0);
        }
        if (repayAmount == uint(-1)) {
            vars.repayAmount = vars.accountBorrows;
        } else {
            vars.repayAmount = repayAmount;
        }
        vars.actualRepayAmount = doTransferIn(payer, vars.repayAmount);
        (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.actualRepayAmount);
        require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED");
        (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.actualRepayAmount);
        require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED");
        accountBorrows[borrower].principal = vars.accountBorrowsNew;
        accountBorrows[borrower].interestIndex = borrowIndex;
        totalBorrows = vars.totalBorrowsNew;
        emit RepayBorrow(payer, borrower, vars.actualRepayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
        comptroller.repayBorrowVerify(address(this), payer, borrower, vars.actualRepayAmount, vars.borrowerIndex);
        return (uint(Error.NO_ERROR), vars.actualRepayAmount);
    }

    /// @notice The sender liquidates the borrowers collateral.
    ///  The collateral seized is transferred to the liquidator.
    /// @param borrower The borrower of this cToken to be liquidated
    /// @param cTokenCollateral The market in which to seize collateral from the borrower
    /// @param repayAmount The amount of the underlying borrowed asset to repay
    /// @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
    function liquidateBorrowInternal(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) internal nonReentrant() returns (uint, uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return (fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED), 0);
        }
        error = cTokenCollateral.accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return (fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED), 0);
        }
        return liquidateBorrowFresh(msg.sender, borrower, repayAmount, cTokenCollateral);
    }

    /// @notice The liquidator liquidates the borrowers collateral.
    ///  The collateral seized is transferred to the liquidator.
    /// @param borrower The borrower of this cToken to be liquidated
    /// @param liquidator The address repaying the borrow and seizing collateral
    /// @param cTokenCollateral The market in which to seize collateral from the borrower
    /// @param repayAmount The amount of the underlying borrowed asset to repay
    /// @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
    function liquidateBorrowFresh(address liquidator, address borrower, uint repayAmount, CTokenInterface cTokenCollateral) internal returns (uint, uint) {
        uint allowed = comptroller.liquidateBorrowAllowed(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount);
        if (allowed != 0) {
            return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_COMPTROLLER_REJECTION, allowed), 0);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            return (fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_FRESHNESS_CHECK), 0);
        }
        if (cTokenCollateral.accrualBlockNumber() != getBlockNumber()) {
            return (fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_COLLATERAL_FRESHNESS_CHECK), 0);
        }
        if (borrower == liquidator) {
            return (fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_LIQUIDATOR_IS_BORROWER), 0);
        }
        if (repayAmount == 0) {
            return (fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_ZERO), 0);
        }
        if (repayAmount == uint(-1)) {
            return (fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX), 0);
        }
        (uint repayBorrowError, uint actualRepayAmount) = repayBorrowFresh(liquidator, borrower, repayAmount);
        if (repayBorrowError != uint(Error.NO_ERROR)) {
            return (fail(Error(repayBorrowError), FailureInfo.LIQUIDATE_REPAY_BORROW_FRESH_FAILED), 0);
        }
        (uint amountSeizeError, uint seizeTokens) = comptroller.liquidateCalculateSeizeTokens(address(this), address(cTokenCollateral), actualRepayAmount);
        require(amountSeizeError == uint(Error.NO_ERROR), "LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED");
        require(cTokenCollateral.balanceOf(borrower) >= seizeTokens, "LIQUIDATE_SEIZE_TOO_MUCH");
        uint seizeError;
        if (address(cTokenCollateral) == address(this)) {
            seizeError = seizeInternal(address(this), liquidator, borrower, seizeTokens);
        } else {
            seizeError = cTokenCollateral.seize(liquidator, borrower, seizeTokens);
        }
        require(seizeError == uint(Error.NO_ERROR), "token seizure failed");
        emit LiquidateBorrow(liquidator, borrower, actualRepayAmount, address(cTokenCollateral), seizeTokens);
        comptroller.liquidateBorrowVerify(address(this), address(cTokenCollateral), liquidator, borrower, actualRepayAmount, seizeTokens);
        return (uint(Error.NO_ERROR), actualRepayAmount);
    }

    function seize(address liquidator, address borrower, uint seizeTokens) external nonReentrant() returns (uint) {
        return seizeInternal(msg.sender, liquidator, borrower, seizeTokens);
    }

    function seizeInternal(address seizerToken, address liquidator, address borrower, uint seizeTokens) internal returns (uint) {
        uint allowed = comptroller.seizeAllowed(address(this), seizerToken, liquidator, borrower, seizeTokens);
        if (allowed != 0) {
            return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, allowed);
        }
        if (borrower == liquidator) {
            return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
        }
        SeizeInternalLocalVars memory vars;
        (vars.mathErr, vars.borrowerTokensNew) = subUInt(accountTokens[borrower], seizeTokens);
        if (vars.mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, uint(vars.mathErr));
        }
        vars.protocolSeizeTokens = mul_(seizeTokens, Exp({mantissa: protocolSeizeShareMantissa}));
        vars.liquidatorSeizeTokens = sub_(seizeTokens, vars.protocolSeizeTokens);
        (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
        require(vars.mathErr == MathError.NO_ERROR, "exchange rate math error");
        vars.protocolSeizeAmount = mul_ScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), vars.protocolSeizeTokens);
        vars.totalReservesNew = add_(totalReserves, vars.protocolSeizeAmount);
        vars.totalSupplyNew = sub_(totalSupply, vars.protocolSeizeTokens);
        (vars.mathErr, vars.liquidatorTokensNew) = addUInt(accountTokens[liquidator], vars.liquidatorSeizeTokens);
        if (vars.mathErr != MathError.NO_ERROR) {
            return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, uint(vars.mathErr));
        }
        totalReserves = vars.totalReservesNew;
        totalSupply = vars.totalSupplyNew;
        accountTokens[borrower] = vars.borrowerTokensNew;
        accountTokens[liquidator] = vars.liquidatorTokensNew;
        emit Transfer(borrower, liquidator, vars.liquidatorSeizeTokens);
        emit Transfer(borrower, address(this), vars.protocolSeizeTokens);
        emit ReservesAdded(address(this), vars.protocolSeizeAmount, vars.totalReservesNew);
        return uint(Error.NO_ERROR);
    }

    /// * Admin Functions **
    function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
        if (msg.sender != admin) {
            return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
        }
        address oldPendingAdmin = pendingAdmin;
        pendingAdmin = newPendingAdmin;
        emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
        return uint(Error.NO_ERROR);
    }

    function _acceptAdmin() external returns (uint) {
        if ((msg.sender != pendingAdmin) || (msg.sender == address(0))) {
            return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
        }
        address oldAdmin = admin;
        address oldPendingAdmin = pendingAdmin;
        admin = pendingAdmin;
        pendingAdmin = address(0);
        emit NewAdmin(oldAdmin, admin);
        emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
        return uint(Error.NO_ERROR);
    }

    function _setComptroller(ComptrollerInterface newComptroller) public returns (uint) {
        if (msg.sender != admin) {
            return fail(Error.UNAUTHORIZED, FailureInfo.SET_COMPTROLLER_OWNER_CHECK);
        }
        ComptrollerInterface oldComptroller = comptroller;
        require(newComptroller.isComptroller(), "marker method returned false");
        comptroller = newComptroller;
        emit NewComptroller(oldComptroller, newComptroller);
        return uint(Error.NO_ERROR);
    }

    function _setProtocolSeizeShare(uint newProtocolSeizeShareMantissa) external returns (uint) {
        require(msg.sender == admin, "Caller is not Admin");
        require(newProtocolSeizeShareMantissa <= 1e18, "Protocol seize share must be < 100%");
        uint oldProtocolSeizeShareMantissa = protocolSeizeShareMantissa;
        protocolSeizeShareMantissa = newProtocolSeizeShareMantissa;
        emit NewProtocolSeizeShare(oldProtocolSeizeShareMantissa, newProtocolSeizeShareMantissa);
        return uint(Error.NO_ERROR);
    }

    function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant() returns (uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
        }
        return _setReserveFactorFresh(newReserveFactorMantissa);
    }

    function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
        if (msg.sender != admin) {
            return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
        }
        if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
            return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
        }
        uint oldReserveFactorMantissa = reserveFactorMantissa;
        reserveFactorMantissa = newReserveFactorMantissa;
        emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
        return uint(Error.NO_ERROR);
    }

    /// @notice Accrues interest and reduces reserves by transferring from msg.sender
    /// @param addAmount Amount of addition to reserves
    /// @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _addReservesInternal(uint addAmount) internal nonReentrant() returns (uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return fail(Error(error), FailureInfo.ADD_RESERVES_ACCRUE_INTEREST_FAILED);
        }
        (error, ) = _addReservesFresh(addAmount);
        return error;
    }

    function _addReservesFresh(uint addAmount) internal returns (uint, uint) {
        uint totalReservesNew;
        uint actualAddAmount;
        if (accrualBlockNumber != getBlockNumber()) {
            return (fail(Error.MARKET_NOT_FRESH, FailureInfo.ADD_RESERVES_FRESH_CHECK), actualAddAmount);
        }
        actualAddAmount = doTransferIn(msg.sender, addAmount);
        totalReservesNew = totalReserves + actualAddAmount;
        require(totalReservesNew >= totalReserves, "add reserves unexpected overflow");
        totalReserves = totalReservesNew;
        emit ReservesAdded(msg.sender, actualAddAmount, totalReservesNew);
        return (uint(Error.NO_ERROR), actualAddAmount);
    }

    /// @notice Accrues interest and reduces reserves by transferring to admin
    /// @param reduceAmount Amount of reduction to reserves
    /// @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _reduceReserves(uint reduceAmount) external nonReentrant() returns (uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
        }
        return _reduceReservesFresh(reduceAmount);
    }

    function _reduceReservesFresh(uint reduceAmount) internal returns (uint) {
        uint totalReservesNew;
        if (msg.sender != admin) {
            return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
        }
        if (getCashPrior() < reduceAmount) {
            return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
        }
        if (reduceAmount > totalReserves) {
            return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
        }
        totalReservesNew = totalReserves - reduceAmount;
        require(totalReservesNew <= totalReserves, "reduce reserves unexpected underflow");
        totalReserves = totalReservesNew;
        doTransferOut(admin, reduceAmount);
        emit ReservesReduced(admin, reduceAmount, totalReservesNew);
        return uint(Error.NO_ERROR);
    }

    function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
        uint error = accrueInterest();
        if (error != uint(Error.NO_ERROR)) {
            return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
        }
        return _setInterestRateModelFresh(newInterestRateModel);
    }

    function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
        InterestRateModel oldInterestRateModel;
        if (msg.sender != admin) {
            return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
        }
        if (accrualBlockNumber != getBlockNumber()) {
            return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
        }
        oldInterestRateModel = interestRateModel;
        require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
        interestRateModel = newInterestRateModel;
        emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
        return uint(Error.NO_ERROR);
    }

    /// * Safe Token **
    function getCashPrior() internal view returns (uint);

    function doTransferIn(address from, uint amount) internal returns (uint);

    function doTransferOut(address payable to, uint amount) internal;

    function _redeemInternal_pre(uint redeemTokens) private {
        if (!(accrueInterest() == uint(Error.NO_ERROR))) revert();
    }

    function _redeemInternal_post(uint redeemTokens, uint error) private {
        if (!(totalSupply > 1000)) revert();
    }

    function redeemInternal(uint redeemTokens) internal returns (uint) {
        _redeemInternal_pre(redeemTokens);
        uint error = redeemInternal_original(redeemTokens);
        _redeemInternal_post(redeemTokens, error);
        return (error);
    }

    function _redeemUnderlyingInternal_pre(uint redeemTokens) private {
        if (!(accrueInterest() == uint(Error.NO_ERROR))) revert();
    }

    function _redeemUnderlyingInternal_post(uint redeemTokens, uint error) private {
        if (!(totalSupply > 1000)) revert();
    }

    function redeemUnderlyingInternal(uint redeemAmount) internal returns (uint) {
        _redeemUnderlyingInternal_pre(redeemAmount);
        uint error = redeemUnderlyingInternal_original(redeemAmount);
        _redeemUnderlyingInternal_post(redeemAmount, error);
        return (error);
    }
}

/// @title Compound's CErc20 Contract
/// @notice CTokens which wrap an EIP-20 underlying
/// @author Compound
contract CErc20 is CToken, CErc20Interface {
    /// @notice Initialize the new money market
    /// @param underlying_ The address of the underlying asset
    /// @param comptroller_ The address of the Comptroller
    /// @param interestRateModel_ The address of the interest rate model
    /// @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
    /// @param name_ ERC-20 name of this token
    /// @param symbol_ ERC-20 symbol of this token
    /// @param decimals_ ERC-20 decimal precision of this token
    function initialize(address underlying_, ComptrollerInterface comptroller_, InterestRateModel interestRateModel_, uint initialExchangeRateMantissa_, string memory name_, string memory symbol_, uint8 decimals_) public {
        super.initialize(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_);
        underlying = underlying_;
        EIP20Interface(underlying).totalSupply();
    }

    /// * User Interface **
    function mint(uint mintAmount, bool enterMarket) external returns (uint) {
        (uint err, ) = mintInternal(mintAmount);
        if ((err == 0) && (enterMarket == true)) {
            address[] memory marketToEnter = new address[](1);
            marketToEnter[0] = address(this);
            comptroller.enterMarkets(marketToEnter, msg.sender);
        }
        return err;
    }

    function redeem(uint redeemTokens) external returns (uint) {
        return redeemInternal(redeemTokens);
    }

    function redeemUnderlying(uint redeemAmount) external returns (uint) {
        return redeemUnderlyingInternal(redeemAmount);
    }

    /// @notice Sender borrows assets from the protocol to their own address
    /// @param borrowAmount The amount of the underlying asset to borrow
    /// @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function borrow(uint borrowAmount) external returns (uint) {
        return borrowInternal(borrowAmount);
    }

    /// @notice Sender repays their own borrow
    /// @param repayAmount The amount to repay
    /// @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function repayBorrow(uint repayAmount) external returns (uint) {
        (uint err, ) = repayBorrowInternal(repayAmount);
        return err;
    }

    /// @notice Sender repays a borrow belonging to borrower
    /// @param borrower the account with the debt being payed off
    /// @param repayAmount The amount to repay
    /// @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
        (uint err, ) = repayBorrowBehalfInternal(borrower, repayAmount);
        return err;
    }

    /// @notice The sender liquidates the borrowers collateral.
    ///  The collateral seized is transferred to the liquidator.
    /// @param borrower The borrower of this cToken to be liquidated
    /// @param repayAmount The amount of the underlying borrowed asset to repay
    /// @param cTokenCollateral The market in which to seize collateral from the borrower
    /// @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function liquidateBorrow(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) external returns (uint) {
        (uint err, ) = liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral);
        return err;
    }

    /// @notice The sender adds to reserves.
    /// @param addAmount The amount fo underlying token to add as reserves
    /// @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
    function _addReserves(uint addAmount) external returns (uint) {
        return _addReservesInternal(addAmount);
    }

    /// @author Modified from transmissions11 (https://github.com/transmissions11/libcompound/blob/main/src/LibCompound.sol)
    /// @return Calculated exchange rate scaled by 1e18
    function exchangeRateCurrent() public view returns (uint) {
        uint256 accrualBlockNumberPrior = accrualBlockNumber;
        if (accrualBlockNumberPrior == block.number) return exchangeRateStored();
        uint256 totalCash = EIP20Interface(underlying).balanceOf(address(this));
        uint256 borrowsPrior = totalBorrows;
        uint256 reservesPrior = totalReserves;
        uint256 borrowRateMantissa = interestRateModel.getBorrowRate(totalCash, borrowsPrior, reservesPrior);
        require(borrowRateMantissa <= 0.0005e16, "RATE_TOO_HIGH");
        uint256 interestAccumulated = (borrowRateMantissa * (block.number - accrualBlockNumberPrior)).fmul(borrowsPrior, 1e18);
        uint256 currentTotalReserves = reserveFactorMantissa.fmul(interestAccumulated, 1e18) + reservesPrior;
        uint256 currentNewTotalBorrows = interestAccumulated + borrowsPrior;
        uint256 currentTotalSupply = totalSupply;
        return (totalSupply == 0) ? initialExchangeRateMantissa : ((totalCash + currentNewTotalBorrows) - currentTotalReserves).fdiv(currentTotalSupply, 1e18);
    }

    /// @notice Get the underlying balance of the `owner`
    /// @author Modified from transmissions11 (https://github.com/transmissions11/libcompound/blob/main/src/LibCompound.sol)
    /// @param owner The address of the account to query
    /// @return The amount of underlying owned by `owner`
    function balanceOfUnderlying(address owner) external view returns (uint) {
        return accountTokens[owner].fmul(exchangeRateCurrent(), 1e18);
    }

    /// * Safe Token **
    function getCashPrior() internal view returns (uint) {
        EIP20Interface token = EIP20Interface(underlying);
        return token.balanceOf(address(this));
    }

    function doTransferIn(address from, uint amount) internal returns (uint) {
        EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
        uint balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
        token.transferFrom(from, address(this), amount);
        bool success;
        assembly {
    switch returndatasize()
    case 0 { success := not(0) }
    case 32 {
        returndatacopy(0, 0, 32)
        success := mload(0)
    }
    default { revert(0, 0) }
}
        require(success, "TOKEN_TRANSFER_IN_FAILED");
        uint balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
        require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
        return balanceAfter - balanceBefore;
    }

    function doTransferOut(address payable to, uint amount) internal {
        EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
        token.transfer(to, amount);
        bool success;
        assembly {
    switch returndatasize()
    case 0 { success := not(0) }
    case 32 {
        returndatacopy(0, 0, 32)
        success := mload(0)
    }
    default { revert(0, 0) }
}
        require(success, "TOKEN_TRANSFER_OUT_FAILED");
    }
}

/// @title Compound's CErc20Delegate Contract
/// @notice CTokens which wrap an EIP-20 underlying and are delegated to
/// @author Compound
contract CErc20Delegate is CErc20, CDelegateInterface {
    /// @notice Construct an empty delegate
    constructor() public {}

    /// @notice Called by the delegator on a delegate to initialize it for duty
    /// @param data The encoded bytes data for any initialization
    function _becomeImplementation(bytes memory data) public {
        data;
        if (false) {
            implementation = address(0);
        }
        require(msg.sender == admin, "only the admin may call _becomeImplementation");
    }

    /// @notice Called by the delegator on a delegate to forfeit its responsibility
    function _resignImplementation() public {
        if (false) {
            implementation = address(0);
        }
        require(msg.sender == admin, "only the admin may call _resignImplementation");
    }

    /// @notice Only used when wanting to change the initial exchange rate without re-deploying the contracts
    /// Will not have an effect after the cERC20 contract is in use
    function _setInitialExchangeRate(uint _newInitialExchangeRateMantissa) external {
        require(msg.sender == admin, "only the admin may call _setInitialExchangeRate");
        initialExchangeRateMantissa = _newInitialExchangeRateMantissa;
    }
}
