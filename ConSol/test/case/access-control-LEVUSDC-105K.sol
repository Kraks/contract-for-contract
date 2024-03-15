// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CurveSwap{
    address public TriPool;
    address public ADDRESSPROVIDER;
    address public USDC_ADDRESS;
    address public USDT_ADDRESS;


    function QueryAddressProvider(uint id) internal view returns (address) {
        //return IAddressProvider(ADDRESSPROVIDER).get_address(id);
        return ADDRESSPROVIDER;
    }


    /// @custom:consol {approveToken(token, spender, _amount) returns (ret) requires {spender == QueryAddressProvider(2)}}
    function approveToken(address token, address spender, uint _amount) public returns (bool) {
        //IERC20(token).safeApprove(spender, _amount);
        return true;
    }
}
