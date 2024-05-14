// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsurancePlatform {
    address public owner;
    
    // Struct to represent an insurance policy
    struct Policy {
        uint256 id;
        address holder;
        uint256 premium;
        uint256 payout;
        bool active;
    }
    
    // Mapping of policy ID to Policy
    mapping(uint256 => Policy) public policies;
    
    // Event to log policy creation
    event PolicyCreated(uint256 indexed id, address indexed holder, uint256 premium, uint256 payout);
    
    // Constructor to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }
    
    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }
    
    // Function to create a new insurance policy
    function createPolicy(uint256 _id, uint256 _premium, uint256 _payout) external payable {
        require(msg.value == _premium, "Incorrect premium amount sent");
        require(!policies[_id].active, "Policy ID already exists");
        
        policies[_id] = Policy(_id, msg.sender, _premium, _payout, true);
        
        emit PolicyCreated(_id, msg.sender, _premium, _payout);
    }
    
    // Function to file a claim and receive payout
    function fileClaim(uint256 _id) external {
        require(policies[_id].active, "Policy not found or already claimed");
        require(msg.sender == policies[_id].holder, "Only policy holder can file a claim");
        
        // Perform checks or verification before payout
        
        payable(msg.sender).transfer(policies[_id].payout);
        policies[_id].active = false;
    }
    
    // Function to withdraw contract balance (for owner)
    function withdrawBalance() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}