pragma solidity ^0.8.0^0.8.6;

///  @dev Contract module that helps prevent reentrant calls to a function.
///  Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
///  available, which can be applied to functions to make sure there are no nested
///  (reentrant) calls to them.
///  Note that because there is a single `nonReentrant` guard, functions marked as
///  `nonReentrant` may not call one another. This can be worked around by making
///  those functions `private`, and then adding `external` `nonReentrant` entry
///  points to them.
///  TIP: If you would like to learn more about reentrancy and alternative ways
///  to protect against it, check out our blog post
///  https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    ///  @dev Prevents a contract from calling itself, directly or indirectly.
    ///  Calling a `nonReentrant` function from another `nonReentrant`
    ///  function is not supported. It is possible to prevent this from happening
    ///  by making the `nonReentrant` function external, and making it call a
    ///  `private` function that does the actual work.
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    constructor() {
        _status = _NOT_ENTERED;
    }

    function _nonReentrantBefore() private {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        _status = _NOT_ENTERED;
    }

    ///  @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
    ///  `nonReentrant` function in the call stack.
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
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

///  @title Counters
///  @author Matt Condon (@shrugs)
///  @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
///  of elements in a mapping, issuing ERC721 ids, or counting request ids.
///  Include with `using Counters for Counters.Counter;`
library Counters {
    struct Counter {
        uint256 _value;
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

///  @dev Interface of the ERC165 standard, as defined in the
///  https://eips.ethereum.org/EIPS/eip-165[EIP].
///  Implementers can declare support of contract interfaces, which can then be
///  queried by others ({ERC165Checker}).
///  For an implementation, see {ERC165}.
interface IERC165 {
    ///  @dev Returns true if this contract implements the interface defined by
    ///  `interfaceId`. See the corresponding
    ///  https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
    ///  to learn more about how these ids are created.
    ///  This function call must use less than 30 000 gas.
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
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
            require(denominator > prod1, "Math: mulDiv overflow");
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

    ///  @dev Return the log in base 256, following the selected rounding direction, of a positive value.
    ///  Returns 0 if given 0.
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (((rounding == Rounding.Up) && ((1 << (result << 3)) < value)) ? 1 : 0);
        }
    }
}

///  @dev Wrappers over Solidity's arithmetic operations.
///  NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
///  now has built in overflow checking.
library SafeMath {
    ///  @dev Returns the addition of two unsigned integers, with an overflow flag.
    ///  _Available since v3.4._
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    ///  @dev Returns the subtraction of two unsigned integers, with an overflow flag.
    ///  _Available since v3.4._
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    ///  @dev Returns the multiplication of two unsigned integers, with an overflow flag.
    ///  _Available since v3.4._
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if ((c / a) != b) return (false, 0);
            return (true, c);
        }
    }

    ///  @dev Returns the division of two unsigned integers, with a division by zero flag.
    ///  _Available since v3.4._
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    ///  @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
    ///  _Available since v3.4._
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    ///  @dev Returns the addition of two unsigned integers, reverting on
    ///  overflow.
    ///  Counterpart to Solidity's `+` operator.
    ///  Requirements:
    ///  - Addition cannot overflow.
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    ///  @dev Returns the subtraction of two unsigned integers, reverting on
    ///  overflow (when the result is negative).
    ///  Counterpart to Solidity's `-` operator.
    ///  Requirements:
    ///  - Subtraction cannot overflow.
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    ///  @dev Returns the multiplication of two unsigned integers, reverting on
    ///  overflow.
    ///  Counterpart to Solidity's `*` operator.
    ///  Requirements:
    ///  - Multiplication cannot overflow.
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    ///  @dev Returns the integer division of two unsigned integers, reverting on
    ///  division by zero. The result is rounded towards zero.
    ///  Counterpart to Solidity's `/` operator.
    ///  Requirements:
    ///  - The divisor cannot be zero.
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    ///  @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
    ///  reverting when dividing by zero.
    ///  Counterpart to Solidity's `%` operator. This function uses a `revert`
    ///  opcode (which leaves remaining gas untouched) while Solidity uses an
    ///  invalid opcode to revert (consuming all remaining gas).
    ///  Requirements:
    ///  - The divisor cannot be zero.
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    ///  @dev Returns the subtraction of two unsigned integers, reverting with custom message on
    ///  overflow (when the result is negative).
    ///  CAUTION: This function is deprecated because it requires allocating memory for the error
    ///  message unnecessarily. For custom revert reasons use {trySub}.
    ///  Counterpart to Solidity's `-` operator.
    ///  Requirements:
    ///  - Subtraction cannot overflow.
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    ///  @dev Returns the integer division of two unsigned integers, reverting with custom message on
    ///  division by zero. The result is rounded towards zero.
    ///  Counterpart to Solidity's `/` operator. Note: this function uses a
    ///  `revert` opcode (which leaves remaining gas untouched) while Solidity
    ///  uses an invalid opcode to revert (consuming all remaining gas).
    ///  Requirements:
    ///  - The divisor cannot be zero.
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    ///  @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
    ///  reverting with custom message when dividing by zero.
    ///  CAUTION: This function is deprecated because it requires allocating memory for the error
    ///  message unnecessarily. For custom revert reasons use {tryMod}.
    ///  Counterpart to Solidity's `%` operator. This function uses a `revert`
    ///  opcode (which leaves remaining gas untouched) while Solidity uses an
    ///  invalid opcode to revert (consuming all remaining gas).
    ///  Requirements:
    ///  - The divisor cannot be zero.
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

