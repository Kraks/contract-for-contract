pragma solidity ^0.8.9;

contract SwaposV2Pair {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

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

    function __update_pre_condition(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private returns (bool) {
        if ((balance0 > _reserve0) || (balance1 > _reserve1)) {
            if ((balance0 * balance1) < (_reserve0 * _reserve1)) {
                return false;
            }
        }
        return true;
    }

    /// @custom:consol { _update(balance0, balance1, _reserve0, _reserve1) returns () requires { __update_pre_condition(balance0, balance1, _reserve0, _reserve1) } }
    function _update_original(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        uint32 blockTimestamp = uint32(block.timestamp % (2 ** 32));
        uint32 timeElapsed = blockTimestamp - blockTimestampLast;
        if (((timeElapsed > 0) && (_reserve0 != 0)) && (_reserve1 != 0)) {
            price0CumulativeLast += timeElapsed;
            price1CumulativeLast += timeElapsed;
        }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
    }

    function __update_pre(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        if (!(__update_pre_condition(balance0,balance1,_reserve0,_reserve1))) revert preViolation("_update");
    }

    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        __update_pre(balance0, balance1, _reserve0, _reserve1);
        _update_original(balance0, balance1, _reserve0, _reserve1);
    }
}