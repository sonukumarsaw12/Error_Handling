// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//  write a smart contract that implements the require(), assert() and revert() statements.

/*     require(): Used to validate inputs and conditions before executing code.
       assert(): Used to check for conditions that should never be false. 
                 It is typically used to check for invariants.
       revert(): Used to handle situations where an error needs to be flagged 
                 and the current transaction should be reverted.
*/


contract SchoolResult {

    address public owner;
    mapping(uint => Student) public students;
    uint public studentCount;

    struct Student {
        uint id;
        string name;
        uint score;
    }

    event StudentAdded(uint id, string name, uint score);
    event StudentScoreUpdated(uint id, uint newScore);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addStudent(string memory _name, uint _score) public onlyOwner {
        
        require(_score <= 100, "Score must be 100 or less");

        studentCount++;
        students[studentCount] = Student(studentCount, _name, _score);
        
        emit StudentAdded(studentCount, _name, _score);
    }

    function updateScore(uint _id, uint _newScore) public onlyOwner {
       
        require(_id > 0 && _id <= studentCount, "Student does not exist");

        require(_newScore <= 100, "Score must be 100 or less");

        students[_id].score = _newScore;

        emit StudentScoreUpdated(_id, _newScore);
    }

    function getStudent(uint _id) public view returns (uint, string memory, uint) {
        assert(_id > 0 && _id <= studentCount);

        Student memory student = students[_id];
        return (student.id, student.name, student.score);
    }

    function removeStudent(uint _id) public onlyOwner {
        require(_id > 0 && _id <= studentCount, "Student does not exist");
        if (students[_id].score > 90) {
            revert("Cannot remove student with a score above 90");
        }

        delete students[_id];
        studentCount--;
    }
}
