// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { Test } from "forge-std/Test.sol";
import { QuestFactory } from "../../src/Factory.sol";
import { Quest } from "../../src/Quest.sol";

contract TestBase is Test {
    address owner = makeAddr("owner");
    address user = makeAddr("user");
    address userBackupWallet = makeAddr("userBackupWallet");
    address admin1 = makeAddr("admin1");
    address admin2 = makeAddr("admin2");
    address[] admins = [admin1, admin2];
    QuestFactory factory;
    address quest;

    string questName = "Test Quest";
    string questSymbol = "TQ";
    string questTokenURI = "https://test.com";
    string questContractURI = "https://test.com";
    address[] questContributors = [makeAddr("contributor1"), makeAddr("contributor2")];

    function setUp() public virtual {
        vm.startPrank(owner);
        quest = address( new Quest("generic quest contract", "GQC") );
        factory = new QuestFactory(quest, admins);
        vm.stopPrank();
    }

    function _createQuest() public returns (Quest) {
        vm.prank(owner);
        Quest testQuest = factory.createQuest(
            questName,
            questSymbol,
            questContributors,
            questTokenURI,
            questContractURI
        );

        return testQuest;
    }
}
