// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { QuestFactory } from "../../src/Factory.sol";
import { Quest } from "../../src/Quest.sol";

contract TestBase is Test {
    address owner = makeAddr("owner");
    address[] public admins = makeAdminAddresses(5);
    QuestFactory factory;
    Quest quest;

    function makeAdminAddresses(uint8 _num) public pure returns (address[] memory){
        address[] memory _admins = new address[](_num);
        for (uint256 i = 0; i < _num; i++) {
            _admins[i] = vm.addr(i + 1);
        }

        return _admins;
    }

    function setUp() public virtual {
        vm.prank(owner);
        factory = new QuestFactory(admins);
    }
}
