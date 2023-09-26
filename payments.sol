// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract payment{

uint256 public goal;
uint256 public fundRaised;
uint256 public timeLimit;
bool public goalReached;
address public projectOwner=0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7;

constructor(uint _goalInEther, uint _timeLimit){
    goal=_goalInEther*1 ether;
    timeLimit= block.timestamp+ _timeLimit*30 days;
}

//investor address and amount he has invested is begin mappped
mapping(address=> uint256 ) public InvestorContributions;



function  Invest() public payable {
    require(msg.value>0,"Amount should be greater than zero");
    require(block.timestamp<timeLimit,"Time limit has ended");
    InvestorContributions[msg.sender]+=msg.value;
    fundRaised +=msg.value;


    if(fundRaised>=goal){
        goalReached = true;
    }

}

function Withdraw() public{
    require(msg.sender == projectOwner,"Only the project owner can withdraw funds");
    payable(projectOwner).transfer(fundRaised);
    }

function refund() public{
    require(block.timestamp>=timeLimit,"money can be refunded only after the timelimit");
    uint256 RefundAmount= InvestorContributions[msg.sender];
    require(RefundAmount>0, "You can't get refund, as you didn't invest funds");
    InvestorContributions[msg.sender]=0;
    fundRaised -= RefundAmount;
    payable(msg.sender).transfer(RefundAmount);
}






}