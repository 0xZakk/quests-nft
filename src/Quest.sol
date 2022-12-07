// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC721} from "solmate/tokens/ERC721.sol";

abstract contract Quest is ERC721 {

  constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol)
  {

  }
}
