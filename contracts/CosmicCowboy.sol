// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
    enum Location {
        Home,
        Bar,
        SupplyDepot
    }
    mapping(uint256 => Location) public tokenLocation;

    // Events
    event VisitArea(uint256 indexed tokenId, string location);
    event GetCurrentLocation(uint256 indexed tokenId, string location);

    constructor(
        address initialOwner
    ) ERC721("Cosmic Cowboys", "CCNPC") Ownable(initialOwner) {}

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // Function to visit a location
    function visitArea(uint256 tokenId, Location _location) external {
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        tokenLocation[tokenId] = _location;
        emit VisitArea(tokenId, locationToString(_location));
    }

    // Function to get the current location of a token
    function getCurrentLocation(
        uint256 tokenId
    ) external view returns (string memory) {
        Location _location = tokenLocation[tokenId];
        require(_location != Location(0), "Token does not exist");
        return locationToString(_location);
    }

    // Utility function to convert enum to string
    function locationToString(
        Location _location
    ) internal pure returns (string memory) {
        if (_location == Location.Home) return "Home";
        if (_location == Location.Bar) return "Bar";
        return "Supply Depot";
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
}
