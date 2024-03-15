pragma solidity 0.8.10;

address constant NATIVE_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
address constant IMPOSSIBLE_POOL_ADDRESS = 0x0000000000000000000000000000000000000001;
uint160 constant MIN_SQRT_RATIO = 4295128739;
uint160 constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;

/// @title A route processor for the Sushi Aggregator
///  @author Ilya Lyalin
contract RouteProcessor2 {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    address private lastCalledPool;
    uint private unlocked = 1;

    modifier lock() {
        require(unlocked == 1, "RouteProcessor is locked");
        unlocked = 2;
        _;
        unlocked = 1;
    }

    constructor(address _bentoBox) {
        lastCalledPool = IMPOSSIBLE_POOL_ADDRESS;
    }

    /// @notice For native unwrapping
    receive() external payable {}

    function _uniswapV3SwapCallback_pre_condition(int256 amount0Delta, int256 amount1Delta, bytes calldata data) internal returns (bool) {
        if (msg.sender != lastCalledPool) {
            return false;
        }
        (address tokenIn, address from) = abi.decode(data, (address, address));
        int256 amount = (amount0Delta > 0) ? amount0Delta : amount1Delta;
        if (amount <= 0) {
            return false;
        }
        return true;
    }

    /// @custom:consol {uniswapV3SwapCallback(amount0Delta, amount1Delta, data) returns () requires {_uniswapV3SwapCallback_pre_condition(amount0Delta, amount1Delta, data)}}
    function uniswapV3SwapCallback_original(int256 amount0Delta, int256 amount1Delta, bytes calldata data) private {
        lastCalledPool = IMPOSSIBLE_POOL_ADDRESS;
        (address tokenIn, address from) = abi.decode(data, (address, address));
        int256 amount = (amount0Delta > 0) ? amount0Delta : amount1Delta;
    }

    function _uniswapV3SwapCallback_pre(int256 amount0Delta, int256 amount1Delta, bytes calldata data) private {
        if (!(_uniswapV3SwapCallback_pre_condition(amount0Delta,amount1Delta,data))) revert preViolation("uniswapV3SwapCallback");
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external {
        _uniswapV3SwapCallback_pre(amount0Delta, amount1Delta, data);
        uniswapV3SwapCallback_original(amount0Delta, amount1Delta, data);
    }
}