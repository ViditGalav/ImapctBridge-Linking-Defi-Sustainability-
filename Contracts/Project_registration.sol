// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProjectRegistry {
    // Struct to represent a project
    struct Project {
        string name;
        string techUsed;
        uint256 fundsRequired;
    }

    // Mapping to store projects by their unique project ID
    mapping(uint256 => Project) public projects;

    // Counter to keep track of the number of registered projects
    uint256 public projectCount;

    // Event to log project registration
    event ProjectRegistered(uint256 projectId, string name, string techUsed, uint256 fundsRequired);

    // Function to register a new project
    function registerProject(string memory _name, string memory _techUsed, uint256 _fundsRequired) public {
        require(bytes(_name).length > 0, "Project name cannot be empty");
        require(bytes(_techUsed).length > 0, "Technology used cannot be empty");
        require(_fundsRequired > 0, "Funds required must be greater than 0");

        // Increment the project count to generate a unique project ID
        projectCount++;

        // Store the project details in the mapping
        projects[projectCount] = Project(_name, _techUsed, _fundsRequired);

        // Emit an event to log the project registration
        emit ProjectRegistered(projectCount, _name, _techUsed, _fundsRequired);
    }

    // Function to get project details by project ID
    function getProjectDetails(uint256 projectId) public view returns (string memory, string memory, uint256) {
        require(projectId > 0 && projectId <= projectCount, "Invalid project ID");
        
        Project storage project = projects[projectId];
        return (project.name, project.techUsed, project.fundsRequired);
    }

    // Function to update project details by project ID
    function updateProjectDetails(uint256 projectId, string memory _name, string memory _techUsed, uint256 _fundsRequired) public {
        require(projectId > 0 && projectId <= projectCount, "Invalid project ID");
        require(bytes(_name).length > 0, "Project name cannot be empty");
        require(bytes(_techUsed).length > 0, "Technology used cannot be empty");
        require(_fundsRequired > 0, "Funds required must be greater than 0");

        // Update the project details in the mapping
        projects[projectId] = Project(_name, _techUsed, _fundsRequired);
    }
}
