pragma solidity ^0.5.0;

contract AdvancedTokenVote1202 {
    event OnVote(uint issueId, address indexed _from, uint _value);

    event OnStatusChange(uint issueId, bool newIsOpen);

    mapping(uint => string) public issueDescriptions;
    mapping(uint => uint[]) internal options;
    mapping(uint => mapping(uint => string)) internal optionDescMap;
    mapping(uint => bool) internal isOpen;
    mapping(uint => mapping(address => uint256)) public weights;
    mapping(uint => mapping(uint => uint256)) public weightedVoteCounts;
    mapping(uint => mapping(address => uint)) public ballots;

    constructor() public {
        optionDescMap[0][1] = "No";
        optionDescMap[0][2] = "Yes, 100 more";
        optionDescMap[0][3] = "Yes, 200 more";
        optionDescMap[1][1] = "No";
        optionDescMap[1][2] = "Yes";
    }

    /// @dev {
    ///  createIssue(issueId, _tokenAddr, options_, qualifiedVoters_, issueDesc_)
    ///  	requires { options_.length >= 2 && options[issudId].length == 0 }
    ///  }
    function createIssue_original(uint issueId, address _tokenAddr, uint[] memory options_, address[] memory qualifiedVoters_, string memory issueDesc_) private {
        options[issueId] = options_;
        isOpen[issueId] = true;
        for (uint i = 0; i < qualifiedVoters_.length; i++) {
            address voter = qualifiedVoters_[i];
            weights[issueId][voter] = 5;
        }
        issueDescriptions[issueId] = issueDesc_;
    }

    /// @dev {
    ///  	vote(issueId, option) returns (b)
    ///  	requires { isOpen[issueId] }
    ///  }
    function vote_original(uint issueId, uint option) private returns (bool success) {
        uint256 weight = weights[issueId][msg.sender];
        weightedVoteCounts[issueId][option] += weight;
        ballots[issueId][msg.sender] = option;
        emit OnVote(issueId, msg.sender, option);
        return true;
    }

    function setStatus(uint issueId, bool isOpen_) public returns (bool success) {
        isOpen[issueId] = isOpen_;
        emit OnStatusChange(issueId, isOpen_);
        return true;
    }

    function ballotOf(uint issueId, address addr) public view returns (uint option) {
        return ballots[issueId][addr];
    }

    function weightOf(uint issueId, address addr) public view returns (uint weight) {
        return weights[issueId][addr];
    }

    function getStatus(uint issueId) public view returns (bool isOpen_) {
        return isOpen[issueId];
    }

    function weightedVoteCountsOf(uint issueId, uint option) public view returns (uint count) {
        return weightedVoteCounts[issueId][option];
    }

    function winningOption(uint issueId) public view returns (uint option) {
        uint ci = 0;
        for (uint i = 1; i < options[issueId].length; i++) {
            uint optionI = options[issueId][i];
            uint optionCi = options[issueId][ci];
            if (weightedVoteCounts[issueId][optionI] > weightedVoteCounts[issueId][optionCi]) {
                ci = i;
            }
        }
        return options[issueId][ci];
    }

    function issueDescription(uint issueId) public view returns (string memory desc) {
        return issueDescriptions[issueId];
    }

    function availableOptions(uint issueId) public view returns (uint[] memory options_) {
        return options[issueId];
    }

    function optionDescription(uint issueId, uint option) public view returns (string memory desc) {
        return optionDescMap[issueId][option];
    }

    function _createIssue_pre(uint issueId, address _tokenAddr, uint[] memory options_, address[] memory qualifiedVoters_, string memory issueDesc_) private {
        if (!(options_.length>=2&&options[issueId].length==0)) revert();
    }

    function createIssue(uint issueId, address _tokenAddr, uint[] memory options_, address[] memory qualifiedVoters_, string memory issueDesc_) public {
        _createIssue_pre(issueId, _tokenAddr, options_, qualifiedVoters_, issueDesc_);
        createIssue_original(issueId, _tokenAddr, options_, qualifiedVoters_, issueDesc_);
    }

    function _vote_pre(uint issueId, uint option) private {
        if (!(isOpen[issueId])) revert();
    }

    function vote(uint issueId, uint option) public returns (bool success) {
        _vote_pre(issueId, option);
        bool b = vote_original(issueId, option);
        return (b);
    }
}
