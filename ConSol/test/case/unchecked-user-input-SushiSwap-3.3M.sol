// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.10;

address constant NATIVE_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
address constant IMPOSSIBLE_POOL_ADDRESS = 0x0000000000000000000000000000000000000001;

/// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
uint160 constant MIN_SQRT_RATIO = 4295128739;
/// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
uint160 constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;

/// @title A route processor for the Sushi Aggregator
/// @author Ilya Lyalin
contract RouteProcessor2 {
  // IBentoBoxMinimal public immutable bentoBox;
  address private lastCalledPool;

  uint private unlocked = 1;
  modifier lock() {
      require(unlocked == 1, 'RouteProcessor is locked');
      unlocked = 2;
      _;
      unlocked = 1;
  }

  constructor(address _bentoBox) {
    // bentoBox = IBentoBoxMinimal(_bentoBox);
    lastCalledPool = IMPOSSIBLE_POOL_ADDRESS;
  }

  /// @notice For native unwrapping
  receive() external payable {}


  function _uniswapV3SwapCallback_pre_condition(
    int256 amount0Delta,
    int256 amount1Delta,
    bytes calldata data
  ) internal returns (bool) {
    if (msg.sender != lastCalledPool) {
        return false;
    }

    // address token0 = IUniswapV3Pool(msg.sender).token0();
    // address token1 = IUniswapV3Pool(msg.sender).token1();
    // uint24 fee = IUniswapV3Pool(msg.sender).fee();
    // if (IUniswapV3Factory(0xbACEB8eC6b9355Dfc0269C18bac9d6E2Bdc29C4F).getPool(token0, token1, fee) != msg.sender) {
    //     return false;
    // }

    (address tokenIn, address from) = abi.decode(data, (address, address));
    int256 amount = amount0Delta > 0 ? amount0Delta : amount1Delta;
    if (amount <= 0)  {
        return false;
    }

    return true;
  }


  /// @custom:consol {uniswapV3SwapCallback(amount0Delta, amount1Delta, data) returns () requires {_uniswapV3SwapCallback_pre_condition(amount0Delta, amount1Delta, data)}}
  function uniswapV3SwapCallback(
    int256 amount0Delta,
    int256 amount1Delta,
    bytes calldata data
  ) external {
    // XXX: consol fix
    lastCalledPool = IMPOSSIBLE_POOL_ADDRESS;
    (address tokenIn, address from) = abi.decode(data, (address, address));
    int256 amount = amount0Delta > 0 ? amount0Delta : amount1Delta;

    // if (from == address(this)) IERC20(tokenIn).safeTransfer(msg.sender, uint256(amount));
    //  else IERC20(tokenIn).safeTransferFrom(from, msg.sender, uint256(amount));
  }

  
}

