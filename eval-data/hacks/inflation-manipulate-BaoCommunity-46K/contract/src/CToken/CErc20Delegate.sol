import "./CErc20.sol";

pragma solidity ^0.5.16;

/**
 * @title Compound's CErc20Delegate Contract
 * @notice CTokens which wrap an EIP-20 underlying and are delegated to
 * @author Compound
 */
contract CErc20Delegate is CErc20, CDelegateInterface {
    /**
     * @notice Construct an empty delegate
     */
    constructor() public {}

    /**
     * @notice Called by the delegator on a delegate to initialize it for duty
     * @param data The encoded bytes data for any initialization
     */
    function _becomeImplementation(bytes memory data) public {
        // Shh -- currently unused
        data;

        // Shh -- we don't ever want this hook to be marked pure
        if (false) {
            implementation = address(0);
        }

        require(msg.sender == admin, "only the admin may call _becomeImplementation");
    }

    /**
     * @notice Called by the delegator on a delegate to forfeit its responsibility
     */
    function _resignImplementation() public {
        // Shh -- we don't ever want this hook to be marked pure
        if (false) {
            implementation = address(0);
        }

        require(msg.sender == admin, "only the admin may call _resignImplementation");
    }

    /**
     * @notice Only used when wanting to change the initial exchange rate without re-deploying the contracts
     * Will not have an effect after the cERC20 contract is in use
     */
    function _setInitialExchangeRate(uint _newInitialExchangeRateMantissa) external {
        require(msg.sender == admin, "only the admin may call _setInitialExchangeRate");

        initialExchangeRateMantissa = _newInitialExchangeRateMantissa;
    }
}