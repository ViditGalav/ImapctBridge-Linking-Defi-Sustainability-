// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract RentalContract {
    address public owner;
    
    struct Project {
        uint projectId;
        address payable borrower;
        uint amount; //loan amount
        uint interestRate;
        uint totalRepaid;
        bool isClosed;
        bool isLoanApproved;
        uint convenienceFee;
    }

    Project[] public projects;
    //maaping that maps each investor's address with its projects(project Id)
    mapping(address => uint[]) public investorProjects;
    //mapping that maps each project Id with their investor and their corresponding contributions 
    mapping(uint => mapping(address => uint)) public investorContributions;

    constructor() {
        owner = msg.sender;
    }

    event LogMessage(string message);

    // Investor can approve the loan by entering 1.
    function approveLoan(uint _projectId, uint _approval) public  {
        uint approval = _approval;
        Project memory project = projects[_projectId];
        require(project.isClosed != true, "Loan is already closed");
        require(msg.sender != project.borrower, "Borrower cannot approve their own loan");
        if(approval == 1){
            project.isLoanApproved=true;        
            investorContributions[_projectId][msg.sender] = project.amount;
            investorProjects[msg.sender].push(_projectId);
            amountTransfer(_projectId);
        }
    }

    // function to transfer amount.
    function amountTransfer(uint _projectId) public payable {
        Project memory project = projects[_projectId];
        require(msg.sender != project.borrower, "Borrower can't transfer money to itself");
        project.convenienceFee = (5*project.amount)/100;
        require(msg.value == project.amount + project.convenienceFee, "Amount not sufficient");
        project.borrower.transfer(project.amount);
    }

    // Borrower can repay the loan.
    function makeRepayment(uint _projectId, uint _amount) view public {
        Project memory project = projects[_projectId];
        require(!project.isClosed, "Loan is already closed"); 
        require(msg.sender == project.borrower, "Only the borrower can make repayments");  
        project.convenienceFee = (5*project.amount)/100;             
        uint remainingAmount = project.convenienceFee + project.amount + (project.amount * project.interestRate / 100) - project.totalRepaid;
        require(_amount <= remainingAmount, "Repayment amount exceeds remaining balance");
        project.totalRepaid += _amount;
        if (project.totalRepaid >= project.amount + (project.amount * project.interestRate / 100)) {
            project.isClosed = true;
        }
    }   

    // To view the projects in which the investor has invested.
    function getInvestorProjects(address _investor) public  view returns (uint[] memory) {
        return investorProjects[_investor];
    }
    
    // To view the project details.
    function getProjectDetails(uint _projectId) public  view returns (Project memory) {
        return projects[_projectId];
    }

}
