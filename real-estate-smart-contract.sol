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
    
    // Events to track contract state changes
    event SellerApproval(bool approved);
    event BuyerApproval(bool approved);
    event ContractSigned(bool signed);
    
    // Constructor function to initialize the contract
    constructor(address payable _seller, address payable _buyer, string memory _propertyAddress, uint _price) {
        seller = _seller;
        buyer = _buyer;
        propertyAddress = _propertyAddress;
        price = _price;
    }
    
    // Function for the seller to approve the contract
    function approveSeller() public {
        require(msg.sender == seller, "Only the seller can approve the contract.");
        sellerApproved = true;
        emit SellerApproval(true);
    }
    
    // Function for the buyer to approve the contract
    function approveBuyer() public {
        require(msg.sender == buyer, "Only the buyer can approve the contract.");
        buyerApproved = true;
        emit BuyerApproval(true);
    }
    
    // Function to sign the contract
    function signContract() public {
        require(sellerApproved && buyerApproved, "Both parties must approve the contract before it can be signed.");
        require(msg.sender == buyer, "Only the buyer can sign the contract.");
        contractSigned = true;
        seller.transfer(price);
        emit ContractSigned(true);
    }
}
