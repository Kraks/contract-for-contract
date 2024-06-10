pragma solidity ^0.5.0;

/// @title SafeMath
/// dev Math operations with safety checks that throw on error
library SafeMath {
    /// dev Multiplies two numbers, throws on overflow.
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert((c / a) == b);
        return c;
    }

    /// dev Integer division of two numbers, truncating the quotient.
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /// @dev
    ///     {sub(a, b) returns (c)
    ///     requires {b <= a}}
    function sub_original(uint256 a, uint256 b) private pure returns (uint256) {
        return a - b;
    }

    /// @dev
    ///     {add(a, b) returns (c)
    ///     ensures {c >= a}}
    function add_original(uint256 a, uint256 b) private pure returns (uint256 c) {
        c = a + b;
        return c;
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

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        uint256 c = add_original(a, b);
        _add_post(a, b, c);
        return (c);
    }
}

/// Utility library of inline functions on addresses
library AddressUtils {
    /// Returns whether the target address is a contract
    /// dev This function will return false if invoked during the constructor of a contract,
    /// as the code is not actually created until after the constructor finishes.
    /// @param addr address to check
    /// @return whether the target address is a contract
    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}

/// @title ERC165
/// dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
interface ERC165 {
    /// @notice Query if a contract implements an interface
    /// @param _interfaceId The interface identifier, as specified in ERC-165
    /// dev Interface identification is specified in ERC-165. This function
    /// uses less than 30,000 gas.
    function supportsInterface(bytes4 _interfaceId) external view returns (bool);
}

