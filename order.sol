// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

contract SupplyChain {
    // Enum to represent the possible statuses of a shipment
    enum Status {
        Created,
        Picked,
        Delivered,
        Cancelled
    }

    // Struct (Group) to represent an order
    struct Order {
        string productNr;
        address payable manufacturer;
        address payable retailer;
        uint256 price;
    }

    // Struct to represent a shipment
    struct Shipment {
        string trackAndTraceCode;
        string productNr;
        address carrier;
        uint256 pickedTimestamp;
        Status status;
    }

    // Maps product numbers to their respective orders, shipments, and deposits
    mapping(string => Order) public orders;
    mapping(string => Shipment) public shipments;
    mapping(string => uint256) public deposits;

    // Constant representing the maximum duration for a delivery
    uint256 constant DELIVERY_MAX_DURATION = 7 days;

    // Function to create a new order
    function createOrder(
        string memory productNr,
        address payable manufacturer,
        uint256 price
    ) public payable {
        // Require that the deposit covers the order price
        require(msg.value >= price, "Deposit must cover the order price.");

        orders[productNr] = Order({
            productNr: productNr,
            manufacturer: manufacturer,
            retailer: payable(msg.sender),
            price: price
        });

        deposits[productNr] = msg.value;
    }

    // Function to create a new shipment
    function createShipment(string memory productNr, string memory trackAndTraceCode, address carrier) public {
        // Require that only the manufacturer can create a shipment
        require(msg.sender == orders[productNr].manufacturer, "Only the manufacturer can create the shipment.");

        shipments[trackAndTraceCode] = Shipment({
            trackAndTraceCode: trackAndTraceCode,
            productNr: productNr,
            carrier: carrier,
            pickedTimestamp: 0,
            status: Status.Created
        });
    }

    // Function for the carrier to pick up a shipment
    function pickShipment(string memory trackAndTraceCode) public {
        // Require that only the assigned carrier can pick up the shipment and the shipment is in the correct status
        Shipment storage shipment = shipments[trackAndTraceCode];
        require(shipment.carrier == msg.sender, "Only the assigned carrier can pick the shipment.");
        require(shipment.status == Status.Created, "Invalid shipment status.");

        // Update the shipment status and set the picked timestamp
        shipment.status = Status.Picked;
        shipment.pickedTimestamp = block.timestamp;
    }

    // Function for the carrier to deliver a shipment
    function deliverShipment(string memory trackAndTraceCode) public {
        // Require that only the assigned carrier can deliver the shipment, the shipment is in the correct status,
        // and the delivery period has not exceeded the maximum duration
        Shipment storage shipment = shipments[trackAndTraceCode];
        require(shipment.carrier == msg.sender, "Only the assigned carrier can deliver the shipment.");
        require(shipment.status == Status.Picked, "Invalid shipment status.");
        require(block.timestamp <= shipment.pickedTimestamp + DELIVERY_MAX_DURATION, "Delivery period has exceeded.");

        // Update the shipment status and transfer the deposit to the manufacturer
        shipment.status = Status.Delivered;
        orders[shipment.productNr].manufacturer.transfer(deposits[shipment.productNr]);
    }

    // Function to cancel a shipment
    function cancelShipment(string memory trackAndTraceCode) public {
        // Require that only the carrier or manufacturer can cancel the shipment, and the shipment is not delivered
        Shipment storage shipment = shipments[trackAndTraceCode];
        require(msg.sender == shipment.carrier || msg.sender == orders[shipment.productNr].manufacturer, "Only the carrier or manufacturer can cancel the shipment.");
        require(shipment.status != Status.Delivered, "Cannot cancel a delivered shipment.");

        // Update the shipment status and transfer the deposit to the retailer
        shipment.status = Status.Cancelled;
        orders[shipment.productNr].retailer.transfer(deposits[shipment.productNr]);
    }

    // Function for the retailer to claim a refund
    function claimRefund(string memory productNr) public {
        // Require that only the retailer can claim a refund, the shipment is picked,
        // and the time for claiming a refund has passed
        Order storage order = orders[productNr];
        Shipment storage shipment = shipments[order.productNr];
        require(msg.sender == order.retailer, "Only the retailer can claim a refund.");
        require(shipment.status == Status.Picked && block.timestamp > shipment.pickedTimestamp + DELIVERY_MAX_DURATION, "Cannot claim refund yet.");

        // Transfer the deposit back to the retailer
        order.retailer.transfer(deposits[order.productNr]);
    }

    // Function to get the details of an order
    function getOrder(string memory productNr) public view returns (string memory, address, address, uint256) {
        Order storage order = orders[productNr];
        return (
            order.productNr,
            order.manufacturer,
            order.retailer,
            order.price
        );
    }

    // Function to get the details of a shipment
    function getShipment(string memory trackAndTraceCode) public view returns (string memory, string memory, address, uint256, Status) {
        Shipment storage shipment = shipments[trackAndTraceCode];
        return (
            shipment.trackAndTraceCode,
            shipment.productNr,
            shipment.carrier,
            shipment.pickedTimestamp,
            shipment.status
        );
    }
}
