// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {TestBase} from "../bases/TestBase.sol";
import { Quest } from "../../src/Quest.sol";

contract FactoryAdminTest is TestBase {

    function setUp() public override {
        super.setUp();
    }

    // sets owner on deployment
    function testAdmin__OwnerSetOnDeployment() public {
        assertEq(
            factory.owner(),
            owner
        );
    }

    // addresses provided in constructor are given admin priviliges
    function testAdmin__AdminAddressesSetOnDeployment() public {
        for (uint256 i = 0; i < admins.length; i++) {
            assertEq(
                factory.isAdmin(admins[i]),
                true
            );
        }
    }

    // automatically give the owner the admin role
    function testAdmin__OwnerHasAdminRole() public {
        assertEq(
            factory.isAdmin(owner),
            true
        );
    }

    // owner can add admins
    function testAdmin__OwnerCanAddAdmin() public {
        address newAdmin = address(0x100);

        // reverts if not called by owner
        vm.expectRevert();
        factory.setAdmin(newAdmin);

        vm.prank(owner);
        factory.setAdmin(newAdmin);
        assertEq(
            factory.isAdmin(newAdmin),
            true
        );
    }

    // owner can remove admins
    function testAdmin__OwnerCanRemoveAdmin() public {
        address admin = admins[0];

        // reverts if not called by owner
        vm.expectRevert();
        factory.revokeAdmin(admin);

        vm.prank(owner);
        factory.revokeAdmin(admin);
        assertEq(
            factory.isAdmin(admin),
            false
        );
    }

    function testAdmin__CallToGrantRoleFails() public {
        address admin = admins[0];

        vm.expectRevert();
        factory.grantRole(keccak256("ADMIN"), admin);

        vm.startPrank(owner);
        vm.expectRevert();
        factory.grantRole(keccak256("ADMIN"), admin);

        vm.stopPrank();
    }

    function testAdmin__CallToRevokeRoleFails() public {
        address admin = admins[0];

        vm.expectRevert();
        factory.revokeRole(keccak256("ADMIN"), admin);

        vm.startPrank(owner);
        vm.expectRevert();
        factory.revokeRole(keccak256("ADMIN"), admin);

        vm.stopPrank();
    }

    // only admin can call createQuest
    function testAdmin__OnlyAdminCanCreateQuest() public {
        // reverts if not called by admin
        vm.expectRevert();
        factory.createQuest(
            questName,
            questSymbol,
            questContributors,
            questTokenURI,
            questContractURI
        );

        vm.prank(admins[0]);
        factory.createQuest(
            questName,
            questSymbol,
            questContributors,
            questTokenURI,
            questContractURI
        );
    }
}
