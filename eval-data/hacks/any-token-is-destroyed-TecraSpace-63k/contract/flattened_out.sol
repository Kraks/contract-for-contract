pragma solidity =0.8.2;

abstract contract IERC20 {
    function balanceOf(address owner) virtual public view returns (uint256);

    function transfer(address to, uint256 amount) virtual public;

    function allowance(address owner, address spender) virtual public view returns (uint256);

    function totalSupply() virtual public view returns (uint256);
}

abstract contract IUpgradedToken {
    function transferByLegacy(address sender, address to, uint256 amount) virtual public returns (bool);

    function transferFromByLegacy(address sender, address from, address to, uint256 amount) virtual public returns (bool);

    function approveByLegacy(address sender, address spender, uint256 amount) virtual public;
}

contract TcrToken {
    error preViolation(string funcName);

    error postViolation(string funcName);

    error preViolationAddr(uint256 specId);

    error postViolationAddr(uint256 specId);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Paused();

    event Unpaused();

    event Approval(address indexed owner, address indexed spender, uint256 value);

    event AddedToBlacklist(address indexed account);

    event RemovedFromBlacklist(address indexed account);

    uint8 public constant decimals = 8;
    string public constant name = "TecraCoin";
    string public constant symbol = "TCR";
    uint256 private _totalSupply;
    uint256 public constant maxSupply = 21000000000000000;
    string public constant version = "1";
    uint256 public immutable getChainId;
    address public owner;
    address public newOwner;
    bool public paused;
    bool public deprecated;
    address public upgradedAddress;
    bytes32 public immutable DOMAIN_SEPARATOR;
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    string private constant ERROR_DAS = "Different array sizes";
    string private constant ERROR_BTL = "Balance too low";
    string private constant ERROR_ATL = "Allowance too low";
    string private constant ERROR_OO = "Only Owner";
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => uint256) private _balances;
    mapping(address => bool) public isBlacklisted;
    mapping(address => bool) public isBlacklistAdmin;
    mapping(address => bool) public isMinter;
    mapping(address => bool) public isPauser;
    mapping(address => uint256) public nonces;

    modifier onlyBlacklister() {
        require(isBlacklistAdmin[msg.sender], "Not a Blacklister");
        _;
    }

    modifier notOnBlacklist(address user) {
        require(!isBlacklisted[user], "Address on blacklist");
        _;
    }

    modifier onlyMinter() {
        require(isMinter[msg.sender], "Not a Minter");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, ERROR_OO);
        _;
    }

    modifier onlyPauser() {
        require(isPauser[msg.sender], "Not a Pauser");
        _;
    }

    modifier notPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    constructor() {
        owner = msg.sender;
        getChainId = block.chainid;
        DOMAIN_SEPARATOR = keccak256(abi.encode(keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"), keccak256(bytes(name)), keccak256(bytes(version)), block.chainid, address(this)));
    }

    function approve(address spender, uint256 amount) external {
        if (deprecated) {
            return IUpgradedToken(upgradedAddress).approveByLegacy(msg.sender, spender, amount);
        }
        _approve(msg.sender, spender, amount);
    }

    function burn(uint256 amount) external {
        require(_balances[msg.sender] >= amount, ERROR_BTL);
        _burn(msg.sender, amount);
    }

    /// @custom:consol
    ///  {burnFrom(from, amount) returns ()
    ///      requires {_allowances[from][msg.sender] >= amount && _balances[from] >= amount}}
    function burnFrom_original(address from, uint256 amount) private {
        _approve(msg.sender, from, _allowances[from][msg.sender] - amount);
        _burn(from, amount);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        if (deprecated) {
            return IUpgradedToken(upgradedAddress).transferByLegacy(msg.sender, to, amount);
        }
        require(_balances[msg.sender] >= amount, ERROR_BTL);
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        if (deprecated) {
            return IUpgradedToken(upgradedAddress).transferFromByLegacy(msg.sender, from, to, amount);
        }
        _allowanceTransfer(msg.sender, from, to, amount);
        return true;
    }

    function acquire(address token) external onlyOwner() {
        if (token == address(0)) {
            payable(owner).transfer(address(this).balance);
        } else {
            uint256 amount = IERC20(token).balanceOf(address(this));
            require(amount > 0, ERROR_BTL);
            IERC20(token).transfer(owner, amount);
        }
    }

    function addBlacklister(address user) external onlyOwner() {
        isBlacklistAdmin[user] = true;
    }

    function removeBlacklister(address user) external onlyOwner() {
        isBlacklistAdmin[user] = false;
    }

    function addBlacklist(address user) external onlyBlacklister() {
        isBlacklisted[user] = true;
        emit AddedToBlacklist(user);
    }

    function removeBlacklist(address user) external onlyBlacklister() {
        isBlacklisted[user] = false;
        emit RemovedFromBlacklist(user);
    }

    function burnBlackFunds(address user) external onlyOwner() {
        require(isBlacklisted[user], "Address not on blacklist");
        _burn(user, _balances[user]);
    }

    function bulkTransfer(address[] calldata to, uint256[] calldata amount) external returns (bool) {
        require(to.length == amount.length, ERROR_DAS);
        for (uint256 i = 0; i < to.length; i++) {
            require(_balances[msg.sender] >= amount[i], ERROR_BTL);
            _transfer(msg.sender, to[i], amount[i]);
        }
        return true;
    }

    function bulkTransferFrom(address from, address[] calldata to, uint256[] calldata amount) external returns (bool) {
        require(to.length == amount.length, ERROR_DAS);
        for (uint256 i = 0; i < to.length; i++) {
            _allowanceTransfer(msg.sender, from, to[i], amount[i]);
        }
        return true;
    }

    function bulkTransfer(address[] calldata to, uint256 amount) external returns (bool) {
        require(_balances[msg.sender] >= (amount * to.length), ERROR_BTL);
        for (uint256 i = 0; i < to.length; i++) {
            _transfer(msg.sender, to[i], amount);
        }
        return true;
    }

    function bulkTransferFrom(address from, address[] calldata to, uint256 amount) external returns (bool) {
        require(_balances[from] >= (amount * to.length), ERROR_BTL);
        for (uint256 i = 0; i < to.length; i++) {
            _allowanceTransfer(msg.sender, from, to[i], amount);
        }
        return true;
    }

    function addMinter(address user) external onlyOwner() {
        isMinter[user] = true;
    }

    function removeMinter(address user) external onlyOwner() {
        isMinter[user] = false;
    }

    function mint(address to, uint256 amount) external onlyMinter() {
        _balances[to] += amount;
        _totalSupply += amount;
        require(_totalSupply < maxSupply, "You can not mine that much");
        emit Transfer(address(0), to, amount);
    }

    function giveOwnership(address _newOwner) external onlyOwner() {
        newOwner = _newOwner;
    }

    function acceptOwnership() external {
        require(msg.sender == newOwner, ERROR_OO);
        newOwner = address(0);
        owner = msg.sender;
    }

    function addPauser(address user) external onlyOwner() {
        isPauser[user] = true;
    }

    function removePauser(address user) external onlyOwner() {
        isPauser[user] = false;
    }

    function pause() external onlyPauser() notPaused() {
        paused = true;
        emit Paused();
    }

    function unpause() external onlyPauser() {
        require(paused, "Contract not paused");
        paused = false;
        emit Unpaused();
    }

    function permit(address user, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, "permit: EXPIRED");
        bytes32 digest = keccak256(abi.encodePacked("\u0019\u0001", DOMAIN_SEPARATOR, keccak256(abi.encode(PERMIT_TYPEHASH, user, spender, value, nonces[user]++, deadline))));
        address recoveredAddress = ecrecover(digest, v, r, s);
        require((recoveredAddress != address(0)) && (recoveredAddress == user), "permit: INVALID_SIGNATURE");
        _approve(user, spender, value);
    }

    function upgrade(address token) external onlyOwner() {
        deprecated = true;
        upgradedAddress = token;
    }

    function balanceOf(address account) external view returns (uint256) {
        if (deprecated) {
            return IERC20(upgradedAddress).balanceOf(account);
        }
        return _balances[account];
    }

    function allowance(address account, address spender) external view returns (uint256) {
        if (deprecated) {
            return IERC20(upgradedAddress).allowance(account, spender);
        }
        return _allowances[account][spender];
    }

    function totalSupply() external view returns (uint256) {
        if (deprecated) {
            return IERC20(upgradedAddress).totalSupply();
        }
        return _totalSupply;
    }

    function _approve(address account, address spender, uint256 amount) private notOnBlacklist(account) notOnBlacklist(spender) notPaused() {
        _allowances[account][spender] = amount;
        emit Approval(account, spender, amount);
    }

    function _allowanceTransfer(address spender, address from, address to, uint256 amount) private {
        require(_allowances[from][spender] >= amount, ERROR_ATL);
        require(_balances[from] >= amount, ERROR_BTL);
        if (_allowances[from][spender] != type(uint256).max) {
            _approve(from, spender, _allowances[from][spender] - amount);
        }
        _transfer(from, to, amount);
    }

    function _burn(address from, uint256 amount) private notPaused() {
        _balances[from] -= amount;
        _totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }

    function _transfer(address from, address to, uint256 amount) private notOnBlacklist(from) notOnBlacklist(to) notPaused() {
        require(to != address(0), "Use burn instead");
        require(from != address(0), "What a Terrible Failure");
        _balances[from] -= amount;
        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function _burnFrom_pre(address from, uint256 amount) private {
        if (!(_allowancesfrommsg.sender>=amount&&_balancesfrom>=amount)) revert preViolation("burnFrom");
    }

    function burnFrom(address from, uint256 amount) external {
        _burnFrom_pre(from, amount);
        burnFrom_original(from, amount);
    }
}