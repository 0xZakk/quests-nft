// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {TestBase} from "../bases/TestBase.sol";
import { Quest } from "../../src/Quest.sol";

contract QuestAdmin is TestBase {
    function setUp() public override {
        super.setUp();
    }

    // only admin can update the tokenURI
    function questAdmin__testUpdateTokenURI() public {
        Quest quest = _createQuest();
        quest.setTokenURI(1, "https://api.quest.com/token/");
        assertEq(quest.tokenURI(1), "https://api.quest.com/token/");
    }

    // only admin can update the contractURI
    function questAdmin__testUpdateContractURI() public {
        Quest quest = _createQuest();
        quest.setContractURI("https://api.quest.com/contract/");
        assertEq(quest.contractURI(), "https://api.quest.com/contract/");
    }
}
