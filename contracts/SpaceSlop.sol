// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SpaceSlop is ERC1155, Ownable {
    constructor(
        address initialOwner
    )
        ERC1155("ipfs://QmRPT3zHx71Dd9KtRdYJkY9hsbu9RcCeRdoNWypJMpiybf")
        Ownable(initialOwner)
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, 0, amount, new bytes(0));
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }
}
