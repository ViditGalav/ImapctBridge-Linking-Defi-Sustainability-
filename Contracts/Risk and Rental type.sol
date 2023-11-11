// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProjectPool.sol"; // Import the ProjectPool contract

contract ProjectRegistry {
    // Struct to represent project details
    struct ProjectDetails {
        string name; // Name of the project
        string techUsed; // Technology used in the project
        uint256 fundsRequired; // Funds required for the project
        string socialDocumentIPFSHash; // IPFS hash for social/environmental documents
        string environmentalDocumentIPFSHash; // IPFS hash for environmental documents
        string financeDocumentIPFSHash; // IPFS hash for finance documents
        string governanceDocumentIPFSHash; // IPFS hash for governance documents
        string goals; // Project goals
        string impact; // Project impact
        uint256 tokensToIssue; // Number of tokens to issue for the project
        bool isSeekingInvestment; // Flag to indicate if the project seeks investment
        bool isSeekingLoan; // Flag to indicate if the project seeks a loan
        uint256 loanInterestRate; // Annual interest rate for a loan (if seeking a loan)
        uint256 loanDuration; // Loan duration in months (if seeking a loan)
    }

    //Struct to represent Risks of the project
    struct Risk {
        string description;
        uint256 riskOccurrencePercentage; // Risk occurrence in percentage
        uint256 impact; // Impact of the risk in terms of loss
    }

    // Struct to represent a project
    struct Project {
        ProjectDetails details;
        Risk[] risks; // List of project risks
    }

    // Struct to represent an investment in a project
    struct Investment {
        address investor; // Investor's Ethereum address
        uint256 amount; // Amount invested
    }

    // Mapping to store projects by project ID
    mapping(uint256 => Project) public projects;

    // Mapping to store investments for each project
    mapping(uint256 => Investment[]) public projectInvestments;

    // Counter to keep track of the number of projects registered
    uint256 public projectCount;

    // Event to log the registration of a new project
    event ProjectRegistered(uint256 projectId, ProjectDetails details);

    // Event to log an investment in a project
    event InvestmentReceived(
        uint256 projectId,
        address indexed investor,
        uint256 amount
    );

    event RiskAdded(
        uint256 projectId,
        string description,
        uint256 riskOccurrencePercentage,
        uint256 impact
    );

// Function to register a new project
function registerProject(ProjectDetails memory details) public {
    // Check that project name, technology used, and funds required are provided and valid
    require(bytes(details.name).length > 0, "Project name cannot be empty");
    require(bytes(details.techUsed).length > 0, "Technology used cannot be empty");
    require(details.fundsRequired > 0, "Funds required must be greater than 0");

    // Increment projectCount to generate a unique project ID
    projectCount++;

    // Create a new Project struct and store it in the projects mapping
    projects[projectCount] = Project(details, new Risk[](0));

    // Check if the project owner is already mapped
    if (projectOwners[projectCount] == address(0)) {
        // Map the project owner
        projectOwners[projectCount] = msg.sender;
    }

    // Emit an event to log the registration of the new project
    emit ProjectRegistered(projectCount, details);
}

// Mapping to store the owner of each project
mapping(uint256 => address) public projectOwners;

//Function to add Risks to projects
    function addRiskToProject(
        uint256 projectId,
        string memory description,
        uint256 riskOccurrencePercentage,
        uint256 impact
    ) public {
        require(
            projectId > 0 && projectId <= projectCount,
            "Invalid project ID"
        );
        require(
            bytes(description).length > 0,
            "Risk description cannot be empty"
        );
        require(
            riskOccurrencePercentage >= 0 && riskOccurrencePercentage <= 100,
            "Risk occurrence percentage must be between 0 and 100"
        );
        require(impact >= 0, "Impact of risk must be non-negative");

        Project storage project = projects[projectId];
        project.risks.push(Risk(description, riskOccurrencePercentage, impact));

        emit RiskAdded(
            projectId,
            description,
            riskOccurrencePercentage,
            impact
        );
    }

    // Function to calculate the cumulative risk percentage for a project
    function calculateCumulativeRisk(
        uint256 projectId
    ) public view returns (uint256) {
        require(
            projectId > 0 && projectId <= projectCount,
            "Invalid project ID"
        );

        Project storage project = projects[projectId];
        uint256 totalRiskPercentage = 0;

        for (uint256 i = 0; i < project.risks.length; i++) {
            totalRiskPercentage += project.risks[i].riskOccurrencePercentage;
        }

        return totalRiskPercentage;
    }

    // Function to get the details of a specific project by project ID
    function getProjectDetails(
        uint256 projectId
    ) public view returns (ProjectDetails memory, Risk[] memory) {
        // Check if the project ID is valid
        require(
            projectId > 0 && projectId <= projectCount,
            "Invalid project ID"
        );

        // Retrieve and return the details of the project
        Project storage project = projects[projectId];
        return (project.details, project.risks);
    }

    // Function to update the details of an existing project
    function updateProjectDetails(
        uint256 projectId,
        ProjectDetails memory details
    ) public {
        // Check if the project ID is valid
        require(
            projectId > 0 && projectId <= projectCount,
            "Invalid project ID"
        );

        // Update the project details with the new values
        Project storage project = projects[projectId];
        project.details = details;
    }

    // Function to update the details of an existing project
    function updateProjectRisks(uint256 projectId, Risk[] memory risks) public {
        // Check if the project ID is valid
        require(
            projectId > 0 && projectId <= projectCount,
            "Invalid project ID"
        );

        // Update the risks for the project
        Project storage project = projects[projectId];

        // Clear existing risks
        delete project.risks;

        // Add new risks
        for (uint256 i = 0; i < risks.length; i++) {
            project.risks.push(
                Risk(
                    risks[i].description,
                    risks[i].riskOccurrencePercentage,
                    risks[i].impact
                )
            );
        }
    }

    // Function to allow investors to invest in a project
    function investInProject(uint256 projectId) external payable {
        // Check if the project ID is valid
        require(
            projectId > 0 && projectId <= projectCount,
            "Invalid project ID"
        );
        // Check that the investment amount is greater than 0
        require(msg.value > 0, "Investment amount must be greater than 0");

        // Store the investment details in the projectInvestments mapping
        projectInvestments[projectId].push(
            Investment({investor: msg.sender, amount: msg.value})
        );
        // Emit an event to log the investment
        emit InvestmentReceived(projectId, msg.sender, msg.value);
    }

    // Function to get the list of investments for a specific project
    function getProjectInvestments(
        uint256 projectId
    ) public view returns (Investment[] memory) {
        // Check if the project ID is valid
        require(
            projectId > 0 && projectId <= projectCount,
            "Invalid project ID"
        );
        // Return the list of investments for the project
        return projectInvestments[projectId];
    }

    // Function to calculate the percentage of total pool contribution by an investor
    function getInvestorContributionPercentage(
        uint256 projectId,
        address investor
    ) public view returns (uint256) {
        // Check if the project ID is valid
        require(
            projectId > 0 && projectId <= projectCount,
            "Invalid project ID"
        );

        Investment[] storage investments = projectInvestments[projectId];

        uint256 totalInvestment = 0;
        uint256 investorContribution = 0;

        for (uint256 i = 0; i < investments.length; i++) {
            Investment storage investment = investments[i];
            totalInvestment += investment.amount;
            if (investment.investor == investor) {
                investorContribution += investment.amount;
            }
        }

        if (totalInvestment == 0) {
            return 0; // Avoid division by zero
        }

        return (investorContribution * 100) / totalInvestment;
    }

    /*
    // Function to allow investors to withdraw their investments from a project
    function withdrawInvestment(uint256 projectId) public {
        // Check if the project ID is valid
        require(projectId > 0 && projectId <= projectCount, "Invalid project ID");
        
        Investment[] storage investments = projectInvestments[projectId];
        
        for (uint256 i = 0; i < investments.length; i++) {
            Investment storage investment = investments[i];
            if (investment.investor == msg.sender) {
                payable(msg.sender).transfer(investment.amount);
                investment.amount = 0; // Set the investment amount to 0 to prevent double withdrawal
            }
        }
    }
    */
}
