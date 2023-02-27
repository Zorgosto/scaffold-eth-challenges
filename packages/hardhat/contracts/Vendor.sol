pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // create a payable buyTokens() function:
    uint256 public constant tokensPerEth = 100;

    function buyTokens() public payable {
        uint256 amount = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amount);
        emit BuyTokens(msg.sender, msg.value, amount);
    }

    // create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        (bool sent,) = msg.sender.call{value : address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    // create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) public {
        uint256 ethValue = _amount / 100;
        yourToken.transferFrom(msg.sender, address(this), _amount);
        (bool sent,) = msg.sender.call{value : ethValue}("");
        require(sent, "Failed to send Ether");
        emit SellTokens(msg.sender, ethValue, _amount);
    }
}
