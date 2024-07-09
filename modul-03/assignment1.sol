// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

contract MembershipSystem {
    mapping(address => bool) private members;

    function addMember(address newMember) external {
        members[newMember] = true;
    }

    function removeMember(address existingMember) external {
        members[existingMember] = false;
    }

    function isMember(address member) external view returns (bool) {
        return members[member];
    }
}
