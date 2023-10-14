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

    function fundNPC(address to, uint256 amount) public {
        goldenCorn.mint(to, amount);
    }

    function feedNPC(address to, uint256 amount) public {
        spaceSlop.mint(to, amount);
    }

    function supplyNPC(address to, uint256 amount) public {
        jupiterJunk.mint(to, amount);
    }

    function getNPCStats(
        uint256 tokenId
    ) external view returns (uint8, string memory) {
        uint8 health = cosmicCowboys.getHealth(tokenId);
        string memory location = cosmicCowboys.getCurrentLocation(tokenId);
        return (health, location);
    }

    function launchSupplyMission(uint256 tokenId) public {
        uint8 newHealth = cosmicCowboys.getHealth(tokenId) - 2;
        cosmicCowboys.setHealth(tokenId, newHealth);
    }

    function goToBar(uint256 tokenId) public {
        cosmicCowboys.goToBar(tokenId);
    }

    function goToSupplyDepot(uint256 tokenId) public {
        cosmicCowboys.goToSupplyDepot(tokenId);
    }

    function goToHome(uint256 tokenId) public {
        //require(cosmicCowboys.ownerOf(tokenId) == tba, "Not owner"); // Check OwnershipTransferred
        cosmicCowboys.goToHome(tokenId);
        uint8 newHealth = cosmicCowboys.getHealth(tokenId) + 2;
        cosmicCowboys.setHealth(tokenId, newHealth);
    }

    function getOwner() external view returns (address) {
        return owner();
    }
}
