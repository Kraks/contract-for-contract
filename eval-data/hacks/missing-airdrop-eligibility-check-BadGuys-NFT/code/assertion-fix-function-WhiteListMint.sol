contract Bad_Guys_by_RPF is ERC721A, Ownable {
    // variables
    using Strings for uint256;

    constructor(
        bytes32 finalRootHash,
        string memory _NotRevealedUri
    ) ERC721A("Bad Guys by RPF", "BGRPF") {
        rootHash = finalRootHash;
        setNotRevealedURI(_NotRevealedUri);
    }

    uint256 public maxsupply = 1221;
    uint256 public reserve = 100;

    bool public isPaused = true;
    string public _baseURI1;
    bytes32 private rootHash;
    // revealed uri variables
    
    bool public revealed = false;
    string public notRevealedUri;


    function flipPauseMinting() public onlyOwner {
        isPaused = !isPaused;
    }

    function setRootHash(bytes32 _updatedRootHash) public onlyOwner {
        rootHash = _updatedRootHash;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        _baseURI1 = _newBaseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURI1;
    }

    function setReserve(uint256 _reserve) public onlyOwner {
        require(_reserve <= maxsupply, "the quantity exceeds");
        reserve = _reserve;
    }
        
    // set reaveal uri just in case

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    // setting reaveal only time can possible
    //only owner
    function reveal() public onlyOwner {
        revealed = !revealed;
    }

    function mintReservedTokens(uint256 quantity) public onlyOwner {
        require(quantity <= reserve, "All reserve tokens have bene minted");
        reserve -= quantity;
        _safeMint(msg.sender, quantity);
    }

    function WhiteListMint(bytes32[] calldata _merkleProof, uint256 chosenAmount)
        public
    {
        require(_numberMinted(msg.sender) + chosenAmount <= 1, "Already Claimed");
        require(isPaused == false, "turn on minting");
        require(
            chosenAmount > 0,
            "Number Of Tokens Can Not Be Less Than Or Equal To 0"
        );
        require(
            totalSupply() + chosenAmount <= maxsupply - reserve,
            "all tokens have been minted"
        );
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(_merkleProof, rootHash, leaf),
            "Invalid Proof"
        );
        _safeMint(msg.sender, chosenAmount);
    }

    // setting up the reaveal functionality

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (revealed == false) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        ".json"
                    )
                )
                : "";
    }

   function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