///  @dev Standard signed math utilities missing in the Solidity language.
library SignedMath {
    ///  @dev Returns the largest of two signed numbers.
    function max(int256 a, int256 b) internal pure returns (int256) {
        return (a > b) ? a : b;
    }

    ///  @dev Returns the smallest of two signed numbers.
    function min(int256 a, int256 b) internal pure returns (int256) {
        return (a < b) ? a : b;
    }

    ///  @dev Returns the average of two signed numbers without overflow.
    ///  The result is rounded towards zero.
    function average(int256 a, int256 b) internal pure returns (int256) {
        int256 x = (a & b) + ((a ^ b) >> 1);
        return x + (int256(uint256(x) >> 255) & (a ^ b));
    }

    ///  @dev Returns the absolute unsigned value of a signed value.
    function abs(int256 n) internal pure returns (uint256) {
        unchecked {
            return uint256((n >= 0) ? n : (-n));
        }
    }
}

///  @dev Contract module which provides a basic access control mechanism, where
///  there is an account (an owner) that can be granted exclusive access to
///  specific functions.
///  By default, the owner account will be the one that deploys the contract. This
///  can later be changed with {transferOwnership}.
///  This module is used through inheritance. It will make available the modifier
///  `onlyOwner`, which can be applied to your functions to restrict their use to
///  the owner.
abstract contract Ownable is Context {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address private _owner;

    ///  @dev Throws if called by any account other than the owner.
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    ///  @dev Initializes the contract setting the deployer as the initial owner.
    constructor() {
        _transferOwnership(_msgSender());
    }

    ///  @dev Returns the address of the current owner.
    function owner() virtual public view returns (address) {
        return _owner;
    }

    ///  @dev Throws if the sender is not the owner.
    function _checkOwner() virtual internal view {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    ///  @dev Leaves the contract without owner. It will not be possible to call
    ///  `onlyOwner` functions. Can only be called by the current owner.
    ///  NOTE: Renouncing ownership will leave the contract without an owner,
    ///  thereby disabling any functionality that is only available to the owner.
    function renounceOwnership() virtual public onlyOwner() {
        _transferOwnership(address(0));
    }

    ///  @dev Transfers ownership of the contract to a new account (`newOwner`).
    ///  Can only be called by the current owner.
    function transferOwnership(address newOwner) virtual public onlyOwner() {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    ///  @dev Transfers ownership of the contract to a new account (`newOwner`).
    ///  Internal function without access restriction.
    function _transferOwnership(address newOwner) virtual internal {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

///  @dev Contract module which allows children to implement an emergency stop
///  mechanism that can be triggered by an authorized account.
///  This module is used through inheritance. It will make available the
///  modifiers `whenNotPaused` and `whenPaused`, which can be applied to
///  the functions of your contract. Note that they will not be pausable by
///  simply including this module, only once the modifiers are put in place.
abstract contract Pausable is Context {
    ///  @dev Emitted when the pause is triggered by `account`.
    event Paused(address account);

    ///  @dev Emitted when the pause is lifted by `account`.
    event Unpaused(address account);

    bool private _paused;

    ///  @dev Modifier to make a function callable only when the contract is not paused.
    ///  Requirements:
    ///  - The contract must not be paused.
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    ///  @dev Modifier to make a function callable only when the contract is paused.
    ///  Requirements:
    ///  - The contract must be paused.
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    ///  @dev Initializes the contract in unpaused state.
    constructor() {
        _paused = false;
    }

    ///  @dev Returns true if the contract is paused, and false otherwise.
    function paused() virtual public view returns (bool) {
        return _paused;
    }

    ///  @dev Throws if the contract is paused.
    function _requireNotPaused() virtual internal view {
        require(!paused(), "Pausable: paused");
    }

    ///  @dev Throws if the contract is not paused.
    function _requirePaused() virtual internal view {
        require(paused(), "Pausable: not paused");
    }

    ///  @dev Triggers stopped state.
    ///  Requirements:
    ///  - The contract must not be paused.
    function _pause() virtual internal whenNotPaused() {
        _paused = true;
        emit Paused(_msgSender());
    }

    ///  @dev Returns to normal state.
    ///  Requirements:
    ///  - The contract must be paused.
    function _unpause() virtual internal whenPaused() {
        _paused = false;
        emit Unpaused(_msgSender());
    }
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

///  @dev Required interface of an ERC721 compliant contract.
interface IERC721 is IERC165 {
    ///  @dev Emitted when `tokenId` token is transferred from `from` to `to`.
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    ///  @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    ///  @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    ///  @dev Returns the number of tokens in ``owner``'s account.
    function balanceOf(address owner) external view returns (uint256 balance);

    ///  @dev Returns the owner of the `tokenId` token.
    ///  Requirements:
    ///  - `tokenId` must exist.
    function ownerOf(uint256 tokenId) external view returns (address owner);

    ///  @dev Safely transfers `tokenId` token from `from` to `to`.
    ///  Requirements:
    ///  - `from` cannot be the zero address.
    ///  - `to` cannot be the zero address.
    ///  - `tokenId` token must exist and be owned by `from`.
    ///  - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
    ///  - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    ///  Emits a {Transfer} event.
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    ///  @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
    ///  are aware of the ERC721 protocol to prevent tokens from being forever locked.
    ///  Requirements:
    ///  - `from` cannot be the zero address.
    ///  - `to` cannot be the zero address.
    ///  - `tokenId` token must exist and be owned by `from`.
    ///  - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
    ///  - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    ///  Emits a {Transfer} event.
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    ///  @dev Transfers `tokenId` token from `from` to `to`.
    ///  WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
    ///  or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
    ///  understand this adds an external call which potentially creates a reentrancy vulnerability.
    ///  Requirements:
    ///  - `from` cannot be the zero address.
    ///  - `to` cannot be the zero address.
    ///  - `tokenId` token must be owned by `from`.
    ///  - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
    ///  Emits a {Transfer} event.
    function transferFrom(address from, address to, uint256 tokenId) external;

    ///  @dev Gives permission to `to` to transfer `tokenId` token to another account.
    ///  The approval is cleared when the token is transferred.
    ///  Only a single account can be approved at a time, so approving the zero address clears previous approvals.
    ///  Requirements:
    ///  - The caller must own the token or be an approved operator.
    ///  - `tokenId` must exist.
    ///  Emits an {Approval} event.
    function approve(address to, uint256 tokenId) external;

    ///  @dev Approve or remove `operator` as an operator for the caller.
    ///  Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
    ///  Requirements:
    ///  - The `operator` cannot be the caller.
    ///  Emits an {ApprovalForAll} event.
    function setApprovalForAll(address operator, bool approved) external;

    ///  @dev Returns the account approved for `tokenId` token.
    ///  Requirements:
    ///  - `tokenId` must exist.
    function getApproved(uint256 tokenId) external view returns (address operator);

    ///  @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
    ///  See {setApprovalForAll}
    function isApprovedForAll(address owner, address operator) external view returns (bool);
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

    ///  @dev Converts a `int256` to its ASCII `string` decimal representation.
    function toString(int256 value) internal pure returns (string memory) {
        return string(abi.encodePacked((value < 0) ? "-" : "", toString(SignedMath.abs(value))));
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

    ///  @dev Returns true if the two strings are equal.
    function equal(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

///  @dev Implementation of the {IERC20} interface.
///  This implementation is agnostic to the way tokens are created. This means
///  that a supply mechanism has to be added in a derived contract using {_mint}.
///  For a generic mechanism see {ERC20PresetMinterPauser}.
///  TIP: For a detailed writeup see our guide
///  https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
///  to implement supply mechanisms].
///  The default value of {decimals} is 18. To change this, you should override
///  this function so it returns a different value.
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
    ///  Ether and Wei. This is the default value returned by this function, unless
    ///  it's overridden.
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

///  @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
///  These functions can be used to verify that a message was signed by the holder
///  of the private keys of a given address.
library ECDSA {
    enum RecoverError { NoError, InvalidSignature, InvalidSignatureLength, InvalidSignatureS, InvalidSignatureV }

    function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return;
        } else if (error == RecoverError.InvalidSignature) {
            revert("ECDSA: invalid signature");
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert("ECDSA: invalid signature length");
        } else if (error == RecoverError.InvalidSignatureS) {
            revert("ECDSA: invalid signature 's' value");
        }
    }

    ///  @dev Returns the address that signed a hashed message (`hash`) with
    ///  `signature` or error string. This address can then be used for verification purposes.
    ///  The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
    ///  this function rejects them by requiring the `s` value to be in the lower
    ///  half order, and the `v` value to be either 27 or 28.
    ///  IMPORTANT: `hash` _must_ be the result of a hash operation for the
    ///  verification to be secure: it is possible to craft signatures that
    ///  recover to arbitrary addresses for non-hashed data. A safe way to ensure
    ///  this is by receiving a hash of the original message (which may otherwise
    ///  be too long), and then calling {toEthSignedMessageHash} on it.
    ///  Documentation for signature generation:
    ///  - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
    ///  - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
    ///  _Available since v4.3._
    function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            /// @solidity memory-safe-assembly
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
        } else {
            return (address(0), RecoverError.InvalidSignatureLength);
        }
    }

    ///  @dev Returns the address that signed a hashed message (`hash`) with
    ///  `signature`. This address can then be used for verification purposes.
    ///  The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
    ///  this function rejects them by requiring the `s` value to be in the lower
    ///  half order, and the `v` value to be either 27 or 28.
    ///  IMPORTANT: `hash` _must_ be the result of a hash operation for the
    ///  verification to be secure: it is possible to craft signatures that
    ///  recover to arbitrary addresses for non-hashed data. A safe way to ensure
    ///  this is by receiving a hash of the original message (which may otherwise
    ///  be too long), and then calling {toEthSignedMessageHash} on it.
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, signature);
        _throwError(error);
        return recovered;
    }

    ///  @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
    ///  See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
    ///  _Available since v4.3._
    function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
        bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        uint8 v = uint8((uint256(vs) >> 255) + 27);
        return tryRecover(hash, v, r, s);
    }

    ///  @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
    ///  _Available since v4.2._
    function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, r, vs);
        _throwError(error);
        return recovered;
    }

    ///  @dev Overload of {ECDSA-tryRecover} that receives the `v`,
    ///  `r` and `s` signature fields separately.
    ///  _Available since v4.3._
    function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS);
        }
        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            return (address(0), RecoverError.InvalidSignature);
        }
        return (signer, RecoverError.NoError);
    }

    ///  @dev Overload of {ECDSA-recover} that receives the `v`,
    ///  `r` and `s` signature fields separately.
    function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
        _throwError(error);
        return recovered;
    }

    ///  @dev Returns an Ethereum Signed Message, created from a `hash`. This
    ///  produces hash corresponding to the one signed with the
    ///  https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
    ///  JSON-RPC method as part of EIP-191.
    ///  See {recover}.
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 message) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, "\u0019Ethereum Signed Message:\n32")
            mstore(0x1c, hash)
            message := keccak256(0x00, 0x3c)
        }
    }

    ///  @dev Returns an Ethereum Signed Message, created from `s`. This
    ///  produces hash corresponding to the one signed with the
    ///  https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
    ///  JSON-RPC method as part of EIP-191.
    ///  See {recover}.
    function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\u0019Ethereum Signed Message:\n", Strings.toString(s.length), s));
    }

    ///  @dev Returns an Ethereum Signed Typed Data, created from a
    ///  `domainSeparator` and a `structHash`. This produces hash corresponding
    ///  to the one signed with the
    ///  https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
    ///  JSON-RPC method as part of EIP-712.
    ///  See {recover}.
    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 data) {
        /// @solidity memory-safe-assembly
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, "\u0019\u0001")
            mstore(add(ptr, 0x02), domainSeparator)
            mstore(add(ptr, 0x22), structHash)
            data := keccak256(ptr, 0x42)
        }
    }

    ///  @dev Returns an Ethereum Signed Data with intended validator, created from a
    ///  `validator` and `data` according to the version 0 of EIP-191.
    ///  See {recover}.
    function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\u0019\u0000", validator, data));
    }
}

