// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract RiskContract {

    uint public payoutAmount; // Payout amount in the event of a risk event
    uint public riskThreshold; // = Project value + Project value*(Risk Threshold %/100)
    uint public _riskScore;

    struct Project {
        address projectAddress;
        uint riskThreshold;
    }
    mapping(address => Project) public projects;

    constructor(
        uint256 _payoutAmount,
        uint256 _riskThreshold
    ) {     
        payoutAmount = _payoutAmount;
        riskThreshold = _riskThreshold;
    }
    
    struct Risk {
        uint threat;
        uint riskPercentage;
        uint riskImpact;
    }

    // Array to store multiple risks
    Risk[] public risks; 

    // Function to calculate Risk Score.
    function calcRiskScore() public {
        _riskScore = 0; // Initialize the risk score
        
        for(uint i = 0; i < risks.length; i++) {
            // Risk Score = summation of (riskPercentage * riskImpact) for all risks
            _riskScore += risks[i].riskPercentage * risks[i].riskImpact;
        }
    }

    function checkRiskAndTriggerPayout() external payable {
        require(projects[msg.sender].projectAddress != address(0), "Project not registered.");
        calcRiskScore(); 
        
        if (_riskScore >= riskThreshold) {
            // Transfer payoutAmount to the project
            payable(msg.sender).transfer(payoutAmount);
        }
    }
}
