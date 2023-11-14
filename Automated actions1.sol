// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract RiskContract {
    uint public investedAmount;
    uint public payoutAmount; // Payout amount in the event of a risk event
    uint public riskThreshold; // Project value * (Risk Threshold% / 100)
    uint public _riskScore;

    struct Project {
        uint riskThreshold;
        uint riskPercentage;
    }

    mapping(address => Project) public projects;

    struct Risk {
        string threat;
        uint riskProbability;
        uint riskImpact;
    }

    Risk[] public risks; 

    constructor(uint _investedAmount, uint256 _riskThreshold) {
        investedAmount = _investedAmount;
        payoutAmount = (_investedAmount / 2); // Since 50% of the invested amount is returned.
        riskThreshold = _riskThreshold;
    }
    
    function calcRiskScore() internal returns(uint) {
        _riskScore = 0; // Initialize the risk score
        
        for(uint i = 0; i < risks.length; i++) {
            // Risk Score = summation of (riskProbability * riskImpact) for all risks
            _riskScore += risks[i].riskProbability * risks[i].riskImpact;
        }
        return _riskScore;
    }

    modifier projectRegistered(address _projectId) {
        require(projects[_projectId].riskThreshold > 0, "Project not registered.");
        _;
    }

    function checkRiskAndTriggerPayout() external projectRegistered(msg.sender) {
        calcRiskScore(); 
        if (_riskScore >= riskThreshold) {
            // Transfer payoutAmount to the project
            payable(msg.sender).transfer(payoutAmount);
        }
    }

    function calcRiskPercentage(address _projectId) public view returns(uint){
        Project memory project = projects[_projectId];
        project.riskPercentage = (_riskScore/riskThreshold)*100;
        return project.riskPercentage;
    }
}
