contract Bean is ERC20, Pausable, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using ECDSA for bytes32;

    uint256 public constant MAX_SUPPLY = 1_000_000_000 * (10**18);

    address public signatureManager;

    // contract => tokenId => claimed
    mapping(address => mapping(uint256 => bool)) public tokenClaimed;

    // signature => claimed
    mapping(bytes => bool) public signatureClaimed;

    // contract whitelist
    mapping(address => bool) public contractSupports;

    receive() external payable {}

    constructor(
        string memory _name,
        string memory _symbol,
        address _treasury,
        address _zagabond,
        address _signatureManager,
        address[] memory _contracts
    ) ERC20(_name, _symbol) {
        _mint(address(this), MAX_SUPPLY.div(2));
        _mint(_treasury, MAX_SUPPLY.div(10).mul(4));
        _mint(_zagabond, MAX_SUPPLY.div(10).mul(1));
        signatureManager = _signatureManager;
        for (uint256 i = 0; i < _contracts.length; i++) {
            contractSupports[_contracts[i]] = true;
        }
    }

    function claim_check(
        address[] memory _contracts,      // NFT contracts: azuki + beanz + elementals
        uint256[] memory _amounts,        // token amount for every contract: 2 + 3 + 1
        uint256[] memory _tokenIds,       // all token id, tokenIds.length = sum(amounts)
        uint256 _claimAmount,
        uint256 _endTime,
        bytes memory _signature          // sender + contracts + tokenIds + claimAmount + endTime
    ) internal return (bool success) {
        if (signatureClaimed[_signature]) return false;

        if (_contracts.length != _amounts.length) return false;

        for (uint256 i = 0; i < _contracts.length; i++) {
            if (!contractSupports[_contracts[i]]) return false;
        }

        uint256 totalAmount;
        for (uint256 j = 0; j < _amounts.length; j++) {
            totalAmount = totalAmount + _amounts[j];
        }
        if (totalAmount != _tokenIds.length) return false;

        bytes32 message = keccak256(abi.encodePacked(msg.sender, _contracts, _tokenIds, _claimAmount, _endTime));
        if (signatureManager != message.toEthSignedMessageHash().recover(_signature)) return false;
        if (block.timestamp > _endTime) return false;

        return true;
    }
    
    /// @custom:consol
    /// claim(_contracts, _amounts, _tokenIds, _claimAmount, _endTime) returns ()
    ///   ensures claim_check(_contracts, _amounts, _tokenIds, _claimAmount, _endTime)
    function claim(
        address[] memory _contracts,      // NFT contracts: azuki + beanz + elementals
        uint256[] memory _amounts,        // token amount for every contract: 2 + 3 + 1
        uint256[] memory _tokenIds,       // all token id, tokenIds.length = sum(amounts)
        uint256 _claimAmount,
        uint256 _endTime,
        bytes memory _signature          // sender + contracts + tokenIds + claimAmount + endTime
    ) external whenNotPaused nonReentrant {
        __claim_pre(_contracts, _amounts, _tokenIds, _claimAmount, _endTime, _signature);
        __claim_original(_contracts, _amounts, _tokenIds, _claimAmount, _endTime, _signature);
    }

    function __claim_pre(
        address[] memory _contracts,      // NFT contracts: azuki + beanz + elementals
        uint256[] memory _amounts,        // token amount for every contract: 2 + 3 + 1
        uint256[] memory _tokenIds,       // all token id, tokenIds.length = sum(amounts)
        uint256 _claimAmount,
        uint256 _endTime,
        bytes memory _signature          // sender + contracts + tokenIds + claimAmount + endTime
    ) external whenNotPaused nonReentrant {
        require(claim_check(_contracts, _amounts, _tokenIds, _claimAmount, _endTime, _signature));
    }
    
    function __claim_original(
        address[] memory _contracts,      // NFT contracts: azuki + beanz + elementals
        uint256[] memory _amounts,        // token amount for every contract: 2 + 3 + 1
        uint256[] memory _tokenIds,       // all token id, tokenIds.length = sum(amounts)
        uint256 _claimAmount,
        uint256 _endTime,
        bytes memory _signature          // sender + contracts + tokenIds + claimAmount + endTime
    ) external whenNotPaused nonReentrant {
        // check NFT
        uint256 endIndex;
        uint256 startIndex;
        for (uint256 i = 0; i < _amounts.length; i++) {

            endIndex = startIndex + _amounts[i];

            for (uint256 j = startIndex; j < endIndex; j++) {
                address contractAddr = _contracts[i];
                uint256 tokenId = _tokenIds[j];
                require(IERC721(contractAddr).ownerOf(tokenId) == msg.sender, "not owner");
                tokenClaimed[contractAddr][tokenId] = true;
            }
            startIndex = endIndex;
        }
        signatureClaimed[_signature] = true;
        // transfer token
        _transfer(address(this), msg.sender, _claimAmount);
    }

    function setContractSupports(address[] memory _contracts, bool[] memory _enables) external onlyOwner {
        require(_contracts.length == _enables.length, "contracts length not match _enables length");
        for (uint256 i = 0; i < _contracts.length; i++) {
            contractSupports[_contracts[i]] = _enables[i];
        }
    }

    function setSignatureManager(address _signatureManager) external onlyOwner {
        signatureManager = _signatureManager;
    }

    function finish() external onlyOwner whenPaused {
        _burn(address(this), balanceOf(address(this)));
    }

    function pause() external onlyOwner whenNotPaused {
        _pause();
    }

    function unpause() external onlyOwner whenPaused {
        _unpause();
    }

    function withdraw(address _receiver, address _token, bool _isETH) external onlyOwner {
        if (_isETH) {
            payable(_receiver).transfer(address(this).balance);
        } else {
            IERC20(_token).transfer(_receiver, IERC20(_token).balanceOf(address(this)));
        }
    }

}
