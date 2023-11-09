// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.9.0;

import "./InvestorReturns.sol";

contract FundAllocationVote {
    uint256 public minThreshold;

    uint256 public yesVotes;

    uint256 public totalVotes;

    uint256 public poolFunds;

    uint256 public requestedAmount;

    // Here project is located with an ID with its vote count with 0 index as yes and 1 as no
    // ID --> [yes votes , no votes ]
    mapping(uint256 => uint256[2]) public ProjectVotes;
    mapping(uint256 => bool) public ProjectVerify;

    // investor mapped with amount of impact token holdings
    mapping(address => uint256) public investors;

    constructor(
        uint256 _minThreshold,
        uint256 _poolFunds,
        uint256 _requestedAmount
    ) {
        minThreshold = _minThreshold;
        poolFunds = _poolFunds;
        requestedAmount = _requestedAmount;
    }

    modifier onEsgApproved{
        
        // statement here needs to be changed accoridng to the strucutre of esg contract so as
        // to check for the score 

        // require(ESG[projectId]>=7.5,"Not enough ESG score");  

        _;
    }




    function castVote(
        uint256 projectId,
        uint256 choice,
        uint256 voteCount
    ) public onEsgApproved {
        require(choice == 1 || choice == 2, "Wrong Choice");
        require(ProjectVerify[projectId] == true, "Not Valid Project");
        require(
            voteCount <= investors[msg.sender] && investors[msg.sender] > 0,
            "Not enough Impact Token"
        );
        ProjectVotes[projectId][choice - 1] += voteCount;
        investors[msg.sender] -= voteCount;
    }

    function calculateAllocation(
        uint256 projectId
    ) onEsgApproved internal view returns (uint256) {
        uint256 yesVote = ProjectVotes[projectId][0];
        uint256 noVote = ProjectVotes[projectId][1];

        uint256 yesPercentage = (yesVote * 100) / (yesVotes + noVote);

        uint256 Allocation = (yesPercentage * poolFunds) / 100;

        if (Allocation < minThreshold) {
            uint256 additionalFundsRequired = minThreshold - Allocation;
            Allocation += additionalFundsRequired;
        }

        if (Allocation > requestedAmount) {
            Allocation = requestedAmount;
        }

        return Allocation;
    }

    function transferFund(uint256 projectId) onEsgApproved private view {
        uint256 allocatedFund = calculateAllocation(projectId);

        // also we need to add projectOwner in project details
        // from projectId we get the project owners address, there in we tranfer the allocation to ....
    }
}
