// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface for the ERC20 standard as defined in the EIP.
//Code Origin:https://github.com/BernardOnuh/Coffe-Cupa-Smart-Contract/blob/main/contracts/Coffee-Cupa.sol
interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract CoffeeCupa {
    // Event that logs the details of each donation
    event NewCoffee(
        address indexed from,
        uint256 timestamp,
        string name,
        string message,
        uint256 quantity
    );

    // Coffee struct to store details of each coffee purchased
    struct Coffee {
        address from;
        uint256 timestamp;
        string name;
        string message;
        uint256 quantity;
    }

    // List of all coffees purchased
    Coffee[] coffees;

    // Address of the contract owner
    address payable public owner;

    // Address of the stablecoin (e.g., USDT) contract
    IERC20 public stablecoin;
    uint256 public coffeePrice = 5 * 10**18; // 5 USDT (assuming 18 decimals)

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(address _stablecoinAddress) {
        // Set the owner to the address that deploys the contract
        owner = payable(msg.sender);

        // Initialize the stablecoin interface
        stablecoin = IERC20(_stablecoinAddress);
    }

    /**
     * @dev Transfer ownership of the contract to a new owner
     * @param newOwner Address of the new owner
     */
    function transferOwnership(address newOwner) public onlyOwner {
        owner = payable(newOwner);
    }

    /**
     * @dev Buy a coffee for the contract owner
     * @param _name Name of the coffee buyer
     * @param _message Message from the coffee buyer
     * @param _quantity Number of coffees to buy
     */
    function buyCoffee(string memory _name, string memory _message, uint256 _quantity) public {
        require(_quantity > 0, "Quantity must be greater than zero");

        // Calculate total price based on quantity
        uint256 totalPrice = coffeePrice * _quantity;

        // Transfer USDT from the sender to this contract
        require(stablecoin.transferFrom(msg.sender, address(this), totalPrice), "Transfer failed");

        // Add the coffee(s) to the list
        coffees.push(Coffee(
            msg.sender,
            block.timestamp,
            _name,
            _message,
            _quantity
        ));

        // Emit a log event when a new coffee is bought
        emit NewCoffee(
            msg.sender,
            block.timestamp,
            _name,
            _message,
            _quantity
        );
    }

    /**
     * @dev Send the entire balance of USDT stored in this contract to the owner
     */
    function withdrawTips() public onlyOwner {
        uint256 balance = stablecoin.balanceOf(address(this));
        require(stablecoin.transfer(owner, balance), "Transfer failed");
    }

    /**
     * @dev Retrieve all the coffees purchased
     */
    function getCoffees() public view returns (Coffee[] memory) {
        return coffees;
    }
}
