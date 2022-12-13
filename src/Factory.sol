// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Ownable2Step} from "oz/access/Ownable2Step.sol";
import {AccessControl} from "oz/access/AccessControl.sol";
import {Quest} from "./Quest.sol";

contract QuestFactory is Ownable2Step, AccessControl {
  // Variables
  mapping(address => bool) internal admins;

  // Events
  event QuestCreated(address indexed questAddress, string indexed name);
  event AdminAdded(address indexed newAdmin);
  event AdminRemoved(address indexed oldAdmin);

  // Modifiers
  // - onlyOwnerOrAdmin
  modifier onlyOwnerOrAdmin() {
    // _checkOwner();
    // __checkRole();
    _;
  }

  // Constructor
  constructor(address[] memory _admins) {
    // give _admins the ADMIN role

    for (uint256 i = 0; i < _admins.length; i++) {
      setAdmin(_admins[i], true);
    }
  }

  // Methods
  function createQuest(
    string memory _name,
    string memory _symbol,
    address[] memory _contributors
  ) external {}

  function isAdmin(address _admin) public returns (bool) {
    return admins[_admin];
  }

  function setAdmin(address _admin, bool _status) public onlyOwner {
    admins[_admin] = _status;
  }
}

