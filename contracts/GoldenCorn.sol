// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract GoldenCorn is ERC20, Ownable, ERC20Permit {
    mapping(address => bool) private _whitelist;

    constructor(
        address initialOwner
    )
        ERC20("GoldenCorn", "GC")
        Ownable(initialOwner)
        ERC20Permit("GoldenCorn")
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        uint256 mintAmount = amount * (10 ** decimals());
        _mint(to, mintAmount);
    }

    // Override the transfer function
    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(
            _whitelist[msg.sender],
            "Only whitelisted addresses can initiate transfers"
        );
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    // Override the transferFrom function
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(
            _whitelist[sender],
            "Only whitelisted addresses can initiate transfers"
        );
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            allowance(sender, _msgSender()) - amount
        );
        return true;
    }

    // Add a function to add or remove addresses from the whitelist
    function setWhitelisted(address account, bool value) external {
        require(
            msg.sender == owner(),
            "Only the owner can modify the whitelist"
        );
        _whitelist[account] = value;
    }
}
