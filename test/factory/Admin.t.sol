// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {TestBase} from "../bases/TestBase.sol";

contract FactoryAdminTest is TestBase {

    function setUp() public override {
        super.setUp();
    }

    // sets owner on deployment
    function testOwner__SetOnDeployment() public {
        assertEq(
            factory.owner(),
            owner
        );
    }
    // admin role transfer should also make address DEFAULT_ADMIN_ROLE of bot role
    // only admin can call createQuest
    // only admin can call mint
    // only admin can call burn
    // only admin can call transferFrom
    // only admin can call safeTransferFrom
}
