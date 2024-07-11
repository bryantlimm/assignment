// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedMarketplace {
    // Struct to represent an item
    struct Item {
        uint id;
        string name;
        uint price;
        address payable seller;
        address buyer;
        bool isSold;
    }

    // Counter for unique item IDs
    uint private itemCounter;

    // Mapping to store items by their ID
    mapping(uint => Item) public items;

    // Mapping to track item ownership
    mapping(address => uint[]) public ownership;

    // Event emitted when an item is listed
    event ItemListed(uint id, string name, uint price, address seller);

    // Event emitted when an item is purchased
    event ItemPurchased(uint id, address buyer);

    // Event emitted when funds are withdrawn
    event FundsWithdrawn(address seller, uint amount);

    // Function to list an item for sale
    function listItem(string memory _name, uint _price) public {
        require(bytes(_name).length > 0, "Item name is required");
        require(_price > 0, "Price must be greater than zero");

        itemCounter++;
        items[itemCounter] = Item({
            id: itemCounter,
            name: _name,
            price: _price,
            seller: payable(msg.sender),
            buyer: address(0),
            isSold: false
        });

        emit ItemListed(itemCounter, _name, _price, msg.sender);
    }

    // Function to purchase an item
    function purchaseItem(uint _id) public payable {
        Item storage item = items[_id];

        require(item.id > 0, "Item does not exist");
        require(msg.value == item.price, "Incorrect Ether value sent");
        require(item.seller != msg.sender, "Seller cannot buy their own item");
        require(!item.isSold, "Item is already sold");

        item.isSold = true;
        item.buyer = msg.sender;
        ownership[msg.sender].push(_id);

        item.seller.transfer(msg.value);

        emit ItemPurchased(_id, msg.sender);
    }

    // Function for seller to withdraw funds
    function withdrawFunds() public {
        uint balance = address(this).balance;
        require(balance > 0, "No funds available for withdrawal");

        payable(msg.sender).transfer(balance);

        emit FundsWithdrawn(msg.sender, balance);
    }

    // Helper function to get items owned by a user
    function getItemsOwnedBy(address _owner) public view returns (uint[] memory) {
        return ownership[_owner];
    }
}
