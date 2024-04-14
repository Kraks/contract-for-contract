pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
pragma solidity ^0.5.0;
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
/// dev Unsigned math operations with safety checks that revert on error
library SafeMath {
    /// @dev
    ///   {mul(a, b) returns (c)
    ///   ensures {c / a == b}}
    function mul_original(uint256 a, uint256 b) private returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        return c;
    }

    /// @dev
    ///   {div(a, b) returns (c)
    ///   requires{ b > 0}}
    function div_original(uint256 a, uint256 b) private returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    /// @dev
    ///   {sub(a, b) returns (c)
    ///   requires {b <= a}}
    function sub_original(uint256 a, uint256 b) private returns (uint256) {
        uint256 c = a - b;
        return c;
    }

    /// @dev
    ///   {add(a, b) returns (c)
    ///   ensures {c >= a}}
    function add_original(uint256 a, uint256 b) private returns (uint256) {
        uint256 c = a + b;
        return c;
    }

    /// @dev
    ///   {mod(a, b) returns (c)
    ///   requires {b != 0}}
    function mod_original(uint256 a, uint256 b) private returns (uint256) {
        return a % b;
    }

    function _mul_post(uint256 a, uint256 b, uint256 c) private {
        if (!(c/a==b)) revert();
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = mul_original(a, b);
        _mul_post(a, b, c);
        return (c);
    }

    function _div_pre(uint256 a, uint256 b) private {
        if (!(b>0)) revert();
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        _div_pre(a, b);
        uint256 c = div_original(a, b);
        return (c);
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

    function _mod_pre(uint256 a, uint256 b) private {
        if (!(b!=0)) revert();
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        _mod_pre(a, b);
        uint256 c = mod_original(a, b);
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
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    mapping(bytes4 => bool) private _supportedInterfaces;

    /// dev A contract implementing SupportsInterfaceWithLookup
    /// implement ERC165 itself
    constructor() internal {
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /// dev implement supportsInterface(bytes4) using a lookup table
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /// @dev
    ///   {_registerInterface(interfaceId)
    ///   requires {interfaceId != 0xffffffff}}
    function _registerInterface_original(bytes4 interfaceId) private {
        _supportedInterfaces[interfaceId] = true;
    }

    function __registerInterface_pre(bytes4 interfaceId) private {
        if (!(interfaceId!=0xffffffff)) revert();
    }

    function _registerInterface(bytes4 interfaceId) internal {
        __registerInterface_pre(interfaceId);
        _registerInterface_original(interfaceId);
    }
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
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    constructor() public {
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    /// @dev
    ///   {balanceOf(owner) returns (c)
    ///   requires {owner != address(0)}}
    function balanceOf_original(address owner) private returns (uint256) {
        return _ownedTokensCount[owner];
    }

    /// @dev
    ///   {ownerOf(tokenId) returns (owner)
    ///   ensures {owner != address(0)}}
    function ownerOf_original(uint256 tokenId) private returns (address) {
        address owner = _tokenOwner[tokenId];
        return owner;
    }

    /// @dev
    ///   {approve(to, tokenId)
    ///   requires {ownerOf(tokenId) != to && (msg.sender == ownerOf(tokenId) || isApprovedForAll(ownerOf(tokenId), msg.sender))}}
    function approve_original(address to, uint256 tokenId) private {
        address owner = ownerOf(tokenId);
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /// @dev
    ///   {getApproved(tokenId) returns (approved)
    ///   requires {_exists(tokenId)}}
    function getApproved_original(uint256 tokenId) private returns (address) {
        return _tokenApprovals[tokenId];
    }

    /// @dev
    ///   {setApprovalForAll(to, approved)
    ///   requires {to != msg.sender}}
    function setApprovalForAll_original(address to, bool approved) private {
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
    ///   requires{ _isApprovedOrOwner(msg.sender, tokenId)}}
    function transferFrom_original(address from, address to, uint256 tokenId) private {
        _transferFrom(from, to, tokenId);
    }

    /// dev Safely transfers the ownership of a given token ID to another address
    /// If the target address is a contract, it must implement `onERC721Received`,
    /// which is called upon a safe transfer, and return the magic value
    /// `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
    /// the transfer is reverted.
    ///      * Requires the msg sender to be the owner, approved, or operator
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
    ///    is an operator of the owner, or is the owner of the token
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (((spender == owner) || (getApproved(tokenId) == spender)) || isApprovedForAll(owner, spender));
    }

    /// @dev
    ///   {_mint(to, tokenId)
    ///   requires {to != address(0) && !_exists(tokenId)}}
    function _mint_original(address to, uint256 tokenId) private {
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
        emit Transfer(address(0), to, tokenId);
    }

    /// @dev
    ///   {_burn(owner, tokenId)
    ///   requires {ownerOf(tokenId) == owner}}
    function _burn_original(address owner, uint256 tokenId) private {
        _clearApproval(tokenId);
        _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
        _tokenOwner[tokenId] = address(0);
        emit Transfer(owner, address(0), tokenId);
    }

    /// dev Internal function to burn a specific token
    /// Reverts if the token does not exist
    /// @param tokenId uint256 ID of the token being burned
    function _burn(uint256 tokenId) internal {
        _burn(ownerOf(tokenId), tokenId);
    }

    /// @dev
    ///   {_transferFrom(from, to, tokenId)
    ///   requires {ownerOf(tokenId) == from && to != address(0)}}
    function _transferFrom_original(address from, address to, uint256 tokenId) private {
        _clearApproval(tokenId);
        _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
        _tokenOwner[tokenId] = to;
        emit Transfer(from, to, tokenId);
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

    /// dev Private function to clear current approval of a given token ID
    /// @param tokenId uint256 ID of the token to be transferred
    function _clearApproval(uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }

    function _balanceOf_pre(address owner) private {
        if (!(owner!=address(0))) revert();
    }

    function balanceOf(address owner) public view returns (uint256) {
        _balanceOf_pre(owner);
        uint256 c = balanceOf_original(owner);
        return (c);
    }

    function _ownerOf_post(uint256 tokenId, address owner) private {
        if (!(owner!=address(0))) revert();
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = ownerOf_original(tokenId);
        _ownerOf_post(tokenId, owner);
        return (owner);
    }

    function _approve_pre(address to, uint256 tokenId) private {
        if (!(ownerOf(tokenId)!=to&&(msg.sender==ownerOf(tokenId)||isApprovedForAll(ownerOf(tokenId),msg.sender)))) revert();
    }

    function approve(address to, uint256 tokenId) public {
        _approve_pre(to, tokenId);
        approve_original(to, tokenId);
    }

    function _getApproved_pre(uint256 tokenId) private {
        if (!(_exists(tokenId))) revert();
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        _getApproved_pre(tokenId);
        address approved = getApproved_original(tokenId);
        return (approved);
    }

    function _setApprovalForAll_pre(address to, bool approved) private {
        if (!(to!=msg.sender)) revert();
    }

    function setApprovalForAll(address to, bool approved) public {
        _setApprovalForAll_pre(to, approved);
        setApprovalForAll_original(to, approved);
    }

    function _transferFrom_pre(address from, address to, uint256 tokenId) private {
        if (!(_isApprovedOrOwner(msg.sender,tokenId))) revert();
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        _transferFrom_pre(from, to, tokenId);
        transferFrom_original(from, to, tokenId);
    }

    function __mint_pre(address to, uint256 tokenId) private {
        if (!(to!=address(0)&&!_exists(tokenId))) revert();
    }

    function _mint(address to, uint256 tokenId) internal {
        __mint_pre(to, tokenId);
        _mint_original(to, tokenId);
    }

    function __burn_pre(address owner, uint256 tokenId) private {
        if (!(ownerOf(tokenId)==owner)) revert();
    }

    function _burn(address owner, uint256 tokenId) internal {
        __burn_pre(owner, tokenId);
        _burn_original(owner, tokenId);
    }

    function __transferFrom_pre(address from, address to, uint256 tokenId) private {
        if (!(ownerOf(tokenId)==from&&to!=address(0))) revert();
    }

    function _transferFrom(address from, address to, uint256 tokenId) internal {
        __transferFrom_pre(from, to, tokenId);
        _transferFrom_original(from, to, tokenId);
    }
}

/// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
/// dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract IERC721Enumerable is IERC721 {
    function totalSupply() public view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) public view returns (uint256);
}

/// @title ERC-721 Non-Fungible Token with optional enumeration extension logic
/// dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
    mapping(address => uint256[]) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;
    mapping(uint256 => uint256) private _allTokensIndex;
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    /// dev Constructor function
    constructor() public {
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

    /// @dev
    ///   {tokenOfOwnerByIndex(owner, index) returns (tokenId)
    ///   requires {index < balanceOf(owner)}}
    function tokenOfOwnerByIndex_original(address owner, uint256 index) private returns (uint256) {
        return _ownedTokens[owner][index];
    }

    /// dev Gets the total amount of tokens stored by the contract
    /// @return uint256 representing the total amount of tokens
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    /// @dev
    ///   {tokenByIndex(index) returns (x)
    ///   requires {index < totalSupply()}}
    function tokenByIndex_original(uint256 index) private returns (uint256) {
        return _allTokens[index];
    }

    /// dev Internal function to transfer ownership of a given token ID to another address.
    /// As opposed to transferFrom, this imposes no restrictions on msg.sender.
    /// @param from current owner of the token
    /// @param to address to receive the ownership of the given token ID
    /// @param tokenId uint256 ID of the token to be transferred
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        super._transferFrom(from, to, tokenId);
        _removeTokenFromOwnerEnumeration(from, tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
    }

    /// dev Internal function to mint a new token
    /// Reverts if the given token ID already exists
    /// @param to address the beneficiary that will own the minted token
    /// @param tokenId uint256 ID of the token to be minted
    function _mint(address to, uint256 tokenId) internal {
        super._mint(to, tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
        _addTokenToAllTokensEnumeration(tokenId);
    }

    /// dev Internal function to burn a specific token
    /// Reverts if the token does not exist
    /// Deprecated, use _burn(uint256) instead
    /// @param owner owner of the token to burn
    /// @param tokenId uint256 ID of the token being burned
    function _burn(address owner, uint256 tokenId) internal {
        super._burn(owner, tokenId);
        _removeTokenFromOwnerEnumeration(owner, tokenId);
        _ownedTokensIndex[tokenId] = 0;
        _removeTokenFromAllTokensEnumeration(tokenId);
    }

    /// dev Gets the list of token IDs of the requested owner
    /// @param owner address owning the tokens
    /// @return uint256[] List of token IDs owned by the requested address
    function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
        return _ownedTokens[owner];
    }

    /// dev Private function to add a token to this extension's ownership-tracking data structures.
    /// @param to address representing the new owner of the given token ID
    /// @param tokenId uint256 ID of the token to be added to the tokens list of the given address
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    /// dev Private function to add a token to this extension's token tracking data structures.
    /// @param tokenId uint256 ID of the token to be added to the tokens list
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /// dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
    /// while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
    /// gas optimizations e.g. when performing a transfer operation (avoiding double writes).
    /// This has O(1) time complexity, but alters the order of the _ownedTokens array.
    /// @param from address representing the previous owner of the given token ID
    /// @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
            _ownedTokens[from][tokenIndex] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = tokenIndex;
        }
        _ownedTokens[from].length--;
    }

    /// dev Private function to remove a token from this extension's token tracking data structures.
    /// This has O(1) time complexity, but alters the order of the _allTokens array.
    /// @param tokenId uint256 ID of the token to be removed from the tokens list
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        uint256 lastTokenIndex = _allTokens.length.sub(1);
        uint256 tokenIndex = _allTokensIndex[tokenId];
        uint256 lastTokenId = _allTokens[lastTokenIndex];
        _allTokens[tokenIndex] = lastTokenId;
        _allTokensIndex[lastTokenId] = tokenIndex;
        _allTokens.length--;
        _allTokensIndex[tokenId] = 0;
    }

    function _tokenOfOwnerByIndex_pre(address owner, uint256 index) private {
        if (!(index<balanceOf(owner))) revert();
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        _tokenOfOwnerByIndex_pre(owner, index);
        uint256 tokenId = tokenOfOwnerByIndex_original(owner, index);
        return (tokenId);
    }

    function _tokenByIndex_pre(uint256 index) private {
        if (!(index<totalSupply())) revert();
    }

    function tokenByIndex(uint256 index) public view returns (uint256) {
        _tokenByIndex_pre(index);
        uint256 x = tokenByIndex_original(index);
        return (x);
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
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    /// dev Constructor function
    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
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

    /// @dev
    ///   {tokenURI(tokenId) returns (uri)
    ///   requires {_exists(tokenId)}}
    function tokenURI_original(uint256 tokenId) private returns (string memory) {
        return _tokenURIs[tokenId];
    }

    /// @dev
    ///  { _setTokenURI(tokenId, uri)
    ///   requires {_exists(tokenId)}}
    function _setTokenURI_original(uint256 tokenId, string memory uri) private {
        _tokenURIs[tokenId] = uri;
    }

    /// dev Internal function to burn a specific token
    /// Reverts if the token does not exist
    /// Deprecated, use _burn(uint256) instead
    /// @param owner owner of the token to burn
    /// @param tokenId uint256 ID of the token being burned by the msg.sender
    function _burn(address owner, uint256 tokenId) internal {
        super._burn(owner, tokenId);
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }

    function _tokenURI_pre(uint256 tokenId) private {
        if (!(_exists(tokenId))) revert();
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        _tokenURI_pre(tokenId);
        string uri = tokenURI_original(tokenId);
        return (uri);
    }

    function __setTokenURI_pre(uint256 tokenId, string memory uri) private {
        if (!(_exists(tokenId))) revert();
    }

    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        __setTokenURI_pre(tokenId, uri);
        _setTokenURI_original(tokenId, uri);
    }
}

