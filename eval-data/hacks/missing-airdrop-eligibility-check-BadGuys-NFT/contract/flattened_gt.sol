pragma solidity =0.8.7;

error ApprovalCallerNotOwnerNorApproved();

error ApprovalQueryForNonexistentToken();

error ApproveToCaller();

error ApprovalToCurrentOwner();

error BalanceQueryForZeroAddress();

error MintedQueryForZeroAddress();

error MintToZeroAddress();

error MintZeroQuantity();

error OwnerIndexOutOfBounds();

error OwnerQueryForNonexistentToken();

error TokenIndexOutOfBounds();

error TransferCallerNotOwnerNorApproved();

error TransferFromIncorrectOwner();

error TransferToNonERC721ReceiverImplementer();

error TransferToZeroAddress();

error UnableDetermineTokenOwner();

error URIQueryForNonexistentToken();

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    ///  dev: Converts a `uint256` to its ASCII `string` hexadecimal representation.
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes((2 * length) + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = (2 * length) + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

abstract contract Context {
    function _msgSender() virtual internal view returns (address) {
        return msg.sender;
    }

    function _msgData() virtual internal view returns (bytes calldata) {
        return msg.data;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) virtual override public view returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    ///  dev: Emitted when `owner` enables `approved` to manage the `tokenId` token.
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    ///  dev: Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    ///  dev: Returns the number of tokens in ``owner``'s account.
    function balanceOf(address owner) external view returns (uint256 balance);

    ///  dev: Returns the owner of the `tokenId` token.
    ///  Requirements:
    ///  - `tokenId` must exist.
    function ownerOf(uint256 tokenId) external view returns (address owner);

    ///  dev: Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
    ///  are aware of the ERC721 protocol to prevent tokens from being forever locked.
    ///  Requirements:
    ///  - `from` cannot be the zero address.
    ///  - `to` cannot be the zero address.
    ///  - `tokenId` token must exist and be owned by `from`.
    ///  - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
    ///  - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    ///  Emits a {Transfer} event.
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    ///  dev: Transfers `tokenId` token from `from` to `to`.
    ///  WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
    ///  Requirements:
    ///  - `from` cannot be the zero address.
    ///  - `to` cannot be the zero address.
    ///  - `tokenId` token must be owned by `from`.
    ///  - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
    ///  Emits a {Transfer} event.
    function transferFrom(address from, address to, uint256 tokenId) external;

    ///  dev: Gives permission to `to` to transfer `tokenId` token to another account.
    ///  The approval is cleared when the token is transferred.
    ///  Only a single account can be approved at a time, so approving the zero address clears previous approvals.
    ///  Requirements:
    ///  - The caller must own the token or be an approved operator.
    ///  - `tokenId` must exist.
    ///  Emits an {Approval} event.
    function approve(address to, uint256 tokenId) external;

    ///  dev: Returns the account approved for `tokenId` token.
    ///  Requirements:
    ///  - `tokenId` must exist.
    function getApproved(uint256 tokenId) external view returns (address operator);

    ///  dev: Approve or remove `operator` as an operator for the caller.
    ///  Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
    ///  Requirements:
    ///  - The `operator` cannot be the caller.
    ///  Emits an {ApprovalForAll} event.
    function setApprovalForAll(address operator, bool _approved) external;

    ///  dev: Returns if the `operator` is allowed to manage all of the assets of `owner`.
    ///  See {setApprovalForAll}
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    ///  dev: Safely transfers `tokenId` token from `from` to `to`.
    ///  Requirements:
    ///  - `from` cannot be the zero address.
    ///  - `to` cannot be the zero address.
    ///  - `tokenId` token must exist and be owned by `from`.
    ///  - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
    ///  - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    ///  Emits a {Transfer} event.
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

interface IERC721Enumerable is IERC721 {
    ///  dev: Returns the total amount of tokens stored by the contract.
    function totalSupply() external view returns (uint256);

    ///  dev: Returns a token ID owned by `owner` at a given `index` of its token list.
    ///  Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);

    ///  dev: Returns a token ID at a given `index` of all the tokens stored by the contract.
    ///  Use along with {totalSupply} to enumerate all tokens.
    function tokenByIndex(uint256 index) external view returns (uint256);
}

///  @title ERC-721 Non-Fungible Token Standard, optional metadata extension
///  dev: See https://eips.ethereum.org/EIPS/eip-721
interface IERC721Metadata is IERC721 {
    ///  dev: Returns the token collection name.
    function name() external view returns (string memory);

    ///  dev: Returns the token collection symbol.
    function symbol() external view returns (string memory);

    ///  dev: Returns the Uniform Resource Identifier (URI) for `tokenId` token.
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

///  @title ERC721 token receiver interface
///  dev: Interface for any contract that wants to support safeTransfers
///  from ERC721 asset contracts.
interface IERC721Receiver {
    ///  dev: Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
    ///  by `operator` from `from`, this function is called.
    ///  It must return its Solidity selector to confirm the token transfer.
    ///  If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
    ///  The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

///  dev: Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
///  the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
///  Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
///  Does not support burning tokens to address(0).
///  Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
    using Address for address;
    using Strings for uint256;

    struct TokenOwnership {
        address addr;
        uint64 startTimestamp;
    }

    struct AddressData {
        uint128 balance;
        uint128 numberMinted;
    }

    uint256 internal _currentIndex;
    string private _name;
    string private _symbol;
    mapping(uint256 => TokenOwnership) internal _ownerships;
    mapping(address => AddressData) private _addressData;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    ///  dev: See {IERC721Enumerable-totalSupply}.
    function totalSupply() override public view returns (uint256) {
        return _currentIndex;
    }

    ///  dev: See {IERC721Enumerable-tokenByIndex}.
    function tokenByIndex(uint256 index) override public view returns (uint256) {
        if (index >= totalSupply()) revert TokenIndexOutOfBounds();
        return index;
    }

    ///  dev: See {IERC721Enumerable-tokenOfOwnerByIndex}.
    ///  This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
    ///  It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
    function tokenOfOwnerByIndex(address owner, uint256 index) override public view returns (uint256 a) {
        if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
        uint256 numMintedSoFar = totalSupply();
        uint256 tokenIdsIdx;
        address currOwnershipAddr;
        unchecked {
            for (uint256 i; i < numMintedSoFar; i++) {
                TokenOwnership memory ownership = _ownerships[i];
                if (ownership.addr != address(0)) {
                    currOwnershipAddr = ownership.addr;
                }
                if (currOwnershipAddr == owner) {
                    if (tokenIdsIdx == index) {
                        return i;
                    }
                    tokenIdsIdx++;
                }
            }
        }
        assert(false);
    }

    ///  dev: See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId) virtual override(ERC165, IERC165) public view returns (bool) {
        return (((interfaceId == type(IERC721).interfaceId) || (interfaceId == type(IERC721Metadata).interfaceId)) || (interfaceId == type(IERC721Enumerable).interfaceId)) || super.supportsInterface(interfaceId);
    }

    ///  dev: See {IERC721-balanceOf}.
    function balanceOf(address owner) override public view returns (uint256) {
        if (owner == address(0)) revert BalanceQueryForZeroAddress();
        return uint256(_addressData[owner].balance);
    }

    function _numberMinted(address owner) internal view returns (uint256) {
        if (owner == address(0)) revert MintedQueryForZeroAddress();
        return uint256(_addressData[owner].numberMinted);
    }

    ///  Gas spent here starts off proportional to the maximum mint batch size.
    ///  It gradually moves to O(1) as tokens get transferred around in the collection over time.
    function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
        if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
        unchecked {
            for (uint256 curr = tokenId; curr >= 0; curr--) {
                TokenOwnership memory ownership = _ownerships[curr];
                if (ownership.addr != address(0)) {
                    return ownership;
                }
            }
        }
        revert UnableDetermineTokenOwner();
    }

    ///  dev: See {IERC721-ownerOf}.
    function ownerOf(uint256 tokenId) override public view returns (address) {
        return ownershipOf(tokenId).addr;
    }

    ///  dev: See {IERC721Metadata-name}.
    function name() virtual override public view returns (string memory) {
        return _name;
    }

    ///  dev: See {IERC721Metadata-symbol}.
    function symbol() virtual override public view returns (string memory) {
        return _symbol;
    }

    ///  dev: See {IERC721Metadata-tokenURI}.
    function tokenURI(uint256 tokenId) virtual override public view returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
        string memory baseURI = _baseURI();
        return (bytes(baseURI).length != 0) ? string(abi.encodePacked(baseURI, tokenId.toString(), "")) : "";
    }

    ///  dev: Base URI for computing {tokenURI}. If set, the resulting URI for each
    ///  token will be the concatenation of the `baseURI` and the `tokenId`. Empty
    ///  by default, can be overriden in child contracts.
    function _baseURI() virtual internal view returns (string memory) {
        return "";
    }

    ///  dev: See {IERC721-approve}.
    function approve(address to, uint256 tokenId) override public {
        address owner = ERC721A.ownerOf(tokenId);
        if (to == owner) revert ApprovalToCurrentOwner();
        if ((_msgSender() != owner) && (!isApprovedForAll(owner, _msgSender()))) revert ApprovalCallerNotOwnerNorApproved();
        _approve(to, tokenId, owner);
    }

    ///  dev: See {IERC721-getApproved}.
    function getApproved(uint256 tokenId) override public view returns (address) {
        if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
        return _tokenApprovals[tokenId];
    }

    ///  dev: See {IERC721-setApprovalForAll}.
    function setApprovalForAll(address operator, bool approved) override public {
        if (operator == _msgSender()) revert ApproveToCaller();
        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    ///  dev: See {IERC721-isApprovedForAll}.
    function isApprovedForAll(address owner, address operator) virtual override public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    ///  dev: See {IERC721-transferFrom}.
    function transferFrom(address from, address to, uint256 tokenId) virtual override public {
        _transfer(from, to, tokenId);
    }

    ///  dev: See {IERC721-safeTransferFrom}.
    function safeTransferFrom(address from, address to, uint256 tokenId) virtual override public {
        safeTransferFrom(from, to, tokenId, "");
    }

    ///  dev: See {IERC721-safeTransferFrom}.
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) override public {
        _transfer(from, to, tokenId);
        if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
    }

    ///  dev: Returns whether `tokenId` exists.
    ///  Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
    ///  Tokens start existing when they are minted (`_mint`),
    function _exists(uint256 tokenId) internal view returns (bool) {
        return tokenId < _currentIndex;
    }

    function _safeMint(address to, uint256 quantity) internal {
        _safeMint(to, quantity, "");
    }

    ///  dev: Safely mints `quantity` tokens and transfers them to `to`.
    ///  Requirements:
    ///  - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
    ///  - `quantity` must be greater than 0.
    ///  Emits a {Transfer} event.
    function _safeMint(address to, uint256 quantity, bytes memory _data) internal {
        _mint(to, quantity, _data, true);
    }

    ///  dev: Mints `quantity` tokens and transfers them to `to`.
    ///  Requirements:
    ///  - `to` cannot be the zero address.
    ///  - `quantity` must be greater than 0.
    ///  Emits a {Transfer} event.
    function _mint(address to, uint256 quantity, bytes memory _data, bool safe) internal {
        uint256 startTokenId = _currentIndex;
        if (to == address(0)) revert MintToZeroAddress();
        unchecked {
            _addressData[to].balance += uint128(quantity);
            _addressData[to].numberMinted += uint128(quantity);
            _ownerships[startTokenId].addr = to;
            _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
            uint256 updatedIndex = startTokenId;
            for (uint256 i; i < quantity; i++) {
                emit Transfer(address(0), to, updatedIndex);
                if (safe && (!_checkOnERC721Received(address(0), to, updatedIndex, _data))) {
                    revert TransferToNonERC721ReceiverImplementer();
                }
                updatedIndex++;
            }
            _currentIndex = updatedIndex;
        }
        _afterTokenTransfers(address(0), to, startTokenId, quantity);
    }

    ///  dev: Transfers `tokenId` from `from` to `to`.
    ///  Requirements:
    ///  - `to` cannot be the zero address.
    ///  - `tokenId` token must be owned by `from`.
    ///  Emits a {Transfer} event.
    function _transfer(address from, address to, uint256 tokenId) private {
        TokenOwnership memory prevOwnership = ownershipOf(tokenId);
        bool isApprovedOrOwner = (((_msgSender() == prevOwnership.addr) || (getApproved(tokenId) == _msgSender())) || isApprovedForAll(prevOwnership.addr, _msgSender()));
        if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
        if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
        if (to == address(0)) revert TransferToZeroAddress();
        _approve(address(0), tokenId, prevOwnership.addr);
        unchecked {
            _addressData[from].balance -= 1;
            _addressData[to].balance += 1;
            _ownerships[tokenId].addr = to;
            _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
            uint256 nextTokenId = tokenId + 1;
            if (_ownerships[nextTokenId].addr == address(0)) {
                if (_exists(nextTokenId)) {
                    _ownerships[nextTokenId].addr = prevOwnership.addr;
                    _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
                }
            }
        }
        emit Transfer(from, to, tokenId);
        _afterTokenTransfers(from, to, tokenId, 1);
    }

    ///  dev: Approve `to` to operate on `tokenId`
    ///  Emits a {Approval} event.
    function _approve(address to, uint256 tokenId, address owner) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    ///  dev: Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
    ///  The call is not executed if the target address is not a contract.
    ///  @param from address representing the previous owner of the given token ID
    ///  @param to target address that will receive the tokens
    ///  @param tokenId uint256 ID of the token to be transferred
    ///  @param _data bytes optional data to send along with the call
    ///  @return bool whether the call correctly returned the expected magic value
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer(); else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    ///  dev: Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
    ///  startTokenId - the first token id to be transferred
    ///  quantity - the amount to be transferred
    ///  Calling conditions:
    ///  - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
    ///  transferred to `to`.
    ///  - When `from` is zero, `tokenId` will be minted for `to`.
    function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) virtual internal {}

    ///  dev: Hook that is called after a set of serially-ordered token ids have been transferred. This includes
    ///  minting.
    ///  startTokenId - the first token id to be transferred
    ///  quantity - the amount to be transferred
    ///  Calling conditions:
    ///  - when `from` and `to` are both non-zero.
    ///  - `from` and `to` are never both zero.
    function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) virtual internal {}
}

