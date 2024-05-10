pragma solidity ^0.5.0;

/// @title IERC165
/// dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
interface IERC165 {
    /// @notice Query if a contract implements an interface
    /// @param interfaceId The interface identifier, as specified in ERC-165
    /// dev Interface identification is specified in ERC-165. This function
    /// uses less than 30,000 gas.
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/// @title ERC721 Non-Fungible Token Standard basic interface
/// dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    uint256[] internal _allTokens;

    function balanceOf(address owner) public view returns (uint256 balance);

    function ownerOf(uint256 tokenId) public view returns (address owner);

    function approve(address to, uint256 tokenId) public;

    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;

    function isApprovedForAll(address owner, address operator) public view returns (bool);

    function transferFrom(address from, address to, uint256 tokenId) public;

    function safeTransferFrom(address from, address to, uint256 tokenId) public;

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

/// @title ERC721 token receiver interface
/// dev Interface for any contract that wants to support safeTransfers
/// from ERC721 asset contracts.
contract IERC721Receiver {
    /// @notice Handle the receipt of an NFT
    /// dev The ERC721 smart contract calls this function on the recipient
    /// after a `safeTransfer`. This function MUST return the function selector,
    /// otherwise the caller will revert the transaction. The selector to be
    /// returned can be obtained as `this.onERC721Received.selector`. This
    /// function MAY throw to revert and reject the transfer.
    /// Note: the ERC721 contract address is always the message sender.
    /// @param operator The address which called `safeTransferFrom` function
    /// @param from The address which previously owned the token
    /// @param tokenId The NFT identifier which is being transferred
    /// @param data Additional data with no specified format
    /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4);
}

/// @title SafeMath
/// dev Math operations with safety checks that revert on error
library SafeMath {
    /// dev Multiplies two numbers, reverts on overflow.
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require((c / a) == b);
        return c;
    }

    /// dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }

    /// @dev
    ///     {sub(a, b) returns (c)
    ///     requires {b <= a}}
    function sub_original(uint256 a, uint256 b) private pure returns (uint256) {
        uint256 c = a - b;
        return c;
    }

    /// @dev
    ///    { add(a, b) returns (c)
    ///     ensures {c >= a}}
    function add_original(uint256 a, uint256 b) private pure returns (uint256) {
        uint256 c = a + b;
        return c;
    }

    /// dev Divides two numbers and returns the remainder (unsigned integer modulo),
    /// reverts when dividing by zero.
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }

    function _sub_pre(uint256 a, uint256 b) private pure {
        if (!(b<=a)) revert();
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        _sub_pre(a, b);
        uint256 c = sub_original(a, b);
        return (c);
    }

    function _add_post(uint256 a, uint256 b, uint256 c) private pure {
        if (!(c>=a)) revert();
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = add_original(a, b);
        _add_post(a, b, c);
        return (c);
    }
}

/// Utility library of inline functions on addresses
library Address {
    /// Returns whether the target address is a contract
    /// dev This function will return false if invoked during the constructor of a contract,
    /// as the code is not actually created until after the constructor finishes.
    /// @param account address of the account to check
    /// @return whether the target address is a contract
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

/// @title ERC165
/// @author Matt Condon (@shrugs)
/// dev Implements ERC165 using a lookup table.
contract ERC165 is IERC165 {
    bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
    mapping(bytes4 => bool) private _supportedInterfaces;

    /// dev A contract implementing SupportsInterfaceWithLookup
    /// implement ERC165 itself
    constructor() internal {
        _registerInterface(_InterfaceId_ERC165);
    }

    /// dev implement supportsInterface(bytes4) using a lookup table
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /// dev internal method for registering an interface
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff);
        _supportedInterfaces[interfaceId] = true;
    }
}

