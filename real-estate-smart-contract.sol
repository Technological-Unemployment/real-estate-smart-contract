// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstateSalesContract {
    // Parties to the contract
    address payable public seller;
    address payable public buyer;
    
    // Property information
    string public propertyAddress;
    uint public price;
    
    // Contract state variables
    bool public sellerApproved;
    bool public buyerApproved;
    bool public contractSigned;
    uint public fundsReceived;

    // Modifiers
    modifier onlySeller() {
        require(msg.sender == seller, "Only the seller can perform this.");
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can perform this.");
        _;
    }

    // Events to track contract state changes
    event SellerApproval(bool approved);
    event BuyerApproval(bool approved);
    event ContractSigned(bool signed);
    event Received(address from, uint amount);

    // Constructor function to initialize the contract
    constructor(address payable _seller, address payable _buyer, string memory _propertyAddress, uint _price) {
        seller = _seller;
        buyer = _buyer;
        propertyAddress = _propertyAddress;
        price = _price;
    }
    
    // Function for the seller to approve the contract
    function approveSeller() public onlySeller {
        sellerApproved = true;
        emit SellerApproval(true);
    }
    
    // Function for the buyer to approve the contract
    function approveBuyer() public onlyBuyer {
        buyerApproved = true;
        emit BuyerApproval(true);
    }

    // Function to retract buyer's approval
    function retractBuyerApproval() public onlyBuyer {
        require(!contractSigned, "Contract is already signed.");
        buyerApproved = false;
        emit BuyerApproval(false);
    }

    // Function to retract seller's approval
    function retractSellerApproval() public onlySeller {
        require(!contractSigned, "Contract is already signed.");
        sellerApproved = false;
        emit SellerApproval(false);
    }
    
    // Function to sign the contract
    function signContract() public onlyBuyer {
        require(sellerApproved && buyerApproved, "Both parties must approve the contract before it can be signed.");
        require(fundsReceived >= price, "Insufficient funds transferred.");
        contractSigned = true;
        if (fundsReceived > price) {
            uint refundAmount = fundsReceived - price;
            payable(msg.sender).transfer(refundAmount); // Refund excess
        }
        seller.transfer(price);
        emit ContractSigned(true);
    }

    // This function allows the contract to receive funds.
    receive() external payable {
        fundsReceived += msg.value;
        emit Received(msg.sender, msg.value);
    }
}