abstract contract Ownable is Context {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address private _owner;

    ///  dev: Throws if called by any account other than the owner.
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    ///  dev: Initializes the contract setting the deployer as the initial owner.
    constructor() {
        _transferOwnership(_msgSender());
    }

    ///  dev: Returns the address of the current owner.
    function owner() virtual public view returns (address) {
        return _owner;
    }

    ///  dev: Leaves the contract without owner. It will not be possible to call
    ///  `onlyOwner` functions anymore. Can only be called by the current owner.
    ///  NOTE: Renouncing ownership will leave the contract without an owner,
    ///  thereby removing any functionality that is only available to the owner.
    function renounceOwnership() virtual public onlyOwner() {
        _transferOwnership(address(0));
    }

    ///  dev: Transfers ownership of the contract to a new account (`newOwner`).
    ///  Can only be called by the current owner.
    function transferOwnership(address newOwner) virtual public onlyOwner() {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    ///  dev: Transfers ownership of the contract to a new account (`newOwner`).
    ///  Internal function without access restriction.
    function _transferOwnership(address newOwner) virtual internal {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

library MerkleProof {
    ///  dev: Returns true if a `leaf` can be proved to be a part of a Merkle tree
    ///  defined by `root`. For this, a `proof` must be provided, containing
    ///  sibling hashes on the branch from the leaf to the root of the tree. Each
    ///  pair of leaves and each pair of pre-images are assumed to be sorted.
    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    ///  dev: Returns the rebuilt hash obtained by traversing a Merkle tree up
    ///  from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
    ///  hash matches the root of the tree. When processing the proof, the pairs
    ///  of leafs & pre-images are assumed to be sorted.
    ///  _Available since v4.4._
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (computedHash <= proofElement) {
                computedHash = _efficientHash(computedHash, proofElement);
            } else {
                computedHash = _efficientHash(proofElement, computedHash);
            }
        }
        return computedHash;
    }

    function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}

contract Bad_Guys_by_RPF is ERC721A, Ownable {
    using Strings for uint256;

    uint256 public maxsupply = 1221;
    uint256 public reserve = 100;
    bool public isPaused = true;
    string public _baseURI1;
    bytes32 private rootHash;
    bool public revealed = false;
    string public notRevealedUri;

    constructor(bytes32 finalRootHash, string memory _NotRevealedUri) ERC721A("Bad Guys by RPF","BGRPF") {
        rootHash = finalRootHash;
        setNotRevealedURI(_NotRevealedUri);
    }

    function flipPauseMinting() public onlyOwner() {
        isPaused = !isPaused;
    }

    function setRootHash(bytes32 _updatedRootHash) public onlyOwner() {
        rootHash = _updatedRootHash;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner() {
        _baseURI1 = _newBaseURI;
    }

    function _baseURI() virtual override internal view returns (string memory) {
        return _baseURI1;
    }

    function setReserve(uint256 _reserve) public onlyOwner() {
        require(_reserve <= maxsupply, "the quantity exceeds");
        reserve = _reserve;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner() {
        notRevealedUri = _notRevealedURI;
    }

    function reveal() public onlyOwner() {
        revealed = !revealed;
    }

    function mintReservedTokens(uint256 quantity) public onlyOwner() {
        require(quantity <= reserve, "All reserve tokens have bene minted");
        reserve -= quantity;
        _safeMint(msg.sender, quantity);
    }

    function WhiteListMint_check(bytes32[] calldata _merkleProof, uint256 chosenAmount) public view returns (bool) {
        require((_numberMinted(msg.sender) + chosenAmount) <= 1, "Already Claimed");
        require(isPaused == false, "turn on minting");
        require(chosenAmount > 0, "Number Of Tokens Can Not Be Less Than Or Equal To 0");
        require((totalSupply() + chosenAmount) <= (maxsupply - reserve), "all tokens have been minted");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_merkleProof, rootHash, leaf), "Invalid Proof");
        return true;
    }

    /// @dev { WhiteListMint(_merkleProof, chosenAmount)
    ///       requires { WhiteListMint_check(_merkleProof, chosenAmount) }
    ///  }
    function WhiteListMint_original(bytes32[] calldata _merkleProof, uint256 chosenAmount) private {
        _safeMint(msg.sender, chosenAmount);
    }

    function tokenURI(uint256 tokenId) virtual override public view returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        if (revealed == false) {
            return notRevealedUri;
        }
        string memory currentBaseURI = _baseURI();
        return (bytes(currentBaseURI).length > 0) ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json")) : "";
    }

    function withdraw() public onlyOwner() {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function _WhiteListMint_pre(bytes32[] calldata _merkleProof, uint256 chosenAmount) private {
        if (!(WhiteListMint_check(_merkleProof, chosenAmount))) revert();
    }

    function WhiteListMint(bytes32[] calldata _merkleProof, uint256 chosenAmount) public {
        _WhiteListMint_pre(_merkleProof, chosenAmount);
        WhiteListMint_original(_merkleProof, chosenAmount);
    }
}
