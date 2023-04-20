// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {TestBase} from "../bases/TestBase.sol";
import { Quest } from "../../src/Quest.sol";

contract BurningQuests is TestBase {
    function setUp() public override {
        super.setUp();
    }

    // can't burn quests
    function testBurnQuest__CannotBurn() public {
        Quest quest = _createQuest();

        vm.prank(admin1);
        uint256 id = quest.mint(
            user
        );

        vm.expectRevert();
        quest.burn(
            id
        );

        assertEq(
            quest.balanceOf(user),
            1
        );
    }

    // only admin can call burn
    function testBurnQuest__AdminCanBurn() public {
        Quest quest = _createQuest();

        vm.prank(admin1);
        uint256 id = quest.mint(
            user
        );

        vm.prank(admin1);
        quest.burn(
            id
        );

        assertEq(
            quest.balanceOf(user),
            0
        );
    }

    // holder can burn
    function testBurnQuest__HolderCanBurn() public {
        Quest quest = _createQuest();

        vm.prank(admin1);
        uint256 id = quest.mint(
            user
        );

        vm.prank(user);
        quest.burn(
            id
        );

        assertEq(
            quest.balanceOf(user),
            0
        );
    }

}