/// @title ERC721 Non-Fungible Token Standard basic implementation
/// dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;

    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
    mapping(uint256 => address) private _tokenOwner;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => uint256) internal _ownedTokensCount;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;

    constructor() public {
        _registerInterface(_InterfaceId_ERC721);
    }

    /// dev Gets the balance of the specified address
    /// @param owner address to query the balance of
    /// @return uint256 representing the amount owned by the passed address
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0));
        return _ownedTokensCount[owner];
    }

    /// dev Gets the owner of the specified token ID
    /// @param tokenId uint256 ID of the token to query the owner of
    /// @return owner address currently marked as the owner of the given token ID
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0));
        return owner;
    }

    /// dev Approves another address to transfer the given token ID
    /// The zero address indicates there is no approved address.
    /// There can only be one approved address per token at a given time.
    /// Can only be called by the token owner or an approved operator.
    /// @param to address to be approved for the given token ID
    /// @param tokenId uint256 ID of the token to be approved
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner);
        require((msg.sender == owner) || isApprovedForAll(owner, msg.sender));
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /// dev Gets the approved address for a token ID, or zero if no address set
    /// Reverts if the token ID does not exist.
    /// @param tokenId uint256 ID of the token to query the approval of
    /// @return address currently approved for the given token ID
    function getApproved(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId));
        return _tokenApprovals[tokenId];
    }

    /// dev Sets or unsets the approval of a given operator
    /// An operator is allowed to transfer all tokens of the sender on their behalf
    /// @param to operator address to set the approval
    /// @param approved representing the status of the approval to be set
    function setApprovalForAll(address to, bool approved) public {
        require(to != msg.sender);
        _operatorApprovals[msg.sender][to] = approved;
        emit ApprovalForAll(msg.sender, to, approved);
    }

    /// dev Tells whether an operator is approved by a given owner
    /// @param owner owner address which you want to query the approval of
    /// @param operator operator address which you want to query the approval of
    /// @return bool whether the given operator is approved by the given owner
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /// @dev
    ///     {transferFrom(from, to, tokenId)
    ///     requires {_isApprovedOrOwner(msg.sender, tokenId) && to != address(0)}}
    function transferFrom_original(address from, address to, uint256 tokenId) private {
        _clearApproval(from, tokenId);
        _removeTokenFrom(from, tokenId);
        _addTokenTo(to, tokenId);
        emit Transfer(from, to, tokenId);
    }

    /// dev Safely transfers the ownership of a given token ID to another address
    /// If the target address is a contract, it must implement `onERC721Received`,
    /// which is called upon a safe transfer, and return the magic value
    /// `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
    /// the transfer is reverted.
    ///    * Requires the msg sender to be the owner, approved, or operator
    /// @param from current owner of the token
    /// @param to address to receive the ownership of the given token ID
    /// @param tokenId uint256 ID of the token to be transferred
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    /// dev Safely transfers the ownership of a given token ID to another address
    /// If the target address is a contract, it must implement `onERC721Received`,
    /// which is called upon a safe transfer, and return the magic value
    /// `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
    /// the transfer is reverted.
    /// Requires the msg sender to be the owner, approved, or operator
    /// @param from current owner of the token
    /// @param to address to receive the ownership of the given token ID
    /// @param tokenId uint256 ID of the token to be transferred
    /// @param _data bytes data to send along with a safe transfer check
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data));
    }

    /// dev Returns whether the specified token exists
    /// @param tokenId uint256 ID of the token to query the existence of
    /// @return whether the token exists
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    /// dev Returns whether the given spender can transfer a given token ID
    /// @param spender address of the spender to query
    /// @param tokenId uint256 ID of the token to be transferred
    /// @return bool whether the msg.sender is approved for the given token ID,
    ///  is an operator of the owner, or is the owner of the token
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (((spender == owner) || (getApproved(tokenId) == spender)) || isApprovedForAll(owner, spender));
    }

    /// @dev
    ///     {_mint(to, tokenId)
    ///     requires {to != address(0)}}
    function _mint_original(address to, uint256 tokenId) private {
        _addTokenTo(to, tokenId);
        emit Transfer(address(0), to, tokenId);
    }

    /// dev Internal function to burn a specific token
    /// Reverts if the token does not exist
    /// @param tokenId uint256 ID of the token being burned by the msg.sender
    function _burn(address owner, uint256 tokenId) internal {
        _clearApproval(owner, tokenId);
        _removeTokenFrom(owner, tokenId);
        emit Transfer(owner, address(0), tokenId);
    }

    /// @dev
    ///     {_addTokenTo(to, tokenId)
    ///     requires {_tokenOwner[tokenId] == address(0)}}
    function _addTokenTo_original(address to, uint256 tokenId) private {
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
    }

    /// @dev
    ///    { _removeTokenFrom(from, tokenId)
    ///     requires {ownerOf(tokenId) == from}}
    function _removeTokenFrom_original(address from, uint256 tokenId) private {
        _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
        _tokenOwner[tokenId] = address(0);
    }

    /// dev Internal function to invoke `onERC721Received` on a target address
    /// The call is not executed if the target address is not a contract
    /// @param from address representing the previous owner of the given token ID
    /// @param to target address that will receive the tokens
    /// @param tokenId uint256 ID of the token to be transferred
    /// @param _data bytes optional data to send along with the call
    /// @return whether the call correctly returned the expected magic value
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool) {
        if (!to.isContract()) {
            return true;
        }
        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }

    /// @dev
    ///    { _clearApproval(owner, tokenId)
    ///     requires {ownerOf(tokenId) == owner}}
    function _clearApproval_original(address owner, uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }

    function _transferFrom_pre(address from, address to, uint256 tokenId) private {
        if (!(_isApprovedOrOwner(msg.sender,tokenId)&&to!=address(0))) revert();
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        _transferFrom_pre(from, to, tokenId);
        transferFrom_original(from, to, tokenId);
    }

    function __mint_pre(address to, uint256 tokenId) private {
        if (!(to!=address(0))) revert();
    }

    function _mint(address to, uint256 tokenId) internal {
        __mint_pre(to, tokenId);
        _mint_original(to, tokenId);
    }

    function __addTokenTo_pre(address to, uint256 tokenId) private {
        if (!(_tokenOwnertokenId==address(0))) revert();
    }

    function _addTokenTo(address to, uint256 tokenId) internal {
        __addTokenTo_pre(to, tokenId);
        _addTokenTo_original(to, tokenId);
    }

    function __removeTokenFrom_pre(address from, uint256 tokenId) private {
        if (!(ownerOf(tokenId)==from)) revert();
    }

    function _removeTokenFrom(address from, uint256 tokenId) internal {
        __removeTokenFrom_pre(from, tokenId);
        _removeTokenFrom_original(from, tokenId);
    }

    function __clearApproval_pre(address owner, uint256 tokenId) private {
        if (!(ownerOf(tokenId)==owner)) revert();
    }

    function _clearApproval(address owner, uint256 tokenId) private {
        __clearApproval_pre(owner, tokenId);
        _clearApproval_original(owner, tokenId);
    }
}

/// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
/// dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract IERC721Enumerable is IERC721, ERC721 {
    function totalSupply() public view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) public view returns (uint256);
}

contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
    mapping(address => uint256[]) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;
    mapping(uint256 => uint256) private _allTokensIndex;
    bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;

    /// dev Constructor function
    constructor() public {
        _registerInterface(_InterfaceId_ERC721Enumerable);
    }

    /// dev Gets the token ID at a given index of the tokens list of the requested owner
    /// @param owner address owning the tokens list to be accessed
    /// @param index uint256 representing the index to be accessed of the requested tokens list
    /// @return uint256 token ID at the given index of the tokens list owned by the requested address
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < balanceOf(owner));
        return _ownedTokens[owner][index];
    }

    /// dev Gets the total amount of tokens stored by the contract
    /// @return uint256 representing the total amount of tokens
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    /// dev Gets the token ID at a given index of all the tokens in this contract
    /// Reverts if the index is greater or equal to the total number of tokens
    /// @param index uint256 representing the index to be accessed of the tokens list
    /// @return uint256 token ID at the given index of the tokens list
    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < totalSupply());
        return _allTokens[index];
    }

    /// dev Internal function to add a token ID to the list of a given address
    /// This function is internal due to language limitations, see the note in ERC721.sol.
    /// It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event.
    /// @param to address representing the new owner of the given token ID
    /// @param tokenId uint256 ID of the token to be added to the tokens list of the given address
    function _addTokenTo(address to, uint256 tokenId) internal {
        super._addTokenTo(to, tokenId);
        uint256 length = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = length;
    }

    /// dev Internal function to remove a token ID from the list of a given address
    /// This function is internal due to language limitations, see the note in ERC721.sol.
    /// It is not intended to be called by custom derived contracts: in particular, it emits no Transfer event,
    /// and doesn't clear approvals.
    /// @param from address representing the previous owner of the given token ID
    /// @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
    function _removeTokenFrom(address from, uint256 tokenId) internal {
        super._removeTokenFrom(from, tokenId);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];
        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
        uint256 lastToken = _ownedTokens[from][lastTokenIndex];
        _ownedTokens[from][tokenIndex] = lastToken;
        _ownedTokens[from].length--;
        _ownedTokensIndex[tokenId] = 0;
        _ownedTokensIndex[lastToken] = tokenIndex;
    }

    /// dev Internal function to mint a new token
    /// Reverts if the given token ID already exists
    /// @param to address the beneficiary that will own the minted token
    /// @param tokenId uint256 ID of the token to be minted by the msg.sender
    function _mint(address to, uint256 tokenId) internal {
        super._mint(to, tokenId);
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /// dev Internal function to burn a specific token
    /// Reverts if the token does not exist
    /// @param owner owner of the token to burn
    /// @param tokenId uint256 ID of the token being burned by the msg.sender
    function _burn(address owner, uint256 tokenId) internal {
        super._burn(owner, tokenId);
        uint256 tokenIndex = _allTokensIndex[tokenId];
        uint256 lastTokenIndex = _allTokens.length.sub(1);
        uint256 lastToken = _allTokens[lastTokenIndex];
        _allTokens[tokenIndex] = lastToken;
        _allTokens[lastTokenIndex] = 0;
        _allTokens.length--;
        _allTokensIndex[tokenId] = 0;
        _allTokensIndex[lastToken] = tokenIndex;
    }
}

/// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
/// dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract IERC721Metadata is IERC721 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);
}

contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
    string private _name;
    string private _symbol;
    mapping(uint256 => string) private _tokenURIs;
    bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;

    /// dev Constructor function
    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _registerInterface(InterfaceId_ERC721Metadata);
    }

    /// dev Gets the token name
    /// @return string representing the token name
    function name() external view returns (string memory) {
        return _name;
    }

    /// dev Gets the token symbol
    /// @return string representing the token symbol
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /// dev Returns an URI for a given token ID
    /// Throws if the token ID does not exist. May return an empty string.
    /// @param tokenId uint256 ID of the token to query
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId));
        return _tokenURIs[tokenId];
    }

    /// dev Internal function to set the token URI for a given token
    /// Reverts if the token ID does not exist
    /// @param tokenId uint256 ID of the token to set its URI
    /// @param uri string URI to assign
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_exists(tokenId));
        _tokenURIs[tokenId] = uri;
    }

    /// dev Internal function to burn a specific token
    /// Reverts if the token does not exist
    /// @param owner owner of the token to burn
    /// @param tokenId uint256 ID of the token being burned by the msg.sender
    function _burn(address owner, uint256 tokenId) internal {
        super._burn(owner, tokenId);
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}

/// @title Full ERC721 Token
/// This implementation includes all the required and some optional functionality of the ERC721 standard
/// Moreover, it includes approve all functionality using operator terminology
/// dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
    constructor(string memory name, string memory symbol) public ERC721Metadata(name,symbol) {}
}

