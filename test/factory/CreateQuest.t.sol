// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {TestBase} from "../bases/TestBase.sol";
import { Quest } from "../../src/Quest.sol";

contract CreateQuestTest is TestBase {
    function setUp() public override {
        super.setUp();
    }
    // creates a new quest
    function testCreateQuest__CreatesAQuest() public {
        Quest quest = _createQuest();

        assert(
            address(quest) != address(0)
        );
    }
    // sets the name and symbol correctly
    function testCreateQuest__SetsNameAndSymbol() public {
        Quest quest = _createQuest();

        assertEq(
            quest.name(),
            "Test Quest"
        );
        assertEq(
            quest.symbol(),
            "TQ"
        );
    }
    // sets the tokenURI correctly
    function testCreateQuest__SetsTokenURICorrectly() public {
        Quest quest = _createQuest();

        assertEq(
            quest.tokenURI(0),
            string(abi.encodePacked(questTokenURI, "0", ".json"))
        );
        assertEq(
            quest.tokenURI(1),
            string(abi.encodePacked(questTokenURI, "1", ".json"))
        );
    }
    // Sets the contract URI correctly
    function testCreateQuest__SetsContractURICorrectly() public {
        Quest quest = _createQuest();

        assertEq(
            quest.contractURI(),
            questContractURI
        );
    }

    // mints to contributors correctly
    function testCreateQuest__MintsToContributorsCorrectly() public {
        Quest quest = _createQuest();

        for (uint256 i = 0; i < questContributors.length; i++) {
            assertEq(
                quest.balanceOf(questContributors[i]),
                1
            );
            assertEq(
                quest.ownerOf(i),
                questContributors[i]
            );
        }
    }

    // sets the next token ID correctly
}
