// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract register {
    string[3] public honoredUsers = ["bc5.n", "iiissvvee", "7v_q21"];
    mapping(address => string) public username;
    mapping(string => address) public usernameToAddress;

    event NewRegister(address indexed user, string username);
    event DeleteTheAccount(string username);
    event UpdateTheUsername(string oldUsername, string newUsername);

    modifier newUsername(string memory _username) {
        require(usernameToAddress[_username] == address(0), "username is alredy used");
        _;
    }

    function registerUsername(string memory _username) public newUsername(_username) {
        username[msg.sender] = _username;
        usernameToAddress[_username] = msg.sender;

        emit NewRegister(msg.sender, _username);
    }

    function deleteMyAccount() public {
        string memory _username = username[msg.sender];

        delete username[msg.sender];
        delete usernameToAddress[_username];
        emit DeleteTheAccount(_username);
    }

    function updateUsername(string memory _newUsername) public {
        require(bytes(username[msg.sender]).length > 0, "You don't have a username yet");
        require(bytes(_newUsername).length > 0, "No username set");
        require(usernameToAddress[_newUsername] == address(0), "the username is alredy used");
        string memory oldUsername = username[msg.sender];
        delete username[msg.sender];
        delete usernameToAddress[oldUsername];
        username[msg.sender] = _newUsername;
        usernameToAddress[_newUsername] = msg.sender;
        emit UpdateTheUsername(oldUsername, _newUsername);
    }
}
