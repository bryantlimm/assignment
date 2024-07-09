// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

contract UpgradedMembershipSystem {
    enum MembershipType { Basic, Premium, VIP }

    struct Member {
        uint256 id;
        string name;
        uint256 balance;
        MembershipType membershipType;
    }

    mapping(address => Member) private members;
    uint256 private nextId = 1;

    function addMember(address newMember, string memory name, uint256 balance, MembershipType membershipType) external {
        require(members[newMember].id == 0, "Member already exists");

        members[newMember] = Member({
            id: nextId,
            name: name,
            balance: balance,
            membershipType: membershipType
        });

        nextId++;
    }

    function removeMember(address existingMember) external {
        require(members[existingMember].id != 0, "Member does not exist");

        delete members[existingMember];
    }

    function isMember(address member) external view returns (bool) {
        return members[member].id != 0;
    }

    function modifyMemberName(address member, string memory newName) external {
        require(members[member].id != 0, "Member does not exist");
        members[member].name = newName;
    }

    function modifyMemberBalance(address member, uint256 newBalance) external {
        require(members[member].id != 0, "Member does not exist");
        members[member].balance = newBalance;
    }

    function modifyMemberType(address member, MembershipType newType) external {
        require(members[member].id != 0, "Member does not exist");
        members[member].membershipType = newType;
    }
}
