// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

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
            quest.tokenURI(1),
            "https://test.com/1.json"
        );
        assertEq(
            quest.tokenURI(2),
            "https://test.com/2.json"
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
                // 0 offset, token IDs start at 1 but array starts at 0
                quest.ownerOf(i + 1),
                questContributors[i]
            );
        }
    }

    address[] contributorsWithDuplicate = [questContributors[0],
        questContributors[0], questContributors[1]];

    // Prevents minting to the same contributor more than once
    function testCreateQuest__PreventsMintingToSameContributorMoreThanOnce() public {
        vm.startPrank(owner);

        // this should revert
        vm.expectRevert();
        factory.createQuest(
            questName,
            questSymbol,
            contributorsWithDuplicate, // includes a duplicate
            questTokenURI,
            questContractURI
        );

        vm.stopPrank();
    }
}
