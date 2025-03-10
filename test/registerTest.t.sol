// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/register.sol";

contract registerTest is register, Test{
    register public Register;
    address user1 = address(1);
    address user2 = address(2);

    function setUp() public{
        Register = new register();
    }

    function testRegisterUsername() public{
        vm.prank(user1);
        Register.registerUsername("Salah");

        assertEq(Register.username(user1),"Salah");
        assertEq(Register.usernameToAddress("Salah"),user1);
    }


    function test_RevertWhen_DuplicateUsername() public{
        vm.prank(user1);
        Register.registerUsername("Salah");

        vm.prank(user2);
        vm.expectRevert("username is alredy used");
        Register.registerUsername("Salah");
    }

    function testDeleteMyAccount() public {
        vm.startPrank(user1);
        Register.registerUsername("Salah");
        Register.deleteMyAccount();

        assertEq(Register.username(user1),"");
        assertEq(Register.usernameToAddress("Salah"),address(0));
        vm.stopPrank();
    }

    function testUpdateUsername() public{
        vm.startPrank(user1);
        Register.registerUsername("Salah");

        Register.updateUsername("do7me");

        assertEq(Register.username(user1),"do7me");
        assertEq(Register.usernameToAddress("do7me"),user1);
        assertEq(Register.usernameToAddress("Salah"),address(0));
        vm.stopPrank();
    }

    function test_RevertWhen_DontHaveUsername() public{
        vm.startPrank(user1);
        vm.expectRevert("You don't have a username yet");
        Register.updateUsername("Salah");
        vm.stopPrank();
    }

    function test_RevertWhen_NoUsernameSet() public{
        vm.startPrank(user1);
        Register.registerUsername("Salah");
        vm.expectRevert("No username set");
        Register.updateUsername("");
        vm.stopPrank();
    }



    function test_RevertWhen_UsernameIsAlredyUsed() public{
        vm.prank(user1);
        Register.registerUsername("Salah");

        vm.startPrank(user2);
        Register.registerUsername("do7me");
        vm.expectRevert("the username is alredy used");
        Register.updateUsername("Salah");
        vm.stopPrank();
    }

}