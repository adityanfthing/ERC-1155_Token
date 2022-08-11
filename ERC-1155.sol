// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.2/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.7.2/access/Ownable.sol";

contract MyToken is ERC1155, Ownable {
    uint256[] suppliesOfTokens = [25, 50, 100, 150];
    uint256[] mintedTokens = [0, 0, 0, 0]; // it will keep the track of minted tokens
    uint256[] rates = [0.05 ether, 0.02 ether, 0.06 ether];

    constructor() ERC1155("https://nfthing.com/") {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(uint256 id, uint256 amount) public payable {
        require(id <= suppliesOfTokens.length);
        require(id > 0, "From this id Token doesn't exist");
        uint256 index = id - 1;
        require(
            mintedTokens[index] + amount <= suppliesOfTokens[index],
            "Not Enough supply"
        );
        require(msg.value >= amount * rates[index], "Not enough amount sent");

        _mint(msg.sender, id, amount, "");
        mintedTokens[index] += amount;
    }

    function checkContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function mintBatch(uint256[] memory ids, uint256[] memory amounts)
        public
        payable
        onlyOwner
    {
        _mintBatch(msg.sender, ids, amounts, "");
    }
}
