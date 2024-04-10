pragma solidity =0.5.16;

import "./interfaces/ISwaposV2Pair.sol";
import "./SwaposV2ERC20.sol";
import "./libraries/Math.sol";
import "./libraries/UQ112x112.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/ISwaposV2Factory.sol";
import "./interfaces/ISwaposV2Callee.sol";

contract SwaposV2Pair is ISwaposV2Pair, SwaposV2ERC20 {
    using SafeMath for uint;
    using UQ112x112 for uint224;

    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    event Mint(address indexed sender, uint amount0, uint amount1);

    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

    event Swap(address indexed sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address indexed to);

    event Sync(uint112 reserve0, uint112 reserve1);

    uint public constant MINIMUM_LIQUIDITY = 10 ** 3;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
    address public factory;
    address public token0;
    address public token1;
    uint112 private reserve0;
    uint112 private reserve1;
    uint32 private blockTimestampLast;
    uint public price0CumulativeLast;
    uint public price1CumulativeLast;
    uint public kLast;
    uint private unlocked = 1;

    modifier lock() {
        require(unlocked == 1, "SwaposV2: LOCKED");
        unlocked = 0;
        _;
        unlocked = 1;
    }

    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    function _safeTransfer(address token, address to, uint value) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
        require(success && ((data.length == 0) || abi.decode(data, (bool))), "SwaposV2: TRANSFER_FAILED");
    }

    constructor() public {
        factory = msg.sender;
    }

    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "SwaposV2: FORBIDDEN");
        token0 = _token0;
        token1 = _token1;
    }

    function __update_pre_condition(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private returns (bool) {
        if ((balance0 > _reserve0) || (balance1 > _reserve1)) {
            if (balance0.mul(balance1) < uint(_reserve0).mul(_reserve1)) {
                return false;
            }
        }
        if ((balance0 > uint112(-1)) || (balance1 > uint112(-1))) {
            return false;
        }
        return true;
    }

    /// @dev { _update(balance0, balance1, _reserve0, _reserve1) returns () requires {__update_pre_condition(balance0, balance1, _reserve0, _reserve1)} }
    function _update_original(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        uint32 blockTimestamp = uint32(block.timestamp % (2 ** 32));
        uint32 timeElapsed = blockTimestamp - blockTimestampLast;
        if (((timeElapsed > 0) && (_reserve0 != 0)) && (_reserve1 != 0)) {
            price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
            price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
        }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
        emit Sync(reserve0, reserve1);
    }

    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
        address feeTo = ISwaposV2Factory(factory).feeTo();
        feeOn = feeTo != address(0);
        uint _kLast = kLast;
        if (feeOn) {
            if (_kLast != 0) {
                uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
                uint rootKLast = Math.sqrt(_kLast);
                if (rootK > rootKLast) {
                    uint numerator = totalSupply.mul(rootK.sub(rootKLast));
                    uint denominator = rootK.mul(1).add(rootKLast);
                    uint liquidity = numerator / denominator;
                    if (liquidity > 0) _mint(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }

    function mint(address to) external lock() returns (uint liquidity) {
        (uint112 _reserve0, uint112 _reserve1, ) = getReserves();
        uint balance0 = IERC20(token0).balanceOf(address(this));
        uint balance1 = IERC20(token1).balanceOf(address(this));
        uint amount0 = balance0.sub(_reserve0);
        uint amount1 = balance1.sub(_reserve1);
        bool feeOn = _mintFee(_reserve0, _reserve1);
        uint _totalSupply = totalSupply;
        if (_totalSupply == 0) {
            liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
            _mint(address(0), MINIMUM_LIQUIDITY);
        } else {
            liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
        }
        require(liquidity > 0, "SwaposV2: INSUFFICIENT_LIQUIDITY_MINTED");
        _mint(to, liquidity);
        _update(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = uint(reserve0).mul(reserve1);
        emit Mint(msg.sender, amount0, amount1);
    }

    function burn(address to) external lock() returns (uint amount0, uint amount1) {
        (uint112 _reserve0, uint112 _reserve1, ) = getReserves();
        address _token0 = token0;
        address _token1 = token1;
        uint balance0 = IERC20(_token0).balanceOf(address(this));
        uint balance1 = IERC20(_token1).balanceOf(address(this));
        uint liquidity = balanceOf[address(this)];
        bool feeOn = _mintFee(_reserve0, _reserve1);
        uint _totalSupply = totalSupply;
        amount0 = liquidity.mul(balance0) / _totalSupply;
        amount1 = liquidity.mul(balance1) / _totalSupply;
        require((amount0 > 0) && (amount1 > 0), "SwaposV2: INSUFFICIENT_LIQUIDITY_BURNED");
        _burn(address(this), liquidity);
        _safeTransfer(_token0, to, amount0);
        _safeTransfer(_token1, to, amount1);
        balance0 = IERC20(_token0).balanceOf(address(this));
        balance1 = IERC20(_token1).balanceOf(address(this));
        _update(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = uint(reserve0).mul(reserve1);
        emit Burn(msg.sender, amount0, amount1, to);
    }

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock() {
        require((amount0Out > 0) || (amount1Out > 0), "SwaposV2: INSUFFICIENT_OUTPUT_AMOUNT");
        (uint112 _reserve0, uint112 _reserve1, ) = getReserves();
        require((amount0Out < _reserve0) && (amount1Out < _reserve1), "SwaposV2: INSUFFICIENT_LIQUIDITY");
        uint balance0;
        uint balance1;
        {
            address _token0 = token0;
            address _token1 = token1;
            require((to != _token0) && (to != _token1), "SwaposV2: INVALID_TO");
            if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out);
            if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out);
            if (data.length > 0) ISwaposV2Callee(to).swaposV2Call(msg.sender, amount0Out, amount1Out, data);
            balance0 = IERC20(_token0).balanceOf(address(this));
            balance1 = IERC20(_token1).balanceOf(address(this));
        }
        uint amount0In = (balance0 > (_reserve0 - amount0Out)) ? (balance0 - (_reserve0 - amount0Out)) : 0;
        uint amount1In = (balance1 > (_reserve1 - amount1Out)) ? (balance1 - (_reserve1 - amount1Out)) : 0;
        require((amount0In > 0) || (amount1In > 0), "SwaposV2: INSUFFICIENT_INPUT_AMOUNT");
        {
            uint balance0Adjusted = balance0.mul(10000).sub(amount0In.mul(10));
            uint balance1Adjusted = balance1.mul(10000).sub(amount1In.mul(10));
            require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000 ** 2), "SwaposV2: K");
        }
        _update(balance0, balance1, _reserve0, _reserve1);
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }

    function skim(address to) external lock() {
        address _token0 = token0;
        address _token1 = token1;
        _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
        _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
    }

    function sync() external lock() {
        _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
    }

    function __update_pre(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        if (!(__update_pre_condition(balance0,balance1,_reserve0,_reserve1))) revert preViolation("_update");
    }

    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        __update_pre(balance0, balance1, _reserve0, _reserve1);
        _update_original(balance0, balance1, _reserve0, _reserve1);
    }
}