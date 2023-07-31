// File: contracts/erc20/IERC20.sol

pragma solidity >=0.4.21 <0.6.0;

contract ExchangeBetweenPools is Ownable{

  using SafeERC20 for IERC20;
  string public note;

  IERC20 public usdt;
  IERC20 public usdc;

  address public from_bank;
  address public to_bank;

  uint256 public minimum_amount;

  // @custom:consol
  // curve.exchange_underlying(x, y, camount, n)
  //   ensures _exchange_underlying_post_condition(camount)
  PriceInterface public curve = PriceInterface(CurveInterface(0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3).curve());

  constructor(address _from_bank, address _to_bank, uint256 _min_amount) public{
    note = "Only for USDC to USDT";
    from_bank = _from_bank;
    to_bank = _to_bank;

    (address u1, string memory s1) = ERC20TokenBankInterface(from_bank).token();
    usdc = IERC20(u1);

    (u1, s1) = ERC20TokenBankInterface(to_bank).token();

    usdt = IERC20(u1);

    minimum_amount = _min_amount;
  }

  event MinimumAmountChanged(uint256 old, uint256 _new);

  function _exchange_underlying_post_condition(uint256 camount) view internal returns (bool) {
      uint256 namount = usdt.balanceOf(address(this));
      return camount * 95 / 100 < namount && camount * 100 / 95 > namount;
  }

  function changeMinimumAmount(uint256 _new_amount) public onlyOwner{
    require(_new_amount > 0, "invalid amount");
    uint256 old = minimum_amount;
    minimum_amount = _new_amount;
    emit MinimumAmountChanged(old, minimum_amount);
  }

  // @custom:consol
  // doExchange(amount) public returns (success)
  //   requires amount >= minimum_amount && amount <= ERC20TokenBankInterface(from_bank).balance()
  function doExchange(uint256 amount) public returns(bool){

    ERC20TokenBankInterface(from_bank).issue(address(this), amount);

    uint256 camount = usdc.balanceOf(address(this));
    usdc.safeApprove(address(curve), camount);
    curve.exchange_underlying(1, 2, camount, 0);

    uint256 namount = usdt.balanceOf(address(this));
    usdt.safeTransfer(to_bank, namount);

    return true;
  }

}