/// @title SupportsInterfaceWithLookup
/// @author Matt Condon (@shrugs)
/// dev Implements ERC165 using a lookup table.
contract SupportsInterfaceWithLookup is ERC165 {
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

/// @title ERC721 token receiver interface
/// dev Interface for any contract that wants to support safeTransfers
/// from ERC721 asset contracts.
contract ERC721Receiver {
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

/// @title ERC721 Non-Fungible Token Standard basic interface
/// dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721Basic is ERC165 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) public view returns (uint256 _balance);

    function ownerOf(uint256 _tokenId) public view returns (address _owner);

    function exists(uint256 _tokenId) public view returns (bool _exists);

    function approve(address _to, uint256 _tokenId) public;

    function getApproved(uint256 _tokenId) public view returns (address _operator);

    function setApprovalForAll(address _operator, bool _approved) public;

    function isApprovedForAll(address _owner, address _operator) public view returns (bool);

    function transferFrom(address _from, address _to, uint256 _tokenId) public;

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public;
}

/// @title ERC721 Non-Fungible Token Standard basic implementation
/// dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
    using SafeMath for uint256;
    using AddressUtils for address;

    bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
    bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
    bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
    mapping(uint256 => address) internal tokenOwner;
    mapping(uint256 => address) internal tokenApprovals;
    mapping(address => uint256) internal ownedTokensCount;
    uint256[] internal allTokens;
    mapping(address => mapping(address => bool)) internal operatorApprovals;

    /// dev Guarantees msg.sender is owner of the given token
    /// @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
    modifier onlyOwnerOf(uint256 _tokenId) {
        require(ownerOf(_tokenId) == msg.sender);
        _;
    }

    /// dev Checks msg.sender can transfer a token, by being owner, approved, or operator
    /// @param _tokenId uint256 ID of the token to validate
    modifier canTransfer(uint256 _tokenId) {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _;
    }

    constructor() public {
        _registerInterface(InterfaceId_ERC721);
        _registerInterface(InterfaceId_ERC721Exists);
    }

    /// dev Gets the balance of the specified address
    /// @param _owner address to query the balance of
    /// @return uint256 representing the amount owned by the passed address
    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0));
        return ownedTokensCount[_owner];
    }

    /// dev Gets the owner of the specified token ID
    /// @param _tokenId uint256 ID of the token to query the owner of
    /// @return owner address currently marked as the owner of the given token ID
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = tokenOwner[_tokenId];
        require(owner != address(0));
        return owner;
    }

    /// dev Returns whether the specified token exists
    /// @param _tokenId uint256 ID of the token to query the existence of
    /// @return whether the token exists
    function exists(uint256 _tokenId) public view returns (bool) {
        address owner = tokenOwner[_tokenId];
        return owner != address(0);
    }

    /// dev Approves another address to transfer the given token ID
    /// The zero address indicates there is no approved address.
    /// There can only be one approved address per token at a given time.
    /// Can only be called by the token owner or an approved operator.
    /// @param _to address to be approved for the given token ID
    /// @param _tokenId uint256 ID of the token to be approved
    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_to != owner);
        require((msg.sender == owner) || isApprovedForAll(owner, msg.sender));
        tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }

    /// dev Gets the approved address for a token ID, or zero if no address set
    /// @param _tokenId uint256 ID of the token to query the approval of
    /// @return address currently approved for the given token ID
    function getApproved(uint256 _tokenId) public view returns (address) {
        return tokenApprovals[_tokenId];
    }

    /// dev Sets or unsets the approval of a given operator
    /// An operator is allowed to transfer all tokens of the sender on their behalf
    /// @param _to operator address to set the approval
    /// @param _approved representing the status of the approval to be set
    function setApprovalForAll(address _to, bool _approved) public {
        require(_to != msg.sender);
        operatorApprovals[msg.sender][_to] = _approved;
        emit ApprovalForAll(msg.sender, _to, _approved);
    }

    /// dev Tells whether an operator is approved by a given owner
    /// @param _owner owner address which you want to query the approval of
    /// @param _operator operator address which you want to query the approval of
    /// @return bool whether the given operator is approved by the given owner
    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return operatorApprovals[_owner][_operator];
    }

    /// @dev
    ///     {transferFrom(_from, _to, _tokenId)
    ///     requires {_from != address(0) && _to != address(0)}}
    function transferFrom_original(address _from, address _to, uint256 _tokenId) private canTransfer(_tokenId) {
        clearApproval(_from, _tokenId);
        removeTokenFrom(_from, _tokenId);
        addTokenTo(_to, _tokenId);
        emit Transfer(_from, _to, _tokenId);
    }

    /// dev Safely transfers the ownership of a given token ID to another address
    /// If the target address is a contract, it must implement `onERC721Received`,
    /// which is called upon a safe transfer, and return the magic value
    /// `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
    /// the transfer is reverted.
    ///    * Requires the msg sender to be the owner, approved, or operator
    /// @param _from current owner of the token
    /// @param _to address to receive the ownership of the given token ID
    /// @param _tokenId uint256 ID of the token to be transferred
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    /// dev Safely transfers the ownership of a given token ID to another address
    /// If the target address is a contract, it must implement `onERC721Received`,
    /// which is called upon a safe transfer, and return the magic value
    /// `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
    /// the transfer is reverted.
    /// Requires the msg sender to be the owner, approved, or operator
    /// @param _from current owner of the token
    /// @param _to address to receive the ownership of the given token ID
    /// @param _tokenId uint256 ID of the token to be transferred
    /// @param _data bytes data to send along with a safe transfer check
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public canTransfer(_tokenId) {
        transferFrom(_from, _to, _tokenId);
        require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
    }

    /// dev Returns whether the given spender can transfer a given token ID
    /// @param _spender address of the spender to query
    /// @param _tokenId uint256 ID of the token to be transferred
    /// @return bool whether the msg.sender is approved for the given token ID,
    ///  is an operator of the owner, or is the owner of the token
    function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
        address owner = ownerOf(_tokenId);
        return (((_spender == owner) || (getApproved(_tokenId) == _spender)) || isApprovedForAll(owner, _spender));
    }

    /// @dev
    ///    { _mint(_to, _tokenId)
    ///     requires {_to != address(0)}}
    function _mint_original(address _to, uint256 _tokenId) private {
        addTokenTo(_to, _tokenId);
        emit Transfer(address(0), _to, _tokenId);
    }

    /// dev Internal function to burn a specific token
    /// Reverts if the token does not exist
    /// @param _tokenId uint256 ID of the token being burned by the msg.sender
    function _burn(address _owner, uint256 _tokenId) internal {
        clearApproval(_owner, _tokenId);
        removeTokenFrom(_owner, _tokenId);
        emit Transfer(_owner, address(0), _tokenId);
    }

    /// @dev
    ///    { clearApproval(_owner, _tokenId)
    ///     requires {ownerOf(_tokenId) == _owner}}
    function clearApproval_original(address _owner, uint256 _tokenId) private {
        if (tokenApprovals[_tokenId] != address(0)) {
            tokenApprovals[_tokenId] = address(0);
        }
    }

    /// @dev
    ///     {addTokenTo(_to, _tokenId)
    ///     requires {tokenOwner[_tokenId] == address(0)}}
    function addTokenTo_original(address _to, uint256 _tokenId) private {
        tokenOwner[_tokenId] = _to;
        ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
    }

    /// @dev
    ///     {removeTokenFrom(_from, _tokenId)
    ///     requires { ownerOf(_tokenId) == _from }}
    function removeTokenFrom_original(address _from, uint256 _tokenId) private {
        ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
        tokenOwner[_tokenId] = address(0);
    }

    /// dev Internal function to invoke `onERC721Received` on a target address
    /// The call is not executed if the target address is not a contract
    /// @param _from address representing the previous owner of the given token ID
    /// @param _to target address that will receive the tokens
    /// @param _tokenId uint256 ID of the token to be transferred
    /// @param _data bytes optional data to send along with the call
    /// @return whether the call correctly returned the expected magic value
    function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool) {
        if (!_to.isContract()) {
            return true;
        }
        bytes4 retval = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        return (retval == ERC721_RECEIVED);
    }

    function _transferFrom_pre(address _from, address _to, uint256 _tokenId) private {
        if (!(_from!=address(0)&&_to!=address(0))) revert();
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        _transferFrom_pre(_from, _to, _tokenId);
        transferFrom_original(_from, _to, _tokenId);
    }

    function __mint_pre(address _to, uint256 _tokenId) private {
        if (!(_to!=address(0))) revert();
    }

    function _mint(address _to, uint256 _tokenId) internal {
        __mint_pre(_to, _tokenId);
        _mint_original(_to, _tokenId);
    }

    function _clearApproval_pre(address _owner, uint256 _tokenId) private {
        if (!(ownerOf(_tokenId)==_owner)) revert();
    }

    function clearApproval(address _owner, uint256 _tokenId) internal {
        _clearApproval_pre(_owner, _tokenId);
        clearApproval_original(_owner, _tokenId);
    }

    function _addTokenTo_pre(address _to, uint256 _tokenId) private {
        if (!(tokenOwner[_tokenId]==address(0))) revert();
    }

    function addTokenTo(address _to, uint256 _tokenId) internal {
        _addTokenTo_pre(_to, _tokenId);
        addTokenTo_original(_to, _tokenId);
    }

    function _removeTokenFrom_pre(address _from, uint256 _tokenId) private {
        if (!(ownerOf(_tokenId)==_from)) revert();
    }

    function removeTokenFrom(address _from, uint256 _tokenId) internal {
        _removeTokenFrom_pre(_from, _tokenId);
        removeTokenFrom_original(_from, _tokenId);
    }
}

/// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
/// dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721Enumerable is ERC721Basic {
    function totalSupply() public view returns (uint256);

    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);

    function tokenByIndex(uint256 _index) public view returns (uint256);
}

/// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
/// dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721Metadata is ERC721Basic {
    function name() external view returns (string memory _name);

    function symbol() external view returns (string memory _symbol);

    function tokenURI(uint256 _tokenId) public view returns (string memory);
}

/// @title ERC-721 Non-Fungible Token Standard, full implementation interface
/// dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {}

/// @title Full ERC721 Token
/// This implementation includes all the required and some optional functionality of the ERC721 standard
/// Moreover, it includes approve all functionality using operator terminology
/// dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
    bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
    bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
    string internal name_;
    string internal symbol_;
    mapping(address => uint256[]) internal ownedTokens;
    mapping(uint256 => uint256) internal ownedTokensIndex;
    mapping(uint256 => uint256) internal allTokensIndex;
    mapping(uint256 => string) internal tokenURIs;

    /// dev Constructor function
    constructor(string memory _name, string memory _symbol) public {
        name_ = _name;
        symbol_ = _symbol;
        _registerInterface(InterfaceId_ERC721Enumerable);
        _registerInterface(InterfaceId_ERC721Metadata);
    }

    /// dev Gets the token name
    /// @return string representing the token name
    function name() external view returns (string memory) {
        return name_;
    }

    /// dev Gets the token symbol
    /// @return string representing the token symbol
    function symbol() external view returns (string memory) {
        return symbol_;
    }

    /// dev Returns an URI for a given token ID
    /// Throws if the token ID does not exist. May return an empty string.
    /// @param _tokenId uint256 ID of the token to query
    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        require(exists(_tokenId));
        return tokenURIs[_tokenId];
    }

    /// dev Gets the token ID at a given index of the tokens list of the requested owner
    /// @param _owner address owning the tokens list to be accessed
    /// @param _index uint256 representing the index to be accessed of the requested tokens list
    /// @return uint256 token ID at the given index of the tokens list owned by the requested address
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
        require(_index < balanceOf(_owner));
        return ownedTokens[_owner][_index];
    }

    /// dev Gets the total amount of tokens stored by the contract
    /// @return uint256 representing the total amount of tokens
    function totalSupply() public view returns (uint256) {
        return allTokens.length;
    }

    /// dev Gets the token ID at a given index of all the tokens in this contract
    /// Reverts if the index is greater or equal to the total number of tokens
    /// @param _index uint256 representing the index to be accessed of the tokens list
    /// @return uint256 token ID at the given index of the tokens list
    function tokenByIndex(uint256 _index) public view returns (uint256) {
        require(_index < totalSupply());
        return allTokens[_index];
    }

    /// dev Internal function to set the token URI for a given token
    /// Reverts if the token ID does not exist
    /// @param _tokenId uint256 ID of the token to set its URI
    /// @param _uri string URI to assign
    function _setTokenURI(uint256 _tokenId, string memory _uri) internal {
        require(exists(_tokenId));
        tokenURIs[_tokenId] = _uri;
    }

    /// dev Internal function to add a token ID to the list of a given address
    /// @param _to address representing the new owner of the given token ID
    /// @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
    function addTokenTo(address _to, uint256 _tokenId) internal {
        super.addTokenTo(_to, _tokenId);
        uint256 length = ownedTokens[_to].length;
        ownedTokens[_to].push(_tokenId);
        ownedTokensIndex[_tokenId] = length;
    }

    /// dev Internal function to remove a token ID from the list of a given address
    /// @param _from address representing the previous owner of the given token ID
    /// @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
    function removeTokenFrom(address _from, uint256 _tokenId) internal {
        super.removeTokenFrom(_from, _tokenId);
        uint256 tokenIndex = ownedTokensIndex[_tokenId];
        uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
        uint256 lastToken = ownedTokens[_from][lastTokenIndex];
        ownedTokens[_from][tokenIndex] = lastToken;
        ownedTokens[_from][lastTokenIndex] = 0;
        ownedTokens[_from].length--;
        ownedTokensIndex[_tokenId] = 0;
        ownedTokensIndex[lastToken] = tokenIndex;
    }

    /// dev Internal function to mint a new token
    /// Reverts if the given token ID already exists
    /// @param _to address the beneficiary that will own the minted token
    /// @param _tokenId uint256 ID of the token to be minted by the msg.sender
    function _mint(address _to, uint256 _tokenId) internal {
        super._mint(_to, _tokenId);
        allTokensIndex[_tokenId] = allTokens.length;
        allTokens.push(_tokenId);
    }

    /// dev Internal function to burn a specific token
    /// Reverts if the token does not exist
    /// @param _owner owner of the token to burn
    /// @param _tokenId uint256 ID of the token being burned by the msg.sender
    function _burn(address _owner, uint256 _tokenId) internal {
        super._burn(_owner, _tokenId);
        if (bytes(tokenURIs[_tokenId]).length != 0) {
            delete tokenURIs[_tokenId];
        }
        uint256 tokenIndex = allTokensIndex[_tokenId];
        uint256 lastTokenIndex = allTokens.length.sub(1);
        uint256 lastToken = allTokens[lastTokenIndex];
        allTokens[tokenIndex] = lastToken;
        allTokens[lastTokenIndex] = 0;
        allTokens.length--;
        allTokensIndex[_tokenId] = 0;
        allTokensIndex[lastToken] = tokenIndex;
    }
}

