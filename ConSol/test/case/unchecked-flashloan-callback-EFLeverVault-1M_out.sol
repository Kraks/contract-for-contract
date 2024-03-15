pragma solidity 0.8.10;

contract EFLeverVault {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    uint128 internal _entered;
    uint256 public constant ratio_base = 10000;
    uint256 public mlr;
    address payable public fee_pool;
    address public ef_token;
    uint256 public last_earn_block;
    uint256 public block_rate;
    uint256 internal last_volume;
    address public aave = address(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
    address public balancer = address(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
    address public balancer_fee = address(0xce88686553686DA562CE7Cea497CE749DA109f9F);
    address public lido = address(0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84);
    address public asteth = address(0x1982b2F5814301d4e9a8b0201555376e62F82428);
    address public curve_pool = address(0xDC24316b9AE028F1497c275EB9192a3Ea0f67022);
    address public weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    bool public is_paused;

    constructor(address _ef_token) {
        ef_token = _ef_token;
        mlr = 6750;
        last_earn_block = block.number;
    }

    /// @custom:consol {receiveFlashLoan(tokens, amounts, feeAmounts, userData) returns () requires {_entered == 1 && msg.sender == balancer}}
    function receiveFlashLoan_original(uint256[] memory tokens, uint256[] memory amounts, uint256[] memory feeAmounts, bytes memory userData) private payable {
        uint256 loan_amount = amounts[0];
        uint256 fee_amount = feeAmounts[0];
        if (keccak256(userData) == keccak256("0x1")) {
            _deposit(loan_amount, fee_amount);
        }
        if (keccak256(userData) == keccak256("0x2")) {
            _withdraw(loan_amount, fee_amount);
        }
    }

    function _deposit(uint256 amount, uint256 fee_amount) internal {
        return;
    }

    function _withdraw(uint256 amount, uint256 fee_amount) internal {
        return;
    }

    function _receiveFlashLoan_pre(uint256[] memory tokens, uint256[] memory amounts, uint256[] memory feeAmounts, bytes memory userData) private {
        if (!(_entered==1&&msg.sender==balancer)) revert preViolation("receiveFlashLoan");
    }

    function receiveFlashLoan(uint256[] memory tokens, uint256[] memory amounts, uint256[] memory feeAmounts, bytes memory userData) public payable {
        _receiveFlashLoan_pre(tokens, amounts, feeAmounts, userData);
        receiveFlashLoan_original(tokens, amounts, feeAmounts, userData);
    }
}