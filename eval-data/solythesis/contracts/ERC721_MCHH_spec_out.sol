pragma solidity ^0.5.0;

/// @title Roles
/// dev Library for managing addresses assigned to a Role.
library Roles {
    struct Role {
        mapping(address => bool) bearer;
    }

    /// dev give an account access to this role
    function add(Role storage role, address account) internal {
        require(account != address(0));
        role.bearer[account] = true;
    }

    /// dev remove an account's access to this role
    function remove(Role storage role, address account) internal {
        require(account != address(0));
        role.bearer[account] = false;
    }

    /// dev check if an account has this role
    /// @return bool
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0));
        return role.bearer[account];
    }
}

contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);

    event MinterRemoved(address indexed account);

    Roles.Role private minters;

    modifier onlyMinter() {
        require(isMinter(msg.sender));
        _;
    }

    constructor() public {
        minters.add(msg.sender);
    }

    function isMinter(address account) public view returns (bool) {
        return minters.has(account);
    }

    function addMinter(address account) public onlyMinter() {
        minters.add(account);
        emit MinterAdded(account);
    }

    function renounceMinter() public {
        minters.remove(msg.sender);
    }

    function _removeMinter(address account) internal {
        minters.remove(account);
        emit MinterRemoved(account);
    }
}

/// @title IERC165
/// dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
interface IERC165 {
    /// @notice Query if a contract implements an interface
    /// @param interfaceId The interface identifier, as specified in ERC-165
    /// dev Interface identification is specified in ERC-165. This function
    /// uses less than 30,000 gas.
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/// @title ERC165
/// @author Matt Condon (@shrugs)
/// dev Implements ERC165 using a lookup table.
contract ERC165 is IERC165 {
    bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
    mapping(bytes4 => bool) internal _supportedInterfaces;

    /// dev A contract implementing SupportsInterfaceWithLookup
    /// implement ERC165 itself
    constructor() public {
        _registerInterface(_InterfaceId_ERC165);
    }

    /// dev implement supportsInterface(bytes4) using a lookup table
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /// dev private method for registering an interface
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff);
        _supportedInterfaces[interfaceId] = true;
    }
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
    function sub_original(uint256 a, uint256 b) private returns (uint256) {
        uint256 c = a - b;
        return c;
    }

    /// @dev
    ///     {add(a, b) returns (c)
    ///     ensures {c >= a}}
    function add_original(uint256 a, uint256 b) private returns (uint256) {
        uint256 c = a + b;
        return c;
    }

    /// dev Divides two numbers and returns the remainder (unsigned integer modulo),
    /// reverts when dividing by zero.
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }

    function _sub_pre(uint256 a, uint256 b) private {
        if (!(b<=a)) revert();
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        _sub_pre(a, b);
        uint256 c = sub_original(a, b);
        return (c);
    }

    function _add_post(uint256 a, uint256 b, uint256 c) private {
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

/// @title ERC721 Non-Fungible Token Standard basic implementation
/// dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;

    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
    mapping(uint256 => address) internal _tokenOwner;
    mapping(uint256 => address) internal _tokenApprovals;
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
        require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
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
    ///     {_clearApproval(owner, tokenId)
    ///     requires {ownerOf(tokenId) == owner}}
    function _clearApproval_original(address owner, uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }

    /// dev Internal function to add a token ID to the list of a given address
    /// @param to address representing the new owner of the given token ID
    /// @param tokenId uint256 ID of the token to be added to the tokens list of the given address
    function _addTokenTo(address to, uint256 tokenId) internal {
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
    }

    /// dev Internal function to remove a token ID from the list of a given address
    /// @param from address representing the previous owner of the given token ID
    /// @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
    function _removeTokenFrom(address from, uint256 tokenId) internal {
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
    function _checkAndCallSafeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool) {
        if (!to.isContract()) {
            return true;
        }
        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
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

    function __clearApproval_pre(address owner, uint256 tokenId) private {
        if (!(ownerOf(tokenId)==owner)) revert();
    }

    function _clearApproval(address owner, uint256 tokenId) internal {
        __clearApproval_pre(owner, tokenId);
        _clearApproval_original(owner, tokenId);
    }
}

/// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
/// dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract IERC721Enumerable is IERC721 {
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
    /// @param to address representing the new owner of the given token ID
    /// @param tokenId uint256 ID of the token to be added to the tokens list of the given address
    function _addTokenTo(address to, uint256 tokenId) internal {
        super._addTokenTo(to, tokenId);
        uint256 length = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = length;
    }

    /// dev Internal function to remove a token ID from the list of a given address
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

    function tokenURI(uint256 tokenId) public view returns (string memory);
}

contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
    string internal _name;
    string internal _symbol;
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
    function tokenURI(uint256 tokenId) public view returns (string memory) {
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

/// @title ERC721Mintable
/// dev ERC721 minting logic
contract ERC721Mintable is ERC721Full, MinterRole {
    event MintingFinished();

    bool private _mintingFinished = false;

    modifier onlyBeforeMintingFinished() {
        require(!_mintingFinished);
        _;
    }

    /// @return true if the minting is finished.
    function mintingFinished() public view returns (bool) {
        return _mintingFinished;
    }

    /// dev Function to mint tokens
    /// @param to The address that will receive the minted tokens.
    /// @param tokenId The token id to mint.
    /// @return A boolean that indicates if the operation was successful.
    function mint(address to, uint256 tokenId) public onlyMinter() onlyBeforeMintingFinished() returns (bool) {
        _mint(to, tokenId);
        return true;
    }

    function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter() onlyBeforeMintingFinished() returns (bool) {
        mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return true;
    }

    /// dev Function to stop minting new tokens.
    /// @return True if the operation was successful.
    function finishMinting() public onlyMinter() onlyBeforeMintingFinished() returns (bool) {
        _mintingFinished = true;
        emit MintingFinished();
        return true;
    }
}

contract PauserRole {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);

    event PauserRemoved(address indexed account);

    Roles.Role private pausers;

    modifier onlyPauser() {
        require(isPauser(msg.sender));
        _;
    }

    constructor() public {
        pausers.add(msg.sender);
    }

    function isPauser(address account) public view returns (bool) {
        return pausers.has(account);
    }

    function addPauser(address account) public onlyPauser() {
        pausers.add(account);
        emit PauserAdded(account);
    }

    function renouncePauser() public {
        pausers.remove(msg.sender);
    }

    function _removePauser(address account) internal {
        pausers.remove(account);
        emit PauserRemoved(account);
    }
}

/// @title Pausable
/// dev Base contract which allows children to implement an emergency stop mechanism.
contract Pausable is PauserRole {
    event Paused();

    event Unpaused();

    bool private _paused = false;

    /// dev Modifier to make a function callable only when the contract is not paused.
    modifier whenNotPaused() {
        require(!_paused);
        _;
    }

    /// dev Modifier to make a function callable only when the contract is paused.
    modifier whenPaused() {
        require(_paused);
        _;
    }

    /// @return true if the contract is paused, false otherwise.
    function paused() public view returns (bool) {
        return _paused;
    }

    /// dev called by the owner to pause, triggers stopped state
    function pause() public onlyPauser() whenNotPaused() {
        _paused = true;
        emit Paused();
    }

    /// dev called by the owner to unpause, returns to normal state
    function unpause() public onlyPauser() whenPaused() {
        _paused = false;
        emit Unpaused();
    }
}

/// @title ERC721 Non-Fungible Pausable token
/// dev ERC721 modified with pausable transfers.*
contract ERC721Pausable is ERC721, Pausable {
    function approve(address to, uint256 tokenId) public whenNotPaused() {
        super.approve(to, tokenId);
    }

    function setApprovalForAll(address to, bool approved) public whenNotPaused() {
        super.setApprovalForAll(to, approved);
    }

    function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused() {
        super.transferFrom(from, to, tokenId);
    }
}

contract HeroAsset is ERC721Full, ERC721Mintable, ERC721Pausable {
    uint16 public constant HERO_TYPE_OFFSET = 10000;
    string public tokenURIPrefix = "https://www.mycryptoheroes.net/metadata/hero/";
    mapping(uint16 => uint16) private heroTypeToSupplyLimit;

    constructor() public ERC721Full("MyCryptoHeroes:Hero","MCHH") {}

    function setSupplyLimit(uint16 _heroType, uint16 _supplyLimit) external onlyMinter() {
        require((heroTypeToSupplyLimit[_heroType] == 0) || (_supplyLimit < heroTypeToSupplyLimit[_heroType]), "_supplyLimit is bigger");
        heroTypeToSupplyLimit[_heroType] = _supplyLimit;
    }

    function setTokenURIPrefix(string memory _tokenURIPrefix) public onlyMinter() {
        tokenURIPrefix = _tokenURIPrefix;
    }

    function getSupplyLimit(uint16 _heroType) public view returns (uint16) {
        return heroTypeToSupplyLimit[_heroType];
    }

    function mintHeroAsset(address _owner, uint256 _tokenId) public onlyMinter() {
        uint16 _heroType = uint16(_tokenId / HERO_TYPE_OFFSET);
        uint16 _heroTypeIndex = uint16(_tokenId % HERO_TYPE_OFFSET) - 1;
        require(_heroTypeIndex < heroTypeToSupplyLimit[_heroType], "supply over");
        _mint(_owner, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public {
        safeTransferFrom(msg.sender, _to, _tokenId);
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        bytes32 tokenIdBytes;
        if (tokenId == 0) {
            tokenIdBytes = "0";
        } else {
            uint256 value = tokenId;
            while (value > 0) {
                tokenIdBytes = bytes32(uint256(tokenIdBytes) / (2 ** 8));
                tokenIdBytes |= bytes32(((value % 10) + 48) * (2 ** (8 * 31)));
                value /= 10;
            }
        }
        bytes memory prefixBytes = bytes(tokenURIPrefix);
        bytes memory tokenURIBytes = new bytes(prefixBytes.length + tokenIdBytes.length);
        uint8 i;
        uint8 index = 0;
        for (i = 0; i < prefixBytes.length; i++) {
            tokenURIBytes[index] = prefixBytes[i];
            index++;
        }
        for (i = 0; i < tokenIdBytes.length; i++) {
            tokenURIBytes[index] = tokenIdBytes[i];
            index++;
        }
        return string(tokenURIBytes);
    }
}