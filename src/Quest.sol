// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ERC721 } from "solmate/tokens/ERC721.sol";
import { QuestFactory } from "./Factory.sol";

abstract contract Quest is ERC721 {
    // Variables
    QuestFactory factory; // hard code this after deployment or take this in constructor?
    // - some way to track the next token ID

    // Events
    // Modifiers
    modifier onlyAdmin() {
        // check on Factory if msg.sender has ADMIN role
        _;
    }

    // Constructor
    constructor(
        string memory _name,
        string memory _symbol,
        address[] memory _contributors
    ) ERC721(_name, _symbol) {
        // set factory address
        // accept and set tokenURI
    }

    // Methods
    function mint(address _to) external onlyAdmin {}

    function burn(address _from) external onlyAdmin {
        // - revert if they already hold
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _id
    ) public override onlyAdmin {}

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id
    ) public override onlyAdmin {}

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        bytes calldata data
    ) public override onlyAdmin {}

    function tokenURI(uint256 _id)
        public
        view
        override
        returns (string memory)
    {}
}