contract Landemic is ERC721Full("Landemic", "LAND") {
    struct Price {
        uint240 lastPrice;
        uint16 multiple;
    }

    uint256 public _basePrice = 810000000000000;
    uint8 public _bountyDivisor = 20;
    uint16 public _defaultMultiple = 100;
    address public _owner = msg.sender;
    string public _baseURL = "https://landemic.io/";
    mapping(uint256 => Price) public _prices;
    mapping(address => uint256) public failedPayouts;
    uint256 public failedPayoutsSum;
    bytes20 internal constant DIGITS = bytes20("23456789CFGHJMPQRVWX");
    bytes20 internal constant STIGID = bytes20("XWVRQPMJHGFC98765432");

    modifier onlyContractOwner() {
        require(msg.sender == _owner);
        _;
    }

    modifier onlyTokenOwner(uint256 tokenId) {
        require(msg.sender == ownerOf(tokenId));
        _;
    }

    constructor() public {}

    function _lastPrice(uint256 tokenId) public view returns (uint256) {
        return uint256(_prices[tokenId].lastPrice);
    }

    function _multiple(uint256 tokenId) public view returns (uint16) {
        return _prices[tokenId].multiple;
    }

    function setBasePrice(uint256 basePrice) public onlyContractOwner() {
        _basePrice = basePrice;
    }

    function setBountyDivisor(uint8 bountyDivisor) public onlyContractOwner() {
        _bountyDivisor = bountyDivisor;
    }

    function setBaseURL(string memory baseURL) public onlyContractOwner() {
        _baseURL = baseURL;
    }

    function setOwner(address owner) public onlyContractOwner() {
        _owner = owner;
    }

    function withdraw(uint256 amount) public onlyContractOwner() {
        msg.sender.transfer(amount);
    }

    function withdrawProfit() public onlyContractOwner() {
        msg.sender.transfer(address(this).balance.sub(failedPayoutsSum));
    }

    function getAllOwned() public view returns (uint256[] memory, address[] memory) {
        uint totalOwned = totalSupply();
        uint256[] memory ownedUint256 = new uint256[](totalOwned);
        address[] memory ownersAddress = new address[](totalOwned);
        for (uint i = 0; i < totalOwned; i++) {
            ownedUint256[i] = tokenByIndex(i);
            ownersAddress[i] = ownerOf(ownedUint256[i]);
        }
        return (ownedUint256, ownersAddress);
    }

    function metadataForToken(uint256 tokenId) public view returns (uint256, address, uint16, uint256) {
        uint256 price = priceOf(tokenId);
        if (_exists(tokenId)) {
            return (_lastPrice(tokenId), ownerOf(tokenId), multipleOf(tokenId), price);
        }
        return (_basePrice, address(0), uint16(10), price);
    }

    function priceOf(uint256 tokenId) public view returns (uint256) {
        if (_exists(tokenId)) {
            return _lastPrice(tokenId).mul(uint256(multipleOf(tokenId))).div(10);
        }
        return _basePrice;
    }

    function multipleOf(uint256 tokenId) public view returns (uint16) {
        uint16 multiple = _multiple(tokenId);
        if (multiple > 0) {
            return multiple;
        }
        return _defaultMultiple;
    }

    function setMultiple(uint256 tokenId, uint16 multiple) public onlyTokenOwner(tokenId) {
        require((multiple >= 1) && (multiple <= 1000));
        _prices[tokenId].multiple = multiple;
    }

    function mint(address _to, uint256 _tokenId) public {
        _mint(_to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public {
        safeTransferFrom(msg.sender, _to, _tokenId);
    }

    function grabCode(uint256 tokenId) public payable {
        uint256 price = priceOf(tokenId);
        require(msg.value >= price);
        _prices[tokenId] = Price(uint240(msg.value), uint16(0));
        if (!_exists(tokenId)) {
            _mint(msg.sender, tokenId);
            return;
        }
        address owner = ownerOf(tokenId);
        require(owner != msg.sender);
        _burn(owner, tokenId);
        _mint(msg.sender, tokenId);
        uint256 bounty = msg.value.div(_bountyDivisor);
        uint256 bountiesCount = 1;
        uint256[4] memory neighbors;
        for (uint i = 0; i < 4; i++) {
            uint256 neighbor = neighbors[i];
            if (!_exists(neighbor)) {
                continue;
            }
            bountiesCount++;
        }
    }

    function pullBounty(address to) public {
        uint256 bounty = failedPayouts[msg.sender];
        if (bounty == 0) {
            return;
        }
        failedPayouts[msg.sender] = 0;
        failedPayoutsSum = failedPayoutsSum.sub(bounty);
    }

    /// dev Returns an URI for a given token ID
    /// dev Throws if the token ID does not exist. May return an empty string.
    /// @param _tokenId uint256 ID of the token to query
    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        require(_exists(_tokenId));
        return strConcat(strConcat(_baseURL, uint256ToString(_tokenId)), ".json");
    }

    function uint256ToString(uint256 y) private pure returns (string memory) {
        bytes32 x = bytes32(y);
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * (2 ** (8 * j))));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (uint j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory testEmptyStringTest = bytes(source);
        if (testEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
    result := mload(add(source, 32))
}
    }

    function strConcat(string memory _a, string memory _b) private pure returns (string memory) {
        bytes memory bytes_a = bytes(_a);
        bytes memory bytes_b = bytes(_b);
        string memory ab = new string(bytes_a.length + bytes_b.length);
        bytes memory bytes_ab = bytes(ab);
        uint k = 0;
        for (uint i = 0; i < bytes_a.length; i++) bytes_ab[k++] = bytes_a[i];
        for (uint i = 0; i < bytes_b.length; i++) bytes_ab[k++] = bytes_b[i];
        return string(bytes_ab);
    }

    function nextChar(byte c, bytes20 digits) private pure returns (byte) {
        for (uint i = 0; i < 20; i++) if (c == digits[i]) return (i == 19) ? digits[0] : digits[i + 1];
    }
}