/// @title Full ERC721 Token
/// This implementation includes all the required and some optional functionality of the ERC721 standard
/// Moreover, it includes approve all functionality using operator terminology
/// dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
    constructor(string memory name, string memory symbol) public ERC721Metadata(name,symbol) {}
}

/// @title Roles
/// dev Library for managing addresses assigned to a Role.
library Roles {
    struct Role {
        mapping(address => bool) bearer;
    }

    /// @dev
    ///  { add(role, account)
    ///   requires{ account != address(0) && !has(role, account)}}
    function add_original(Role storage role, address account) private {
        role.bearer[account] = true;
    }

    /// @dev
    ///   {remove(role, account)
    ///   requires {account != address(0) && has(role, account)}}
    function remove_original(Role storage role, address account) private {
        role.bearer[account] = false;
    }

    /// @dev
    ///   {has(role, account) returns (bool)
    ///   requires {account != address(0)}}
    function has_original(Role storage role, address account) private returns (bool) {
        return role.bearer[account];
    }

    function _add_pre(Role storage role, address account) private {
        if (!(account!=address(0)&&!has(role,account))) revert();
    }

    function add(Role storage role, address account) internal {
        _add_pre(role, account);
        add_original(role, account);
    }

    function _remove_pre(Role storage role, address account) private {
        if (!(account!=address(0)&&has(role,account))) revert();
    }

    function remove(Role storage role, address account) internal {
        _remove_pre(role, account);
        remove_original(role, account);
    }

    function _has_pre(Role storage role, address account) private {
        if (!(account!=address(0))) revert();
    }

    function has(Role storage role, address account) internal view returns (bool) {
        _has_pre(role, account);
        bool bool = has_original(role, account);
        return (bool);
    }
}

contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);

    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    modifier onlyMinter() {
        require(isMinter(msg.sender));
        _;
    }

    constructor() internal {
        _addMinter(msg.sender);
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter() {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(msg.sender);
    }

    function _addMinter(address account) internal {
        _minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }
}

/// @title ERC721Mintable
/// dev ERC721 minting logic
contract ERC721Mintable is ERC721, MinterRole {
    /// dev Function to mint tokens
    /// @param to The address that will receive the minted tokens.
    /// @param tokenId The token id to mint.
    /// @return A boolean that indicates if the operation was successful.
    function mint(address to, uint256 tokenId) public onlyMinter() returns (bool) {
        _mint(to, tokenId);
        return true;
    }
}

/// @title ERC721MetadataMintable
/// dev ERC721 minting logic with metadata
contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
    /// dev Function to mint tokens
    /// @param to The address that will receive the minted tokens.
    /// @param tokenId The token id to mint.
    /// @param tokenURI The token URI of the minted token.
    /// @return A boolean that indicates if the operation was successful.
    function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter() returns (bool) {
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return true;
    }
}

/// @title ERC721 Burnable Token
/// dev ERC721 Token that can be irreversibly burned (destroyed).
contract ERC721Burnable is ERC721 {
    /// @dev
    ///   {burn(tokenId)
    ///   requires {_isApprovedOrOwner(msg.sender, tokenId)}}
    function burn_original(uint256 tokenId) private {
        _burn(tokenId);
    }

    function _burn_pre(uint256 tokenId) private {
        if (!(_isApprovedOrOwner(msg.sender,tokenId))) revert();
    }

    function burn(uint256 tokenId) public {
        _burn_pre(tokenId);
        burn_original(tokenId);
    }
}

