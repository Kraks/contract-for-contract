pragma solidity ^0.8.9; // DX: 0.5.16 doesn't work, import doesn't work
// pragma solidity =0.5.16;

contract SwaposV2Pair {
    address public factory;
    address public token0;
    address public token1;

    uint112 private reserve0;           // uses single storage slot, accessible via getReserves
    uint112 private reserve1;           // uses single storage slot, accessible via getReserves
    uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves

    uint public price0CumulativeLast;
    uint public price1CumulativeLast;
    uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event

    uint private unlocked = 1;

    function __update_pre_condition(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private returns (bool) {
        if (balance0 > _reserve0 || balance1 > _reserve1) {
            if (balance0 * balance1 < _reserve0 * _reserve1) {
                return false;
            }
        }

        
        return true;
    }

    // update reserves and, on the first call per block, price accumulators
    /// @custom:consol { _update(balance0, balance1, _reserve0, _reserve1) returns () requires { __update_pre_condition(balance0, balance1, _reserve0, _reserve1) } }
    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        uint32 blockTimestamp = uint32(block.timestamp % 2**32);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            // * never overflows, and + overflow is desired
            price0CumulativeLast += timeElapsed;
            price1CumulativeLast += timeElapsed;
        }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
    }

    
}
