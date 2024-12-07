// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeDestination {
    address public sourceBridge;

    mapping(address => mapping(address => uint256)) public wrappedBalances;

    constructor(address _sourceBridge) {
        sourceBridge = _sourceBridge;
    }

    function onReceive(
        address sender,
        address token,
        uint256 amount
    ) external {
        require(msg.sender == sourceBridge, "Unauthorized sender");
        wrappedBalances[token][sender] += amount;
    }


    function lzReceive(
    uint16 srcChainId,
    bytes calldata srcAddress,
    uint64 nonce,
    bytes calldata payload
) external {
    require(msg.sender == address(endpoint), "Unauthorized sender");

    (address sender, address token, uint256 amount) = abi.decode(payload, (address, address, uint256));

    // Mint wrapped tokens or handle balance update
    wrappedBalances[token][sender] += amount;
}

}
