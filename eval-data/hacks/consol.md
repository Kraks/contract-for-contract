## access-control-LEVUSDC-105K
```
consol ../eval-data/hacks/access-control-LEVUSDC-105K/contract/flattened.sol
```

```solidity
/// @custom:consol
    /// {approveToken(token, spender, _amount) returns (ret)
    ///     requires {spender == QueryAddressProvider(2)}}
    function approveToken(address token, address spender, uint _amount) public returns (bool) {...}

```
output: `eval-data/hacks/access-control-LEVUSDC-105K/contract/flattened_out.sol`

- guard fun generated FIXED


## any-token-is-destroyed-TecraSpace-63k
```
consol ../eval-data/hacks/any-token-is-destroyed-TecraSpace-63k/contract/flattened.sol
```

```solidity
/// @custom:consol
    /// {burnFrom(from, amount) returns ()
    ///     requires {_allowances[from][msg.sender] >= amount && _balances[from] >= amount}}
    function burnFrom(address from, uint256 amount) external {...}

```

output: `eval-data/hacks/arbitrary-external-call-dexible-1.5M/lib/SwapHandler_out.sol`

- guard fun generated FIXED


## arbitrary-external-call-dexible-1.5M
```
consol ../eval-data/hacks/arbitrary-external-call-dexible-1.5M/contract/flattened.sol
```

```solidity
 /// @custom:consol
    /// {fill(request, meta) returns (meta)
    ///     requires {_checkRequest(request)}
    ///     ensures {meta.outAmount >= request.tokenOut.amount}}
    function fill(SwapTypes.SwapRequest calldata request, SwapMeta memory meta) external onlySelf returns (SwapMeta memory)  {...}
```

output: `eval-data/hacks/arbitrary-external-call-dexible-1.5M/contract/flattened_out.sol`

- guard fun generated NEED DOUBLE CHECK
- consol parsing error

## bridge-address-issue-Qubit-80M
```
consol ../eval-data/hacks/bridge-address-issue-Qubit-80M/contract/flattened.sol
```

```solidity
/// @dev
    /// {deposit(resourceID, depositer, data) returns ()
    ///     ensures {(resourceIDToTokenContractAddress[resourceID] != address(0) && contractWhitelist[resourceIDToTokenContractAddress[resourceID]])} }
    function deposit(bytes32 resourceID, address depositer, bytes calldata data) external override onlyBridge {...}

```

output: `eval-data/hacks/bridge-address-issue-Qubit-80M/contract/flattened_out.sol`

- guard fun generated FIXED

## erroneous-accounting-SwaposV2-468K

```
consol ../eval-data/hacks/erroneous-accounting-SwaposV2-468K/contract/flattened.sol
```

```solidity
/// @dev
    /// {_update(balance0, balance1, _reserve0, _reserve1) returns ()
    ///   requires {__update_pre_condition(balance0, balance1, _reserve0, _reserve1)}}
    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {...}
```

output: `eval-data/hacks/erroneous-accounting-SwaposV2-468K/contract/flattened_out.sol`


## infinite-number-of-loans-XCarnival-3.87M

```
consol ../eval-data/hacks/infinite-number-of-loans-XCarnival-3.87M/contract/flattened.sol
```

```solidity
/// @custom:consol
    /// {borrowAllowed(xToken, orderId, borrower, borrowAmount) returns ()
    ///   requires {_checkBorrowAllowed(xToken, orderId, borrower, borrowAmount)}}
    function borrowAllowed(address xToken, uint256 orderId, address borrower, uint256 borrowAmount) external whenNotPaused(xToken, 3){...}
```

output: `/eval-data/hacks/infinite-number-of-loans-XCarnival-3.87M/contract/flattened_out.sol`

- guard fun generated FIXED

## inflation-manipulate-BaoCommunity-46K
```
consol ../eval-data/hacks/inflation-manipulate-BaoCommunity-46K/contract/flattened.sol
```

```solidity
/// @dev
    /// {redeemInternal(redeemTokens) returns (error)
    ///     requires {accrueInterest() == uint(Error.NO_ERROR)}
    ///     ensures {totalSupply > 1000}}
    function redeemInternal(uint redeemTokens) internal nonReentrant returns (uint) {...}

    /// @dev
    /// {redeemUnderlyingInternal(redeemTokens) returns (error)
    ///     requires {accrueInterest() == uint(Error.NO_ERROR)}
    ///     ensures {totalSupply > 1000}}
    function redeemUnderlyingInternal(uint redeemAmount) internal nonReentrant returns (uint) {...}

```
output: `eval-data/hacks/inflation-manipulate-BaoCommunity-46K/contract/flattened_out.sol`


## integer-overflow-Umbrella-700K
```
consol ../eval-data/hacks/integer-overflow-Umbrella-700K/contract/flattened.sol
```

```solidity
/// @dev
    /// {_withdraw(amount, user, recipient)
    ///      requires {_balances[user] >= amount && amount != 0}}
    function _withdraw(uint256 amount, address user, address recipient) internal nonReentrant updateReward(user) {...}
```

