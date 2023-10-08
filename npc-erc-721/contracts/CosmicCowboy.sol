// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
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

    IERC20 public missionCurrency;
    IERC1155 public universeAssets;
    uint256 public fuelTokenId;
    uint256 public weaponsTokenId;

    // Events
    event VisitArea(uint256 indexed tokenId, string location);
    event LaunchMission(uint256 indexed tokenId, string result);

    constructor(
        address initialOwner,
        address _missionCurrency,
        address _universeAssets,
        uint256 _fuelTokenId,
        uint256 _weaponsTokenId
    ) ERC721("Cosmic Cowboys", "CCNPC") Ownable(initialOwner) {
        missionCurrency = IERC20(_missionCurrency);
        universeAssets = IERC1155(_universeAssets);
        fuelTokenId = _fuelTokenId;
        weaponsTokenId = _weaponsTokenId;
    }

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

    // Function to launch a mission
    function launchMission(uint256 tokenId, string memory moon) external {
        require(
            tokenLocation[tokenId] == Location.SupplyDepot,
            "Need to be in Supply Depot"
        );
        require(
            missionCurrency.transferFrom(
                msg.sender,
                address(this),
                100 * 10 ** 18
            ),
            "Payment required"
        );

        if (
            universeAssets.balanceOf(msg.sender, fuelTokenId) > 0 &&
            universeAssets.balanceOf(msg.sender, weaponsTokenId) > 0
        ) {
            // Placeholder for successful mission logic
            string memory successMessage = string(
                abi.encodePacked("Mission Successful on moon: ", moon)
            );
            emit LaunchMission(tokenId, successMessage);
        } else {
            // Placeholder for failed mission logic
            emit LaunchMission(
                tokenId,
                "Mission Failed: Missing required items"
            );
        }
    }

    // Utility function to convert enum to string
    function locationToString(
        Location _location
    ) internal pure returns (string memory) {
        if (_location == Location.Home) return "Home";
        if (_location == Location.Bar) return "Bar";
        return "Supply Depot";
    }

    // Withdraw funds (in case of ERC20 payments accumulation)
    function withdrawFunds(address to, uint256 amount) external onlyOwner {
        require(missionCurrency.transfer(to, amount), "Transfer failed");
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
