pragma solidity ^0.5.0;

library Address {
    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}

contract Ownable {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function setOwner(address _owner) public onlyOwner() {
        owner = _owner;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert((c / a) == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /// @dev 
    ///   {sub(a, b) returns (c)
    ///   requires {b <= a}}
    function sub_original(uint256 a, uint256 b) private returns (uint256) {
        return a - b;
    }

    /// @dev
    ///   {add(a, b) returns (c)
    ///   ensures {c >= a}}
    function add_original(uint256 a, uint256 b) private returns (uint256 c) {
        c = a + b;
        return c;
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

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        uint256 c = add_original(a, b);
        _add_post(a, b, c);
        return (c);
    }
}

library Strings {
    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string((((_ba.length + _bb.length) + _bc.length) + _bd.length) + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
        return strConcat(_a, _b, "", "", "");
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }
}

interface IERC165 {
    /// @notice Query if a contract implements an interface
    /// @param _interfaceId The interface identifier, as specified in ERC-165
    /// dev Interface identification is specified in ERC-165. This function
    /// uses less than 30,000 gas.
    function supportsInterface(bytes4 _interfaceId) external view returns (bool);
}

contract IERC721Receiver {
    bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

    /// @notice Handle the receipt of an NFT
    /// dev The ERC721 smart contract calls this function on the recipient
    /// after a `safetransfer`. This function MAY throw to revert and reject the
    /// transfer. Return of other than the magic value MUST result in the
    /// transaction being reverted.
    /// Note: the contract address is always the message sender.
    /// @param _operator The address which called `safeTransferFrom` function
    /// @param _from The address which previously owned the token
    /// @param _tokenId The NFT identifier which is being transfered
    /// @param _data Additional data with no specified format
    /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) public returns (bytes4);
}

contract IERC721Holder is IERC721Receiver {
    function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
        return ERC721_RECEIVED;
    }
}

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

contract IERC721Enumerable is IERC721 {
    function totalSupply() public view returns (uint256);

    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);

    function tokenByIndex(uint256 _index) public view returns (uint256);
}

contract IERC721Metadata is IERC721 {
    function name() external view returns (string memory _name);

    function symbol() external view returns (string memory _symbol);

    function tokenURI(uint256 _tokenId) public view returns (string memory);
}

contract SupportsInterfaceWithLookup is IERC165 {
    bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
    mapping(bytes4 => bool) internal supportedInterfaces;

    /// dev A contract implementing SupportsInterfaceWithLookup
    /// implement ERC165 itself
    constructor() public {
        _registerInterface(InterfaceId_ERC165);
    }

    /// dev implement supportsInterface(bytes4) using a lookup table
    function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
        return supportedInterfaces[_interfaceId];
    }

    /// dev private method for registering an interface
    function _registerInterface(bytes4 _interfaceId) internal {
        require(_interfaceId != 0xffffffff);
        supportedInterfaces[_interfaceId] = true;
    }
}

contract Delegate {
    function mint(address _sender, address _to) public returns (bool);

    function approve(address _sender, address _to, uint256 _tokenId) public returns (bool);

    function setApprovalForAll(address _sender, address _operator, bool _approved) public returns (bool);

    function transferFrom(address _sender, address _from, address _to, uint256 _tokenId) public returns (bool);

    function safeTransferFrom(address _sender, address _from, address _to, uint256 _tokenId) public returns (bool);

    function safeTransferFrom(address _sender, address _from, address _to, uint256 _tokenId, bytes memory _data) public returns (bool);
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
    ///   {transferFrom(from, to, tokenId)
    ///   requires {_isApprovedOrOwner(msg.sender, tokenId) && to != address(0)}}
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
    ///     * Requires the msg sender to be the owner, approved, or operator
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
    ///   {_mint(to, tokenId)
    ///   requires {to != address(0)}}
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
    ///   {_clearApproval(owner, tokenId)
    ///   requires {ownerOf(tokenId) == owner}}
    function _clearApproval_original(address owner, uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }

    /// @dev
    ///   {_addTokenTo(to, tokenId)
    ///   requires {_tokenOwner[tokenId] == address(0)}}
    function _addTokenTo_original(address to, uint256 tokenId) private {
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
    }

    /// @dev
    ///  { _removeTokenFrom(from, tokenId)
    ///   requires {ownerOf(tokenId) == from}}
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

contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
    constructor(string memory name, string memory symbol) public ERC721Metadata(name,symbol) {}
}

contract Collectables is ERC721Full("GU Collectable", "TRINKET"), Ownable {
    using Strings for string;

    event DelegateAdded(address indexed delegate, uint32 indexed delegateID);

    mapping(uint32 => address) public delegates;
    uint32[] public collectables;
    uint public delegateCount;
    string public constant tokenMetadataBaseURI = "https://api.godsunchained.com/collectable/";

    constructor() public {}

    function addDelegate(address delegate) public onlyOwner() {
        uint32 delegateID = uint32(delegateCount++);
        require(delegates[delegateID] == address(0), "delegate is already set for collectable type");
        delegates[delegateID] = delegate;
        emit DelegateAdded(delegate, delegateID);
    }

    function mint_d(uint32 delegateID, address to) public returns (uint) {
        Delegate delegate = getDelegate(delegateID);
        require(delegate.mint(msg.sender, to), "delegate could not mint token");
        uint id = collectables.push(delegateID) - 1;
        super._mint(to, id);
        return id;
    }

    function mint(address to, uint256 id) public returns (uint) {
        super._mint(to, id);
        return id;
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        super.transferFrom(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) public {
        Delegate delegate = getTokenDelegate(tokenId);
        require(delegate.approve(msg.sender, to, tokenId), "could not approve token");
        super.approve(to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
        Delegate delegate = getTokenDelegate(tokenId);
        require(delegate.safeTransferFrom(msg.sender, from, to, tokenId, data), "could not safe transfer token");
        super.safeTransferFrom(from, to, tokenId, data);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        Delegate delegate = getTokenDelegate(tokenId);
        require(delegate.safeTransferFrom(msg.sender, from, to, tokenId), "could not safe transfer token");
        super.safeTransferFrom(from, to, tokenId);
    }

    function getTokenDelegate(uint id) public view returns (Delegate) {
        address d = delegates[collectables[id]];
        require(d != address(0), "invalid delegate");
        return Delegate(d);
    }

    function getDelegate(uint32 id) public view returns (Delegate) {
        address d = delegates[id];
        require(d != address(0), "invalid delegate");
        return Delegate(d);
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        require(_exists(_tokenId), "token doesn't exist");
        return Strings.strConcat(tokenMetadataBaseURI, Strings.uint2str(_tokenId));
    }
}