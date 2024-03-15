// File: contracts/utils/Ownable.sol
pragma solidity 0.8.10;
// pragma solidity >=0.4.21 <0.6.0;

contract EFLeverVault {
  uint128 internal _entered;
  // using Address for address;

  uint256 public constant ratio_base = 10000;

  uint256 public mlr;
  address payable public fee_pool;
  address public ef_token;
  uint256 public last_earn_block;

  uint256 public block_rate;
  uint256 last_volume;

  address public aave = address(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
  address public balancer = address(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
  address public balancer_fee = address(0xce88686553686DA562CE7Cea497CE749DA109f9F);
  address public lido = address(0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84);
  address public asteth = address(0x1982b2F5814301d4e9a8b0201555376e62F82428);
  address public curve_pool = address(0xDC24316b9AE028F1497c275EB9192a3Ea0f67022);
  address public weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

  bool public is_paused;

  //@param _crv, means ETH if it's 0x0
  constructor(address _ef_token) public {
    ef_token = _ef_token;
    mlr = 6750;
    last_earn_block = block.number;
  }

  /// @custom:consol {receiveFlashLoan(tokens, amounts, feeAmounts, userData) returns () requires {_entered == 1 && msg.sender == balancer}}
  function receiveFlashLoan(
        uint256[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) public payable {
        uint256 loan_amount = amounts[0];
        uint256 fee_amount = feeAmounts[0];

        if (keccak256(userData) == keccak256("0x1")){
          _deposit(loan_amount, fee_amount);
        }
        if (keccak256(userData) == keccak256("0x2")){
          _withdraw(loan_amount, fee_amount);
        }
    }


 function _deposit(uint256 amount, uint256 fee_amount) internal{
  return;
    // IWETH(weth).withdraw(amount);
    // {
    //   uint256 curve_out = ICurve(curve_pool).get_dy(0, 1, address(this).balance);
    //   if (curve_out < address(this).balance){
    //     ILido(lido).submit.value(address(this).balance)(address(this));}
    //   else{
    //     ICurve(curve_pool).exchange.value(address(this).balance)(0, 1, address(this).balance, 0);
    //   }
    // }
    // uint256 lido_bal = IERC20(lido).balanceOf(address(this));
    // if (IERC20(lido).allowance(address(this), aave) != 0) {IERC20(lido).safeApprove(aave, 0);}
    // IERC20(lido).safeApprove(aave, lido_bal);
    // IAAVE(aave).deposit(lido, lido_bal, address(this), 0);

    // uint256 to_repay = amount.safeAdd(fee_amount);
    // IAAVE(aave).borrow(weth, to_repay, 2, 0, address(this));
    // IERC20(weth).safeTransfer(balancer, to_repay);
  }
  function _withdraw(uint256 amount, uint256 fee_amount) internal{
    return;
    // uint256 steth_amount = amount.safeMul(IERC20(asteth).balanceOf(address(this))).safeDiv(getDebt());
    // if (IERC20(weth).allowance(address(this), aave) != 0) {IERC20(weth).safeApprove(aave, 0);}
    // IERC20(weth).safeApprove(aave, amount);

    // IAAVE(aave).repay(weth, amount, 2, address(this));
    // IAAVE(aave).withdraw(lido, steth_amount, address(this));

    // if (IERC20(lido).allowance(address(this), curve_pool) != 0) {IERC20(lido).safeApprove(curve_pool, 0);}
    // IERC20(lido).safeApprove(curve_pool, steth_amount);
    // ICurve(curve_pool).exchange(1, 0, steth_amount, 0);

    // (bool status, ) = weth.call.value(amount.safeAdd(fee_amount))("");
    // require(status, "transfer eth failed");
    // IERC20(weth).safeTransfer(balancer, amount.safeAdd(fee_amount));
  }

}

