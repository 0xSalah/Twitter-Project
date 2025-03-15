// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Followers.sol";

contract testFolowers is Test {
    register Register;
    Folowers folowers;
    address user1 = address(1);
    address user2 = address(2);

    function setUp() public {
        Register = new register();
        folowers = new Folowers(address(Register));
    }

    function test_RevertWhen_UsernameIsEmpty() public {
        vm.startPrank(user2);
        Register.registerUsername("Salah");

        vm.expectRevert("empty");
        folowers.folow("Salim");

        vm.stopPrank();
    }

    function test_RevertWhen_IsFolowedAlready() public {
        vm.startPrank(user1);
        Register.registerUsername("Salah");
        vm.stopPrank();

        vm.startPrank(user2);

        Register.registerUsername("Salim");
        folowers.folow("Salah");

        vm.expectRevert("You are already folowed");
        folowers.folow("Salah");

        vm.stopPrank();
    }

    function testNumberOfFolowers() public {
        vm.startPrank(user1);
        Register.registerUsername("Salah");
        vm.stopPrank();

        vm.startPrank(user2);

        Register.registerUsername("Salim");
        folowers.folow("Salah");

        assertEq(folowers.getNumberOfFolowers("Salah"), 1);

        vm.stopPrank();
    }

    function testYourFolowers() public {
        vm.startPrank(user1);
        Register.registerUsername("Salah");
        vm.stopPrank();

        vm.startPrank(user2);

        Register.registerUsername("Salim");
        folowers.folow("Salah");
        assertEq(folowers.isfolowing("Salah"), true);

        vm.stopPrank();
    }

    function test_RevertWhen_YourNotFolowed() public {
        vm.startPrank(user1);

        Register.registerUsername("Salah");

        vm.stopPrank();

        vm.startPrank(user2);

        Register.registerUsername("Salim");
        vm.expectRevert("You are not folowed");
        folowers.unFolow("Salah");

        vm.stopPrank();
    }

    function testNumberOfFolowersAfterUnfolow() public {
        vm.startPrank(user1);
        Register.registerUsername("Salah");
        vm.stopPrank();

        vm.startPrank(user2);
        Register.registerUsername("Salim");
        folowers.folow("Salah");
        folowers.unFolow("Salah");

        assertEq(folowers.getNumberOfFolowers("Salah"), 0);
        vm.stopPrank();
    }
}