contract Bean is ERC20, Pausable, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using ECDSA for bytes32;

    uint256 public constant MAX_SUPPLY = 1_000_000_000 * (10 ** 18);
    address public signatureManager;
    mapping(address => mapping(uint256 => bool)) public tokenClaimed;
    mapping(bytes => bool) public signatureClaimed;
    mapping(address => bool) public contractSupports;

    receive() external payable {}

    constructor(string memory _name, string memory _symbol, address _treasury, address _zagabond, address _signatureManager, address[] memory _contracts) ERC20(_name,_symbol) {
        _mint(address(this), MAX_SUPPLY.div(2));
        _mint(_treasury, MAX_SUPPLY.div(10).mul(4));
        _mint(_zagabond, MAX_SUPPLY.div(10).mul(1));
        signatureManager = _signatureManager;
        for (uint256 i = 0; i < _contracts.length; i++) {
            contractSupports[_contracts[i]] = true;
        }
    }

    function claim_check(address[] memory _contracts, uint256[] memory _amounts, uint256[] memory _tokenIds, uint256 _claimAmount, uint256 _endTime, bytes memory _signature) internal returns (bool success) {
        if (signatureClaimed[_signature]) return false;
        if (_contracts.length != _amounts.length) return false;
        for (uint256 i = 0; i < _contracts.length; i++) {
            if (!contractSupports[_contracts[i]]) return false;
        }
        uint256 totalAmount;
        for (uint256 j = 0; j < _amounts.length; j++) {
            totalAmount = totalAmount + _amounts[j];
        }
        if (totalAmount != _tokenIds.length) return false;
        bytes32 message = keccak256(abi.encodePacked(msg.sender, _contracts, _tokenIds, _claimAmount, _endTime));
        if (signatureManager != message.toEthSignedMessageHash().recover(_signature)) return false;
        if (block.timestamp > _endTime) return false;
        return true;
    }

    /// @custom:consol
    ///  {claim(_contracts, _amounts, _tokenIds, _claimAmount, _endTime, _signature) returns ()
    ///    ensures {claim_check(_contracts, _amounts, _tokenIds, _claimAmount, _endTime)}}
    function claim_original(address[] memory _contracts, uint256[] memory _amounts, uint256[] memory _tokenIds, uint256 _claimAmount, uint256 _endTime, bytes memory _signature) private whenNotPaused() nonReentrant() {
        require(_contracts.length == _amounts.length, "contracts length not match amounts length");
        for (uint256 i = 0; i < _contracts.length; i++) {
            require(contractSupports[_contracts[i]], "contract not support");
        }
        uint256 totalAmount;
        for (uint256 j = 0; j < _amounts.length; j++) {
            totalAmount = totalAmount + _amounts[j];
        }
        require(totalAmount == _tokenIds.length, "total amount not match tokenId length");
        bytes32 message = keccak256(abi.encodePacked(msg.sender, _contracts, _tokenIds, _claimAmount, _endTime));
        require(signatureManager == message.toEthSignedMessageHash().recover(_signature), "invalid signature");
        require(block.timestamp <= _endTime, "signature expired");
        uint256 endIndex;
        uint256 startIndex;
        for (uint256 i = 0; i < _amounts.length; i++) {
            endIndex = startIndex + _amounts[i];
            for (uint256 j = startIndex; j < endIndex; j++) {
                address contractAddr = _contracts[i];
                uint256 tokenId = _tokenIds[j];
                require(IERC721(contractAddr).ownerOf(tokenId) == msg.sender, "not owner");
                tokenClaimed[contractAddr][tokenId] = true;
            }
            startIndex = endIndex;
        }
        signatureClaimed[_signature] = true;
        _transfer(address(this), msg.sender, _claimAmount);
    }

    function setContractSupports(address[] memory _contracts, bool[] memory _enables) external onlyOwner() {
        require(_contracts.length == _enables.length, "contracts length not match _enables length");
        for (uint256 i = 0; i < _contracts.length; i++) {
            contractSupports[_contracts[i]] = _enables[i];
        }
    }

    function setSignatureManager(address _signatureManager) external onlyOwner() {
        signatureManager = _signatureManager;
    }

    function finish() external onlyOwner() whenPaused() {
        _burn(address(this), balanceOf(address(this)));
    }

    function pause() external onlyOwner() whenNotPaused() {
        _pause();
    }

    function unpause() external onlyOwner() whenPaused() {
        _unpause();
    }

    function withdraw(address _receiver, address _token, bool _isETH) external onlyOwner() {
        if (_isETH) {
            payable(_receiver).transfer(address(this).balance);
        } else {
            IERC20(_token).transfer(_receiver, IERC20(_token).balanceOf(address(this)));
        }
    }

    function _claim_post(address[] memory _contracts, uint256[] memory _amounts, uint256[] memory _tokenIds, uint256 _claimAmount, uint256 _endTime, bytes memory _signature) private {
        if (!(claim_check(_contracts,_amounts,_tokenIds,_claimAmount,_endTime))) revert();
    }

    function claim(address[] memory _contracts, uint256[] memory _amounts, uint256[] memory _tokenIds, uint256 _claimAmount, uint256 _endTime, bytes memory _signature) external {
        claim_original(_contracts, _amounts, _tokenIds, _claimAmount, _endTime, _signature);
        _claim_post(_contracts, _amounts, _tokenIds, _claimAmount, _endTime, _signature);
    }
}