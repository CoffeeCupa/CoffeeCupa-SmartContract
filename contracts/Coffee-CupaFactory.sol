// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Coffee-Cupa.sol";

contract CoffeeCupaRouter {
    // Struct to store details of each deployed CoffeeCupa contract
    //Prigin:https://github.com/BernardOnuh/Coffe-Cupa-Smart-Contract/blob/main/contracts/Coffee-CupaFactory.sol
    struct CoffeeShop {
        address creator;
        string name;
        address coffeeShopAddress;
    }

    // Array to store all deployed coffee shops
    CoffeeShop[] public coffeeShops;

    // Mapping from creator address to their coffee shop address
    mapping(address => address) public creatorToCoffeeShop;

    // Event to log the deployment of a new CoffeeCupa contract
    event CoffeeShopCreated(address indexed creator, string name, address coffeeShopAddress);

    /**
     * @dev Deploy a new CoffeeCupa contract
     * @param _name Name of the coffee shop owner
     * @param _stablecoinAddress Address of the stablecoin contract
     */
    function createCoffeeShop(string memory _name, address _stablecoinAddress) public {
        // Deploy a new CoffeeCupa contract
        CoffeeCupa newCoffeeShop = new CoffeeCupa(_stablecoinAddress);

        // Transfer ownership of the new contract to the creator
        newCoffeeShop.transferOwnership(msg.sender);

        // Store the details of the new coffee shop
        CoffeeShop memory coffeeShop = CoffeeShop({
            creator: msg.sender,
            name: _name,
            coffeeShopAddress: address(newCoffeeShop)
        });

        coffeeShops.push(coffeeShop);

        // Update the mapping
        creatorToCoffeeShop[msg.sender] = address(newCoffeeShop);

        // Emit an event for the new coffee shop
        emit CoffeeShopCreated(msg.sender, _name, address(newCoffeeShop));
    }

    /**
     * @dev Get the number of deployed coffee shops
     * @return The number of deployed coffee shops
     */
    function getCoffeeShopCount() public view returns (uint256) {
        return coffeeShops.length;
    }

    /**
     * @dev Get the details of a deployed coffee shop by index
     * @param index The index of the coffee shop
     * @return The details of the coffee shop
     */
    function getCoffeeShop(uint256 index) public view returns (CoffeeShop memory) {
        require(index < coffeeShops.length, "Index out of bounds");
        return coffeeShops[index];
    }
}
