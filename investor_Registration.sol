//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
import "./tokenCreation.sol"; // Import the Impact Token contract

contract InvestorRegistry {
    address public owner;
    ImpactToken public impactToken; // The Impact Token contract

    struct Investor {
        string name;
        string email;
        string nationality;
        bool registered;
        string investingPreference;
        uint tokenNumbers;
        string ipfsFinancialDocumentHash; // Renamed the field for IPFS document hash
    }

    mapping(address => Investor) public investors;

    event InvestorRegistered(
        address indexed investor,
        string indexed name,
        string indexed email,
        string nationality,
        bool registered,
        string ipfsFinancialDocumentHash
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        impactToken = ImpactToken(_tokenAddress); // Set the Impact Token contract address
    }

    function register(
        string memory name,
        string memory email,
        string memory nationality,
        string memory investingPreference,        
        string memory ipfsDocumentHash
        
    ) public {
        require(!investors[msg.sender].registered, "Investor already registered");
        require(bytes(ipfsDocumentHash).length > 0, "IPFS document hash cannot be empty");
        require(impactToken.balanceOf(msg.sender) > 0, "You must own Impact Tokens to register");

        investors[msg.sender] = Investor({
            name: name,
            email: email,
            nationality: nationality,
            investingPreference: investingPreference,
            registered: true,
            tokenNumbers: impactToken.balanceOf(msg.sender),
            ipfsFinancialDocumentHash: ipfsDocumentHash // Store IPFS document hash in the struct
        });

        emit InvestorRegistered(
            msg.sender,
            name,
            email,
            nationality,
            true,
            ipfsDocumentHash
        );
    }

     
}
