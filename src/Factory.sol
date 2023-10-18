// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { Ownable2Step } from "oz/access/Ownable2Step.sol";
import { AccessControl } from "oz/access/AccessControl.sol";
import { Clones } from "oz/proxy/Clones.sol";
import { Quest } from "./Quest.sol";

contract QuestFactory is Ownable2Step, AccessControl {
    ///////////////////////////////
    ////////// Variables //////////
    ///////////////////////////////

    /// @notice Admin role constant, used with AccessControl
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");

    /// @notice Current implementation of Quest NFT contract (to be cloned)
    address public questImplementation;

    ////////////////////////////
    ////////// Events //////////
    ////////////////////////////

    /// @notice Emited when a quest is created
    event QuestCreated(address indexed questAddress, string indexed name);

    /// @notice Emited when an admin is added
    event AdminAdded(address indexed newAdmin);

    /// @notice Emited when an admin is removed
    event AdminRemoved(address indexed oldAdmin);

    /// @notice Emited when the Quest NFT implementation contract is updated
    event QuestImplementationUpdated(address indexed newImplementation);

    ////////////////////////////
    ////////// Errors //////////
    ////////////////////////////

    ///////////////////////////////
    ////////// Modifiers //////////
    ///////////////////////////////

    /// @notice Check that caller is either the contract owner or an admin
    /// @dev msg.sender needs to be the contract's owner or an admin
    modifier onlyOwnerOrAdmin() {
        if(
            msg.sender == owner() ||
            hasRole(ADMIN_ROLE, msg.sender)
        ) {
            _;
        } else {
            revert("QuestFactory: caller is not owner or admin");
        }
    }

    /// @notice Check that the caller is an admin
    /// @dev msg.sender needs to be an admin
    modifier onlyAdmin() {
        if(hasRole(ADMIN_ROLE, msg.sender)) {
            _;
        } else {
            revert("QuestFactory: caller is not admin");
        }
    }

    /////////////////////////////////
    ////////// Constructor //////////
    /////////////////////////////////

    /// @notice Constructor for QuestFactory
    /// @param _questImplementation Address of the Quest NFT implementation contract
    /// @param _admins List of addresses to set as contract admins
    constructor(address _questImplementation, address[] memory _admins) {
        questImplementation = _questImplementation;

        _grantRole(ADMIN_ROLE, msg.sender);

        for (uint256 i = 0; i < _admins.length; i++) {
            _grantRole(ADMIN_ROLE, _admins[i]);
        }

        emit QuestImplementationUpdated(_questImplementation);
    }

    /////////////////////////////
    ////////// Methods //////////
    /////////////////////////////

    /// @notice Method for creating a new Quest NFT
    /// @dev This will create an instance of the Quest NFT contract
    /// @param _name The name of the new Quest NFT
    /// @param _symbol The symbol for the new Quest NFT
    /// @param _contributors List of addresses to pre-set as contributors
    /// @param _tokenURI The URI for the token metadata
    /// @param _contractURI Contract metadata for NFT Marketplaces
    function createQuest(
        string memory _name,
        string memory _symbol,
        address[] memory _contributors,
        string memory _tokenURI,
        string memory _contractURI,
        string memory _nonce
    ) external onlyOwnerOrAdmin returns (Quest) {
        Quest _quest = Quest( Clones.clone(questImplementation) );

        _quest.initialize(
            _name,
            _symbol,
            _contributors,
            _tokenURI,
            _contractURI
        );

        emit QuestCreated(address(_quest), _name);

        return _quest;
    }

    /// @notice Checks if a given address posesses the admin role
    /// @dev We use this to see if an account is an admin (i.e. in a Quest NFT, before minting, burning, transfering, etc)
    /// @param _account Wallet address to check for admin roles
    function isAdmin(address _account) public view returns (bool) {
        return hasRole(ADMIN_ROLE, _account);
    }

    /// @notice Grant admin role to a given account
    /// @dev Adds an address to the list of admins
    /// @param _account Account to be granted the admin role
    function setAdmin(address _account) public onlyOwner {
        _grantRole(ADMIN_ROLE, _account);
    }

    /// @notice Revoke admin role from a given account
    /// @dev Remove an address from the list of admins
    /// @param _account Account to have the admin role revoked
    function revokeAdmin(address _account) public onlyOwner {
        _revokeRole(ADMIN_ROLE, _account);
    }

    /// @notice Update the Quest NFT implementation contract
    /// @dev This will update the Quest NFT implementation contract
    /// @param _newImplementation The address of the new Quest NFT implementation contract
    function setQuestImplementation(address _newImplementation) external onlyOwner {
        questImplementation = _newImplementation;

        emit QuestImplementationUpdated(_newImplementation);
    }
}
