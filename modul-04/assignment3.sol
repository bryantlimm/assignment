// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedVotingSystem {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    uint256[] public candidateIds;
    mapping(address => bool) public voters;

    uint256 public candidateCount;

    event CandidateAdded(uint256 id, string name);
    event VoteCast(uint256 candidateId, address voter);
    event WinnerDeclared(uint256 candidateId, string name, uint256 voteCount);

    function addCandidate(string memory _name) public {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        candidateIds.push(candidateCount);
        
        emit CandidateAdded(candidateCount, _name);
    }

    function vote(uint256 _candidateId) public {
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID.");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit VoteCast(_candidateId, msg.sender);
    }

    function getTotalVotes(uint256 _candidateId) public view returns (uint256) {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID.");
        return candidates[_candidateId].voteCount;
    }

    function declareWinner() public view returns (uint256 winnerId, string memory winnerName, uint256 winnerVoteCount) {
        uint256 highestVoteCount = 0;
        for (uint256 i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > highestVoteCount) {
                highestVoteCount = candidates[i].voteCount;
                winnerId = candidates[i].id;
                winnerName = candidates[i].name;
                winnerVoteCount = candidates[i].voteCount;
            }
        }

        emit WinnerDeclared(winnerId, winnerName, winnerVoteCount);
        return (winnerId, winnerName, winnerVoteCount);
    }
}
