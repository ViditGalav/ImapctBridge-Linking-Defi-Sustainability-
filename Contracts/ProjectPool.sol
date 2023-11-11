// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ProjectRegistry.sol";

// Contract definition for ProjectPool
contract ProjectPool {
    // State variable to store the address of the ProjectRegistry contract
    ProjectRegistry public projectRegistry;

    // Event to log investor joins
    event InvestorJoinedPool(uint256 indexed projectId, uint256 investorId);

    // Mapping to track investors in each project pool
    mapping(uint256 => address[]) public projectPools;

    // Mapping to store investor IDs
    mapping(address => uint256) public investorIds;

    // Counter to generate unique investor IDs
    uint256 public investorIdCounter;

    // Constructor to initialize the ProjectRegistry contract address
    constructor(address _projectRegistry) {
        // Assign the provided ProjectRegistry address to projectRegistry state variable
        projectRegistry = ProjectRegistry(_projectRegistry);
    }

    // Modifier to ensure that an investor can only join a pool if they are not already part of it
    modifier poolNotExists(uint256 projectId) {
        // Check if the investor has not joined the pool for the specified project
        require(!isInvestorInPool(projectId, msg.sender), "Investor already in the pool");
        _; // Continue with the function execution if the modifier condition is satisfied
    }

    // Function to check if an investor is in a specific pool
    function isInvestorInPool(uint256 projectId, address investor) internal view returns (bool) {
        address[] storage pool = projectPools[projectId];
        for (uint256 i = 0; i < pool.length; i++) {
            if (pool[i] == investor) {
                return true;
            }
        }
        return false;
    }

    // Function to create a new pool for a project if it doesn't exist
    function createPoolIfNeeded(uint256 projectId) internal {
        // Check if the pool for the project doesn't exist, then create a new one
        if (projectPools[projectId].length == 0) {
            projectPools[projectId] = new address[](0);
        }
    }

    // Function to allow an investor to join a project pool
    function joinPool(uint256 projectId) external poolNotExists(projectId) {
        // Check if the project ID is valid by comparing it with the total project count
        require(
            projectId > 0 && projectId <= projectRegistry.projectCount(),
            "Invalid project ID"
        );

        // Create a new pool if it doesn't exist
        createPoolIfNeeded(projectId);

        // Generate a unique investor ID for the investor
        uint256 investorId = investorIdCounter++;
        investorIds[msg.sender] = investorId;

        // Join the pool by adding the investor to the project pool
        projectPools[projectId].push(msg.sender);

        // Log the investor join
        emit InvestorJoinedPool(projectId, investorId);
    }

    // Function to view investors in a project pool
    function viewInvestorsInPool(uint256 projectId) external view returns (address[] memory) {
        // Check if the project ID is valid by comparing it with the total project count
        require(
            projectId > 0 && projectId <= projectRegistry.projectCount(),
            "Invalid project ID"
        );

        // Return the list of investors in the project pool
        return projectPools[projectId];
    }
}
