// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CosmicCowboys is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Burnable,
    Ownable
{
    uint256 private _nextTokenId;
    uint256 public latestTokenId;
    enum Location {
        Home,
        Bar,
        SupplyDepot
    }
    mapping(uint256 => Location) public tokenLocation;
    mapping(uint256 => uint8) public tokenHealth; // Mapping to store health of each token

    // Events
    event VisitArea(uint256 indexed tokenId, string location);
    event GetCurrentLocation(uint256 indexed tokenId, string location);
    event SetHealth(uint256 indexed tokenId, uint8 health); // Event emitted when health is set

    constructor(
        address initialOwner
    ) ERC721("Cosmic Cowboys", "CCNPC") Ownable(initialOwner) {}

    //function to set health
    function setHealth(uint256 tokenId, uint8 health) public onlyOwner {
        require(health >= 0 && health <= 10, "Health out of range"); // Check health is within valid range
        tokenHealth[tokenId] = health;
        emit SetHealth(tokenId, health); // Emit event
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        latestTokenId = tokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        setHealth(tokenId, 6);
        tokenLocation[tokenId] = Location.Bar;
    }

    // Function to get health of a token
    function getHealth(uint256 tokenId) external view returns (uint8) {
        return tokenHealth[tokenId];
    }

    // Function to visit a location

    function goToHome(uint256 tokenId) external {
        tokenLocation[tokenId] = Location.Home;
        emit VisitArea(tokenId, locationToString(Location.Home));
    }

    function goToBar(uint256 tokenId) external {
        tokenLocation[tokenId] = Location.Bar;
        emit VisitArea(tokenId, locationToString(Location.Bar));
    }

    function goToSupplyDepot(uint256 tokenId) external {
        tokenLocation[tokenId] = Location.SupplyDepot;
        emit VisitArea(tokenId, locationToString(Location.SupplyDepot));
    }

    // Function to get the current location of a token
    function getCurrentLocation(
        uint256 tokenId
    ) external view returns (string memory) {
        Location _location = tokenLocation[tokenId];
        return locationToString(_location);
    }

    // Utility function to convert enum to string
    function locationToString(
        Location _location
    ) internal pure returns (string memory) {
        if (_location == Location.SupplyDepot) return "Supply Depot";
        if (_location == Location.Bar) return "Bar";
        return "Home";
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function getOwner() external view returns (address) {
        return owner();
    }
}
