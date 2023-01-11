// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { QuestFactory } from "../../src/Factory.sol";
import { Quest } from "../../src/Quest.sol";

contract TestBase is Test {
    address owner = makeAddr("owner");
    address user = makeAddr("user");
    address userBackupWallet = makeAddr("userBackupWallet");
    address[] public admins = makeAdminAddresses(5);
    QuestFactory factory;

    string questName = "Test Quest";
    string questSymbol = "TQ";
    address[] questContributors = makeAdminAddresses(5);
    string questTokenURI = "https://test.com";
    string questContractURI = "https://test.com";

    function makeAdminAddresses(uint8 _num) public pure returns (address[] memory){
        address[] memory _admins = new address[](_num);
        for (uint256 i = 0; i < _num; i++) {
            _admins[i] = vm.addr(i + 1);
        }

        return _admins;
    }

    function setUp() public virtual {
        vm.startPrank(owner);
        factory = new QuestFactory(admins);
        vm.stopPrank();
    }

    function _createQuest() public returns (Quest quest) {
        vm.prank(owner);
        Quest quest = factory.createQuest(
            questName,
            questSymbol,
            questContributors,
            questTokenURI,
            questContractURI
        );
    }
}
