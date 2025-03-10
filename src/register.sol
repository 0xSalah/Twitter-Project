// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract register{
    mapping (address => string) public  username;
    mapping (string => address) public usernameToAddress;
    event newRegister(address indexed user,string username);
    event deleteTheAccount(string username);
    event updateTheUsername(string oldUsername, string newUsername);

    modifier newUsername(string memory username){
        require(usernameToAddress[username] == address(0), "username is alredy used");
        _;
    }

    function registerUsername(string memory _username) newUsername(_username) public {

        username[msg.sender] = _username;
        usernameToAddress[_username] = msg.sender;

        emit newRegister(msg.sender, _username);
    }

    function deleteMyAccount() public {
        string memory _username = username[msg.sender];

        delete username[msg.sender];
        delete usernameToAddress[_username];
        emit deleteTheAccount(_username);
    }

    function updateUsername(string memory _newUsername) public {
        require(usernameToAddress[_newUsername] == address(0), "the username is alredy used");
        string memory oldUsername = username[msg.sender];
        require(msg.sender == usernameToAddress[oldUsername],"The username is not your own");
        delete username[msg.sender];
        delete usernameToAddress[oldUsername];
        username[msg.sender] = _newUsername;
        usernameToAddress[_newUsername] = msg.sender;
        emit  updateTheUsername(oldUsername,_newUsername);
    }

    

}