/// @title Ownable
/// dev The Ownable contract has an owner address, and provides basic authorization control
/// functions, this simplifies the implementation of "user permissions".
contract Ownable {
    event OwnershipRenounced(address indexed previousOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address public owner;

    /// dev Throws if called by any account other than the owner.
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /// dev The Ownable constructor sets the original `owner` of the contract to the sender
    /// account.
    constructor() public {
        owner = msg.sender;
    }

    /// dev Allows the current owner to relinquish control of the contract.
    /// @notice Renouncing to ownership will leave the contract without an owner.
    /// It will not be possible to call the functions with the `onlyOwner`
    /// modifier anymore.
    function renounceOwnership() public onlyOwner() {
        emit OwnershipRenounced(owner);
        owner = address(0);
    }

    /// dev Allows the current owner to transfer control of the contract to a newOwner.
    /// @param _newOwner The address to transfer ownership to.
    function transferOwnership(address _newOwner) public onlyOwner() {
        _transferOwnership(_newOwner);
    }

    /// dev Transfers control of the contract to a newOwner.
    /// @param _newOwner The address to transfer ownership to.
    function _transferOwnership(address _newOwner) internal {
        require(_newOwner != address(0));
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}

/// @title Roles
/// @author Francisco Giordano (@frangio)
/// dev Library for managing addresses assigned to a Role.
/// See RBAC.sol for example usage.
library Roles {
    struct Role {
        mapping(address => bool) bearer;
    }

    /// dev give an address access to this role
    function add(Role storage role, address addr) internal {
        role.bearer[addr] = true;
    }

    /// dev remove an address' access to this role
    function remove(Role storage role, address addr) internal {
        role.bearer[addr] = false;
    }

    /// dev check if an address has this role
    /// // reverts
    function check(Role storage role, address addr) internal view {
        require(has(role, addr));
    }

    /// dev check if an address has this role
    /// @return bool
    function has(Role storage role, address addr) internal view returns (bool) {
        return role.bearer[addr];
    }
}

/// @title RBAC (Role-Based Access Control)
/// @author Matt Condon (@Shrugs)
/// dev Stores and provides setters and getters for roles and addresses.
/// Supports unlimited numbers of roles and addresses.
/// See //contracts/mocks/RBACMock.sol for an example of usage.
/// This RBAC method uses strings to key roles. It may be beneficial
/// for you to write your own implementation of this interface using Enums or similar.
/// It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
/// to avoid typos.
contract RBAC {
    using Roles for Roles.Role;

    event RoleAdded(address indexed operator, string role);

    event RoleRemoved(address indexed operator, string role);

    mapping(string => Roles.Role) private roles;

    /// dev modifier to scope access to a single role (uses msg.sender as addr)
    /// @param _role the name of the role
    /// // reverts
    modifier onlyRole(string memory _role) {
        checkRole(msg.sender, _role);
        _;
    }

    /// dev reverts if addr does not have role
    /// @param _operator address
    /// @param _role the name of the role
    /// // reverts
    function checkRole(address _operator, string memory _role) public view {
        roles[_role].check(_operator);
    }

    /// dev determine if addr has role
    /// @param _operator address
    /// @param _role the name of the role
    /// @return bool
    function hasRole(address _operator, string memory _role) public view returns (bool) {
        return roles[_role].has(_operator);
    }

    /// dev add a role to an address
    /// @param _operator address
    /// @param _role the name of the role
    function addRole(address _operator, string memory _role) internal {
        roles[_role].add(_operator);
        emit RoleAdded(_operator, _role);
    }

    /// dev remove a role from an address
    /// @param _operator address
    /// @param _role the name of the role
    function removeRole(address _operator, string memory _role) internal {
        roles[_role].remove(_operator);
        emit RoleRemoved(_operator, _role);
    }
}

/// @title Whitelist
/// dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
/// This simplifies the implementation of "user permissions".
contract Whitelist is Ownable, RBAC {
    string public constant ROLE_WHITELISTED = "whitelist";

    /// dev Throws if operator is not whitelisted.
    /// @param _operator address
    modifier onlyIfWhitelisted(address _operator) {
        checkRole(_operator, ROLE_WHITELISTED);
        _;
    }

    /// dev add an address to the whitelist
    /// @param _operator address
    /// @return true if the address was added to the whitelist, false if the address was already in the whitelist
    function addAddressToWhitelist(address _operator) public onlyOwner() {
        addRole(_operator, ROLE_WHITELISTED);
    }

    /// dev getter to determine if address is in whitelist
    function whitelist(address _operator) public view returns (bool) {
        return hasRole(_operator, ROLE_WHITELISTED);
    }

    /// dev add addresses to the whitelist
    /// @param _operators addresses
    /// @return true if at least one address was added to the whitelist,
    /// false if all addresses were already in the whitelist
    function addAddressesToWhitelist(address[] memory _operators) public onlyOwner() {
        for (uint256 i = 0; i < _operators.length; i++) {
            addAddressToWhitelist(_operators[i]);
        }
    }

    /// dev remove an address from the whitelist
    /// @param _operator address
    /// @return true if the address was removed from the whitelist,
    /// false if the address wasn't in the whitelist in the first place
    function removeAddressFromWhitelist(address _operator) public onlyOwner() {
        removeRole(_operator, ROLE_WHITELISTED);
    }

    /// dev remove addresses from the whitelist
    /// @param _operators addresses
    /// @return true if at least one address was removed from the whitelist,
    /// false if all addresses weren't in the whitelist in the first place
    function removeAddressesFromWhitelist(address[] memory _operators) public onlyOwner() {
        for (uint256 i = 0; i < _operators.length; i++) {
            removeAddressFromWhitelist(_operators[i]);
        }
    }
}

contract CrabData {
    struct CrabPartData {
        uint256 hp;
        uint256 dps;
        uint256 blockRate;
        uint256 resistanceBonus;
        uint256 hpBonus;
        uint256 dpsBonus;
        uint256 blockBonus;
        uint256 mutiplierBonus;
    }

    modifier crabDataLength(uint256[] memory _crabData) {
        require(_crabData.length == 8);
        _;
    }

    function arrayToCrabPartData(uint256[] memory _partData) internal pure crabDataLength(_partData) returns (CrabPartData memory _parsedData) {
        _parsedData = CrabPartData(_partData[0], _partData[1], _partData[2], _partData[3], _partData[4], _partData[5], _partData[6], _partData[7]);
    }

    function crabPartDataToArray(CrabPartData memory _crabPartData) internal pure returns (uint256[] memory _resultData) {
        _resultData = new uint256[](8);
        _resultData[0] = _crabPartData.hp;
        _resultData[1] = _crabPartData.dps;
        _resultData[2] = _crabPartData.blockRate;
        _resultData[3] = _crabPartData.resistanceBonus;
        _resultData[4] = _crabPartData.hpBonus;
        _resultData[5] = _crabPartData.dpsBonus;
        _resultData[6] = _crabPartData.blockBonus;
        _resultData[7] = _crabPartData.mutiplierBonus;
    }
}

contract GeneSurgeon {
    uint256[] internal crabPartMultiplier = [0, 10 ** 9, 10 ** 6, 10 ** 3, 1];

    function extractElementsFromGene(uint256 _gene) internal view returns (uint256[] memory _elements) {
        _elements = new uint256[](4);
        _elements[0] = ((_gene / crabPartMultiplier[1]) / 100) % 10;
        _elements[1] = ((_gene / crabPartMultiplier[2]) / 100) % 10;
        _elements[2] = ((_gene / crabPartMultiplier[3]) / 100) % 10;
        _elements[3] = ((_gene / crabPartMultiplier[4]) / 100) % 10;
    }

    function extractPartsFromGene(uint256 _gene) internal view returns (uint256[] memory _parts) {
        _parts = new uint256[](4);
        _parts[0] = (_gene / crabPartMultiplier[1]) % 100;
        _parts[1] = (_gene / crabPartMultiplier[2]) % 100;
        _parts[2] = (_gene / crabPartMultiplier[3]) % 100;
        _parts[3] = (_gene / crabPartMultiplier[4]) % 100;
    }
}

contract CryptantCrabNFT is ERC721Token, Whitelist, CrabData, GeneSurgeon {
    event CrabPartAdded(uint256 hp, uint256 dps, uint256 blockAmount);

    event GiftTransfered(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    event DefaultMetadataURIChanged(string newUri);

    bytes4 internal constant CRAB_BODY = 0xc398430e;
    bytes4 internal constant CRAB_LEG = 0x889063b1;
    bytes4 internal constant CRAB_LEFT_CLAW = 0xdb6290a2;
    bytes4 internal constant CRAB_RIGHT_CLAW = 0x13453f89;
    mapping(bytes4 => mapping(uint256 => CrabPartData[])) internal crabPartData;
    mapping(uint256 => uint256) internal crabSpecialSkins;
    string public defaultMetadataURI = "https://www.cryptantcrab.io/md/";

    constructor(string memory _name, string memory _symbol) public ERC721Token(_name,_symbol) {
        initiateCrabPartData();
    }

    /// dev Returns an URI for a given token ID
    /// Throws if the token ID does not exist.
    /// Will return the token's metadata URL if it has one,
    /// otherwise will just return base on the default metadata URI
    /// @param _tokenId uint256 ID of the token to query
    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        require(exists(_tokenId));
        string memory _uri = tokenURIs[_tokenId];
        if (bytes(_uri).length == 0) {}
        return _uri;
    }

    /// dev Returns the data of a specific parts
    /// @param _partIndex the part to retrieve. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
    /// @param _element the element of part to retrieve. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
    /// @param _setIndex the set index of for the specified part. This will starts from 1.
    function dataOfPart(uint256 _partIndex, uint256 _element, uint256 _setIndex) public view returns (uint256[] memory _resultData) {
        bytes4 _key;
        if (_partIndex == 1) {
            _key = CRAB_BODY;
        } else if (_partIndex == 2) {
            _key = CRAB_LEG;
        } else if (_partIndex == 3) {
            _key = CRAB_LEFT_CLAW;
        } else if (_partIndex == 4) {
            _key = CRAB_RIGHT_CLAW;
        } else {
            revert();
        }
        CrabPartData storage _crabPartData = crabPartData[_key][_element][_setIndex];
        _resultData = crabPartDataToArray(_crabPartData);
    }

    /// dev Gift(Transfer) a token to another address. Caller must be token owner
    /// @param _from current owner of the token
    /// @param _to address to receive the ownership of the given token ID
    /// @param _tokenId uint256 ID of the token to be transferred
    function giftToken(address _from, address _to, uint256 _tokenId) external {
        safeTransferFrom(_from, _to, _tokenId);
        emit GiftTransfered(_from, _to, _tokenId);
    }

    /// dev External function to mint a new token, for whitelisted address only.
    /// Reverts if the given token ID already exists
    /// @param _tokenOwner address the beneficiary that will own the minted token
    /// @param _tokenId uint256 ID of the token to be minted by the msg.sender
    function mintToken(address _tokenOwner, uint256 _tokenId) external {
        super._mint(_tokenOwner, _tokenId);
    }

    /// dev Returns crab data base on the gene provided
    /// @param _gene the gene info where crab data will be retrieved base on it
    /// @return 4 uint arrays:
    /// 1st Array = Body's Data
    /// 2nd Array = Leg's Data
    /// 3rd Array = Left Claw's Data
    /// 4th Array = Right Claw's Data
    function crabPartDataFromGene(uint256 _gene) external view returns (uint256[] memory _bodyData, uint256[] memory _legData, uint256[] memory _leftClawData, uint256[] memory _rightClawData) {
        uint256[] memory _parts = extractPartsFromGene(_gene);
        uint256[] memory _elements = extractElementsFromGene(_gene);
        _bodyData = dataOfPart(1, _elements[0], _parts[0]);
        _legData = dataOfPart(2, _elements[1], _parts[1]);
        _leftClawData = dataOfPart(3, _elements[2], _parts[2]);
        _rightClawData = dataOfPart(4, _elements[3], _parts[3]);
    }

    /// dev For developer to add new parts, notice that this is the only method to add crab data
    /// so that developer can add extra content. there's no other method for developer to modify
    /// the data. This is to assure token owner actually owns their data.
    /// @param _partIndex the part to add. 1 = Body, 2 = Legs, 3 = Left Claw, 4 = Right Claw
    /// @param _element the element of part to add. 1 = Fire, 2 = Earth, 3 = Metal, 4 = Spirit, 5 = Water
    /// @param _partDataArray data of the parts.
    function setPartData(uint256 _partIndex, uint256 _element, uint256[] calldata _partDataArray) external onlyOwner() {
        CrabPartData memory _partData = arrayToCrabPartData(_partDataArray);
        bytes4 _key;
        if (_partIndex == 1) {
            _key = CRAB_BODY;
        } else if (_partIndex == 2) {
            _key = CRAB_LEG;
        } else if (_partIndex == 3) {
            _key = CRAB_LEFT_CLAW;
        } else if (_partIndex == 4) {
            _key = CRAB_RIGHT_CLAW;
        }
        if ((crabPartData[_key][_element][1].hp == 0) && (crabPartData[_key][_element][1].dps == 0)) {
            crabPartData[_key][_element][1] = _partData;
        } else {
            crabPartData[_key][_element].push(_partData);
        }
        emit CrabPartAdded(_partDataArray[0], _partDataArray[1], _partDataArray[2]);
    }

    /// dev Updates the default metadata URI
    /// @param _defaultUri the new metadata URI
    function setDefaultMetadataURI(string calldata _defaultUri) external onlyOwner() {
        defaultMetadataURI = _defaultUri;
        emit DefaultMetadataURIChanged(_defaultUri);
    }

    /// dev Updates the metadata URI for existing token
    /// @param _tokenId the tokenID that metadata URI to be changed
    /// @param _uri the new metadata URI for the specified token
    function setTokenURI(uint256 _tokenId, string calldata _uri) external onlyIfWhitelisted(msg.sender) {
        _setTokenURI(_tokenId, _uri);
    }

    /// dev Returns the special skin of the provided tokenId
    /// @param _tokenId cryptant crab's tokenId
    /// @return Special skin belongs to the _tokenId provided.
    /// 0 will be returned if no special skin found.
    function specialSkinOfTokenId(uint256 _tokenId) external view returns (uint256) {
        return crabSpecialSkins[_tokenId];
    }

    /// dev This functions will adjust the length of crabPartData
    /// so that when adding data the index can start with 1.
    /// Reason of doing this is because gene cannot have parts with index 0.
    function initiateCrabPartData() internal {
        require(crabPartData[CRAB_BODY][1].length == 0);
        for (uint256 i = 1; i <= 5; i++) {
            crabPartData[CRAB_BODY][i].length = 2;
            crabPartData[CRAB_LEG][i].length = 2;
            crabPartData[CRAB_LEFT_CLAW][i].length = 2;
            crabPartData[CRAB_RIGHT_CLAW][i].length = 2;
        }
    }

    /// dev Returns whether the given spender can transfer a given token ID
    /// @param _spender address of the spender to query
    /// @param _tokenId uint256 ID of the token to be transferred
    /// @return bool whether the msg.sender is approved for the given token ID,
    ///  is an operator of the owner, or is the owner of the token,
    ///  or has been whitelisted by contract owner
    function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
        address owner = ownerOf(_tokenId);
        return (((_spender == owner) || (getApproved(_tokenId) == _spender)) || isApprovedForAll(owner, _spender)) || whitelist(_spender);
    }
}