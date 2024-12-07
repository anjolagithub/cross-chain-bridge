// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@layerzerolabs/solidity-examples/contracts/interfaces/ILayerZeroEndpoint.sol";

contract BridgeSource {
    ILayerZeroEndpoint public endpoint;
    address public destinationBridge;

    constructor(address _endpoint, address _destinationBridge) {
        endpoint = ILayerZeroEndpoint(_endpoint);
        destinationBridge = _destinationBridge;
    }

    function lockAndSend(
        address token,
        uint256 amount,
        uint16 destinationChainId
    ) external payable {
        require(amount > 0, "Amount must be > 0");
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        bytes memory payload = abi.encode(msg.sender, token, amount);

        endpoint.send{value: msg.value}(
            destinationChainId,          // Destination chain ID
            abi.encodePacked(destinationBridge), // Destination contract
            payload,                     // Encoded data
            payable(msg.sender),         // Refund address
            address(0),                  // ZRO payment address
            bytes("")                    // Adapter params
        );
    }
}
