// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProjectRegistry {
    // Struct to represent project details
    struct Project {
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
        Risk[] risks; // List of project risks
    }

    //Struct to represent Risks of the project
        struct Risk {
        string description;
        uint256 riskOccurrencePercentage; // Risk occurrence in percentage
        uint256 impact; // Impact of the risk in terms of loss
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
    event ProjectRegistered(
        uint256 projectId,
        string name,
        string techUsed,
        uint256 fundsRequired,
        string socialDocumentIPFSHash,
        string environmentalDocumentIPFSHash,
        string financeDocumentIPFSHash,
        string governanceDocumentIPFSHash,
        string goals,
        string impact,
        uint256 tokensToIssue,
        bool isSeekingInvestment,
        bool isSeekingLoan,
        uint256 loanInterestRate,
        uint256 loanDuration
    );

    event InvestmentReceived(uint256 projectId, address indexed investor, uint256 amount);

    event RiskAdded(uint256 projectId, string description, uint256 riskOccurrencePercentage, uint256 impact);

    // Function to register a new project
    function registerProject(
        string memory _name,
        string memory _techUsed,
        uint256 _fundsRequired,
        string memory _socialDocumentIPFSHash,
        string memory _environmentalDocumentIPFSHash,
        string memory _financeDocumentIPFSHash,
        string memory _governanceDocumentIPFSHash,
        string memory _goals,
        string memory _impact,
        uint256 _tokensToIssue,
        bool _isSeekingInvestment,
        bool _isSeekingLoan,
        uint256 _loanInterestRate,
        uint256 _loanDuration
    ) public {
        // Check that project name, technology used, and funds required are provided and valid
        require(bytes(_name).length > 0, "Project name cannot be empty");
        require(bytes(_techUsed).length > 0, "Technology used cannot be empty");
        require(_fundsRequired > 0, "Funds required must be greater than 0");

        // Increment projectCount to generate a unique project ID
        projectCount++;

        // Create a new Project struct and store it in the projects mapping
        projects[projectCount] = Project(
            _name,
            _techUsed,
            _fundsRequired,
            _socialDocumentIPFSHash,
            _environmentalDocumentIPFSHash,
            _financeDocumentIPFSHash,
            _governanceDocumentIPFSHash,
            _goals,
            _impact,
            _tokensToIssue,
            _isSeekingInvestment,
            _isSeekingLoan,
            _loanInterestRate,
            _loanDuration
            new Risk[](0) // Initialize the risks as an empty array
        );

        // Emit an event to log the registration of the new project
        emit ProjectRegistered(
            projectCount,
            _name,
            _techUsed,
            _fundsRequired,
            _socialDocumentIPFSHash,
            _environmentalDocumentIPFSHash,
            _financeDocumentIPFSHash,
            _governanceDocumentIPFSHash,
            _goals,
            _impact,
            _tokensToIssue,
            _isSeekingInvestment,
            _isSeekingLoan,
            _loanInterestRate,
            _loanDuration
        );
    }

        function addRiskToProject(
        uint256 projectId,
        string memory description,
        uint256 riskOccurrencePercentage,
        uint256 impact
    ) public {
        require(projectId > 0 && projectId <= projectCount, "Invalid project ID");
        require(bytes(description).length > 0, "Risk description cannot be empty");
        require(riskOccurrencePercentage >= 0 && riskOccurrencePercentage <= 100, "Risk occurrence percentage must be between 0 and 100");
        require(impact >= 0, "Impact of risk must be non-negative");

        Project storage project = projects[projectId];
        project.risks.push(Risk(description, riskOccurrencePercentage, impact));

        emit RiskAdded(projectId, description, riskOccurrencePercentage, impact);
    }

    // Function to calculate the cumulative risk percentage for a project
    function calculateCumulativeRisk(uint256 projectId) public view returns (uint256) {
        require(projectId > 0 && projectId <= projectCount, "Invalid project ID");

        Project storage project = projects[projectId];
        uint256 totalRiskPercentage = 0;

        for (uint256 i = 0; i < project.risks.length; i++) {
            totalRiskPercentage += project.risks[i].riskOccurrencePercentage;
        }

        return totalRiskPercentage;
    }

    // Function to get the details of a specific project by project ID
    function getProjectDetails(uint256 projectId)
        public
        view
        returns (
            string memory,
            string memory,
            uint256,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            uint256
            bool,  // Investment or Borrow Money (true for investment, false for borrowing)
            uint256,  // Borrow Percentage (if borrowing)
            uint256,  // Borrow Duration (if borrowing)
            Risk[] memory  // Array of risks
        )
    {
        // Check if the project ID is valid
        require(projectId > 0 && projectId <= projectCount, "Invalid project ID");

        // Retrieve and return the details of the project
        Project storage project = projects[projectId];
        return (
            project.name,
            project.techUsed,
            project.fundsRequired,
            project.socialDocumentIPFSHash,
            project.environmentalDocumentIPFSHash,
            project.financeDocumentIPFSHash,
            project.governanceDocumentIPFSHash,
            project.goals,
            project.impact,
            project.tokensToIssue
            project.isSeekingInvestment,
            project.borrowPercentage,
            project.borrowDuration,
            project.risks
        );
    }

    // Function to update the details of an existing project
    function updateProjectDetails(
        uint256 projectId,
        string memory _name,
        string memory _techUsed,
        uint256 _fundsRequired,
        string memory _socialDocumentIPFSHash,
        string memory _environmentalDocumentIPFSHash,
        string memory _financeDocumentIPFSHash,
        string memory _governanceDocumentIPFSHash,
        string memory _goals,
        string memory _impact,
        uint256 _tokensToIssue,
        bool _isSeekingInvestment,
        uint256 _borrowPercentage,
        uint256 _borrowDuration,
        Risk[] memory _risks
    ) public {
        // Check if the project ID is valid
        require(projectId > 0 && projectId <= projectCount, "Invalid project ID");

        // Check that project name, technology used, and funds required are provided and valid
        require(bytes(_name).length > 0, "Project name cannot be empty");
        require(bytes(_techUsed).length > 0, "Technology used cannot be empty");
        require(_fundsRequired > 0, "Funds required must be greater than 0");

        // Update the project details with the new values
        projects[projectId] = Project(
            _name,
            _techUsed,
            _fundsRequired,
            _socialDocumentIPFSHash,
            _environmentalDocumentIPFSHash,
            _financeDocumentIPFSHash,
            _governanceDocumentIPFSHash,
            _goals,
            _impact,
            _tokensToIssue,
            _isSeekingInvestment,
            _borrowPercentage,
            _borrowDuration,
            _risks
        );
    }
    
    // Event to log an investment in a project
    event InvestmentReceived(uint256 projectId, address indexed investor, uint256 amount);

    // Function to allow investors to invest in a project
    function investInProject(uint256 projectId) external payable {
        // Check if the project ID is valid
        require(projectId > 0 && projectId <= projectCount, "Invalid project ID");
        // Check that the investment amount is greater than 0
        require(msg.value > 0, "Investment amount must be greater than 0");

        // Store the investment details in the projectInvestments mapping
        projectInvestments[projectId].push(Investment({investor: msg.sender, amount: msg.value}));
        // Emit an event to log the investment
        emit InvestmentReceived(projectId, msg.sender, msg.value);
    }

    // Function to get the list of investments for a specific project
    function getProjectInvestments(uint256 projectId) public view returns (Investment[] memory) {
        // Check if the project ID is valid
        require(projectId > 0 && projectId <= projectCount, "Invalid project ID");
        // Return the list of investments for the project
        return projectInvestments[projectId];
    }

    // Function to calculate the percentage of total pool contribution by an investor
    function getInvestorContributionPercentage(uint256 projectId, address investor) public view returns (uint256) {
        
        // Check if the project ID is valid
        require(projectId > 0 && projectId <= projectCount, "Invalid project ID");
        
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
