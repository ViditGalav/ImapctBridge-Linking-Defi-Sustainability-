// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./tokenCreation.sol"; 

contract InvestorRegistry {
    address public owner;
    ImpactToken public impactToken; 

    struct Investor {
        string name;
        string email;
        bool registered;
    }

    mapping(address => Investor) public investors;

    event InvestorRegistered(address indexed investor, string name, string email);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        impactToken = ImpactToken(_tokenAddress); // Set the Impact Token contract address
    }

    function register(string memory name, string memory email) public {
        require(!investors[msg.sender].registered, "Investor already registered");
        require(impactToken.balanceOf(msg.sender) > 0, "You must own Impact Tokens to register");

        investors[msg.sender] = Investor({
            name: name,
            email: email,
            registered: true
        });

        emit InvestorRegistered(msg.sender, name, email);
    }
}
