# pws-solidity

🔗 GitHub Repository: [pwssolidity](https://github.com/mqtthew69/pwssolidity)

## Introduction

Welcome to the **pws-solidity** repository! This exciting project brings together the worlds of supply chain management and blockchain technology. The repository contains a supply chain contract interface built using Solidity. By interacting with the smart contract deployed on the Ethereum blockchain, users can perform a range of supply chain operations, including creating orders, managing shipments, tracking deliveries, handling cancellations, and claiming refunds.

## Getting Started

To dive into the supply chain adventure, follow these simple steps:

1. Clone the repository:

```bash
git clone https://github.com/mqtthew69/pwssolidity.git
```

2. Open the `index.html` file in your favorite web browser.

3. Connect your MetaMask wallet to the Ethereum network.

## Functionality

📦 **Create Order**

Create an order by providing the necessary details and clicking the "Create Order" button. The smart contract will handle the creation process and securely manage the deposit of Ether.

🚚 **Create Shipment**

As the journey unfolds, manufacturers can create shipments. Enter the product number, track and trace code, and carrier address, and click the "Create Shipment" button to unleash the power of logistics.

🏭 **Pick Shipment**

Carriers play a vital role in the supply chain. Use the "Pick Shipment" button to accept the responsibility of transporting goods. Enter the track and trace code to pick up the shipment and become an integral part of the delivery process.

🎁 **Deliver Shipment**

With the shipment in your hands, it's time to fulfill your mission. Enter the track and trace code and click the "Deliver Shipment" button to ensure a timely and successful delivery. Remember, timing is everything!

❌ **Cancel Shipment**

In unforeseen circumstances, shipments may need to be canceled. Click the "Cancel Shipment" button and enter the track and trace code to initiate the cancellation process. Note that shipments cannot be canceled once they have been delivered.

💰 **Claim Refund**

Sometimes, refunds become necessary. Retailers have the power to claim a refund if a shipment has been picked but not delivered within the specified time frame. Enter the product number and hit the "Claim Refund" button to initiate the refund process.

## Smart Contract Details

The heart of this supply chain adventure lies in the smart contract defined in the `order.sol` file. This robust contract implements a comprehensive supply chain management system, offering features such as order creation, shipment management, delivery tracking, cancellation handling, and refund management.
