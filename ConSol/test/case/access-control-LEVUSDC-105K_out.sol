pragma solidity ^0.8.9;

contract CurveSwap {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    address public TriPool;
    address public ADDRESSPROVIDER;
    address public USDC_ADDRESS;
    address public USDT_ADDRESS;

    function QueryAddressProvider(uint id) internal view returns (address) {
        return ADDRESSPROVIDER;
    }

    /// @custom:consol {approveToken(token, spender, _amount) returns (ret) requires {spender == QueryAddressProvider(2)}}
    function approveToken_original(uint256 token, uint256 spender, uint256 _amount) public returns (bool) {
        return true;
    }

    function _approveToken_pre(address token, address spender, uint _amount) private {
        if (!(spender==QueryAddressProvider(2))) revert preViolation("approveToken");
    }

    function approveToken_guard(uint256 token, uint256 spender, uint256 _amount) private returns (bool) {
        _approveToken_pre(payable(address(uint160(token))), payable(address(uint160(spender))), _amount);
        token = token | (uint96(1 << 0) << 160);
        spender = spender | (uint96(1 << 0) << 160);
        bool ret = approveToken_original(token, spender, _amount);
        return (ret);
    }

    function approveToken(address token, address spender, uint _amount) private returns (bool) {
        bool _cs_0 = approveToken_guard(uint256(uint160(address(token))), uint256(uint160(address(spender))), _amount);
        return (_cs_0);
    }
}