output: `eval-data/hacks/integer-overflow-Umbrella-700K/contract/flattened_out.sol`

- guard fun generated FIXED


## invalid-signature-verification-AzukiDAO-69K

```
consol ../eval-data/hacks/invalid-signature-verification-AzukiDAO-69K/contract/flattened.sol
```

```solidity
    /// @custom:consol
    ///  {claim(_contracts, _amounts, _tokenIds, _claimAmount, _endTime, _signature) returns ()
    ///    ensures {claim_check(_contracts, _amounts, _tokenIds, _claimAmount, _endTime)}}
    function claim_original(address[] memory _contracts, uint256[] memory _amounts, uint256[] memory _tokenIds, uint256 _claimAmount, uint256 _endTime, bytes memory _signature) private whenNotPaused() nonReentrant() {...}

```
output: `eval-data/hacks/invalid-signature-verification-AzukiDAO-69K/contract/flattened_out.sol`

## lack-of-validation-Miner-466K
```
consol ../eval-data/hacks/lack-of-validation-Miner-466K/contract/flattened.sol
```


```solidity
 /// @custom:consol
    /// {_transfer(from, to, value, mint)
    ///   ensures {(from != address(0) && to != address(0) && from != to)}}
    function _transfer(address from, address to, uint256 value, bool mint) internal {...}
```

output: `eval-data/hacks/lack-of-validation-Miner-466K/contract/flattened_out.sol`

- had to downgrade from `pragma solidity =0.8.24;` to `pragma solidity =0.8;`
- guard fun generated NEED DOUBLE CHECK
- consol parsing error

## missing-airdrop-eligibility-check-BadGuys-NFT
no consol comment found


## missing-slippage-check-UnknownVictim-111K (TODO)
```
consol ../eval-data/hacks/missing-slippage-check-UnknownVictim-111K/contract/flattened.sol
```


```solidity
/// @dev curve.exchange_underlying(x, y, camount, n)
  ///   ensures _exchange_underlying_post_condition(camount)
  PriceInterface public curve = PriceInterface(CurveInterface(0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3).curve());
```



## read-only-reentrancy-sturdy-800K (TODO)
```
consol ../eval-data/hacks/read-only-reentrancy-sturdy-800K/contract/flattened.sol
```

```solidity
 /// @custom:consol {IChainlinkAggregator(STETH).latestRoundData{value: v, gas: g}() returns (roundId, answer, startedAt, updatedAt, answeredInRound) ensures {(updatedAt > block.timestamp - 1 days) && (answer > 0)}}
  IChainlinkAggregator private constant STETH =
    IChainlinkAggregator(0x86392dC19c0b719886221c78AB11eb8Cf5c52812);

...
//custom:consol
  /// {_get() returns (ret)
  ///   ensures {(ret * 95 / 100 < BALWSTETHWETH.getLatest(1)) && 
  ///       (ret * 105 / 100 > BALWSTETHWETH.getLatest(1))}}
  function _get() internal view returns (uint256) {...}


```

output: `eval-data/hacks/read-only-reentrancy-sturdy-800K/contract/flattened_out.sol`


- storage spec : TODO



## reentrancy-N00d-29K
```
consol ../eval-data/hacks/reentrancy-N00d-29K/contract/flattened.sol
```

```solidity
  /// @dev
    /// {enter(_amount) returns ()
    ///   ensures {totalSupply() <= sushi.balanceOf(address(this))}}
    function enter(uint256 _amount) public {...}

    /// @dev
    /// {leave(_share) returns ()
    ///   ensures {totalSupply() <= sushi.balanceOf(address(this))}}
    function leave(uint256 _share) public {...}
```

output: `eval-data/hacks/reentrancy-N00d-29K/contract/flattened_out.sol`


## unchecked-flashloan-callback-EFLeverVault-1M
```
consol ../eval-data/hacks/reentrancy-N00d-29K/contract/flattened.sol
```
```solidity
/// @dev
  /// {receiveFlashLoan(tokens, amounts, feeAmounts, userData) returns ()
  ///    requires {_entered == 1 && msg.sender == balancer}}
  function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) public payable {...}
```
output: `eval-data/hacks/reentrancy-N00d-29K/contract/flattened_out.sol`



## unchecked-user-input-SushiSwap-3.3M

```
consol ../eval-data/hacks/unchecked-user-input-SushiSwap-3.3M/contract/flattened.sol
```

```solidity
 /// @custom:consol {uniswapV3SwapCallback(amount0Delta, amount1Delta, data) returns ()
  ///    requires {_uniswapV3SwapCallback_pre_condition(amount0Delta, amount1Delta, data)}}
  function uniswapV3SwapCallback(
    int256 amount0Delta,
    int256 amount1Delta,
    bytes calldata data
  ) external {...}

```
output: `eval-data/hacks/unchecked-user-input-SushiSwap-3.3M/contract/flattened_out.sol`
