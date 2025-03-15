// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./register.sol";

contract Folowers is register {
    register Register;

    constructor(address _register) {
        Register = register(_register);
    }

    mapping(string => uint256) public folowers;
    mapping(string => address[]) public YourFolowers;
    mapping(string => mapping(address => bool)) public isFolowing;

    event NewFolower(string Newfolower);

    function folow(string memory _username) public {
        require(Register.usernameToAddress(_username) != address(0), "empty");
        require(!isFolowing[_username][msg.sender], "You are already folowed");
        folowers[_username] += 1;
        YourFolowers[_username].push(msg.sender);
        isFolowing[_username][msg.sender] = true;
        emit NewFolower(Register.username(msg.sender));
    }

    function unFolow(string memory _username) public {
        require(Register.usernameToAddress(_username) != address(0), "empty");
        require(isFolowing[_username][msg.sender], "You are not folowed");

        folowers[_username] -= 1;
        address[] storage Yourfolowers = YourFolowers[_username];

        for (uint256 i = 0; i < Yourfolowers.length; i++) {
            if (msg.sender == Yourfolowers[i]) {
                Yourfolowers[i] = Yourfolowers[Yourfolowers.length - 1];
                Yourfolowers.pop;
                break;
            }
        }

        isFolowing[_username][msg.sender] = false;
    }

    function getNumberOfFolowers(string memory _username) public view returns (uint256) {
        require(Register.usernameToAddress(_username) != address(0), "empty");
        return folowers[_username];
    }

    function getFolowers(string memory _username) public view returns (address[] memory) {
        address[] storage _folowers = YourFolowers[_username];
        return _folowers;
    }

    function isfolowing(string memory _username) public view returns (bool) {
        return isFolowing[_username][msg.sender];
    }
}