/// @title Ownable
/// dev The Ownable contract has an owner address, and provides basic authorization control
/// functions, this simplifies the implementation of "user permissions".
contract Ownable {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address private _owner;

    /// dev Throws if called by any account other than the owner.
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /// dev The Ownable constructor sets the original `owner` of the contract to the sender
    /// account.
    constructor() internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /// @return the address of the owner.
    function owner() public view returns (address) {
        return _owner;
    }

    /// @return true if `msg.sender` is the owner of the contract.
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /// dev Allows the current owner to relinquish control of the contract.
    /// @notice Renouncing to ownership will leave the contract without an owner.
    /// It will not be possible to call the functions with the `onlyOwner`
    /// modifier anymore.
    function renounceOwnership() public onlyOwner() {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /// dev Allows the current owner to transfer control of the contract to a newOwner.
    /// @param newOwner The address to transfer ownership to.
    function transferOwnership(address newOwner) public onlyOwner() {
        _transferOwnership(newOwner);
    }

    /// @dev
    ///   {_transferOwnership(newOwner)
    ///   requires{ newOwner != address(0)}}
    function _transferOwnership_original(address newOwner) private {
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function __transferOwnership_pre(address newOwner) private {
        if (!(newOwner!=address(0))) revert();
    }

    function _transferOwnership(address newOwner) internal {
        __transferOwnership_pre(newOwner);
        _transferOwnership_original(newOwner);
    }
}

contract DozerDoll is ERC721Full, ERC721Mintable, ERC721MetadataMintable, ERC721Burnable, Ownable {
    using SafeMath for uint256;

    constructor(string memory _name, string memory _symbol) public ERC721Mintable() ERC721Full(_name,_symbol) {}

    function mintUniqueTokenTo(address _to, uint256 _tokenId, string memory _tokenURI) public onlyOwner() {
        _mint(_to, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);
    }

    function transfer(address _to, uint256 _tokenId) public {
        safeTransferFrom(msg.sender, _to, _tokenId);
    }

    function transferAll(address _to, uint256[] memory _tokenId) public {
        for (uint i = 0; i < _tokenId.length; i++) {
            safeTransferFrom(msg.sender, _to, _tokenId[i]);
        }
    }
}