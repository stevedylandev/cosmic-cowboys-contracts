// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./CosmicCowboy.sol";
import "./ERC6551Account.sol";
import "./ERC6551Registry.sol";
import "./GoldenCorn.sol";
import "./SpaceSlop.sol";
import "./JupiterJunk.sol";

contract Operator is Ownable {
    CosmicCowboys public cosmicCowboys;
    GoldenCorn public goldenCorn;
    SpaceSlop public spaceSlop;
    JupiterJunk public jupiterJunk;

    uint256 public newTokenId;

    constructor(
        address initialOwner,
        address _cosmicCowboys,
        address _goldenCorn,
        address _spaceSlop,
        address _jupiterJunk
    ) Ownable(initialOwner) {
        cosmicCowboys = CosmicCowboys(_cosmicCowboys);
        goldenCorn = GoldenCorn(_goldenCorn);
        spaceSlop = SpaceSlop(_spaceSlop);
        jupiterJunk = JupiterJunk(_jupiterJunk);
    }

    function createNPC(address to, string memory uri) public {
        cosmicCowboys.safeMint(to, uri);
    }

    function getLatestTokenId() external view returns (uint256) {
        return cosmicCowboys.latestTokenId();
    }

    function equipNPC(
        address to,
        uint256 currencyAmount,
        uint256 foodAmount,
        uint256 suppliesAmount
    ) public {
        goldenCorn.mint(to, currencyAmount);
        spaceSlop.mint(to, foodAmount);
        jupiterJunk.mint(to, suppliesAmount);
    }

    function getOwner() external view returns (address) {
        return owner();
    }
}
