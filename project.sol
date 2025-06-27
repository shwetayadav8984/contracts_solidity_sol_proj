// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CourseCertificate {
    address public admin;

    struct Certificate {
        string courseName;
        string studentName;
        uint256 dateIssued;
        bool isValid;
    }

    mapping(address => Certificate[]) public certificates;

    event CertificateIssued(address indexed student, string courseName);
    event CertificateRevoked(address indexed student, string courseName);

    constructor() {
        admin = msg.sender;
    }

    function issueCertificate(address student, string memory courseName, string memory studentName) public {
        require(msg.sender == admin, "Only admin can issue certificates");

        Certificate memory cert = Certificate({
            courseName: courseName,
            studentName: studentName,
            dateIssued: block.timestamp,
            isValid: true
        });

        certificates[student].push(cert);
        emit CertificateIssued(student, courseName);
    }

    function revokeCertificate(address student, uint index) public {
        require(msg.sender == admin, "Only admin can revoke certificates");
        require(index < certificates[student].length, "Invalid index");

        certificates[student][index].isValid = false;
        emit CertificateRevoked(student, certificates[student][index].courseName);
    }

    function getCertificates(address student) public view returns (Certificate[] memory) {
        return certificates[student];
    }

    function verifyCertificate(address student, uint index) public view returns (bool) {
        require(index < certificates[student].length, "Invalid index");
        return certificates[student][index].isValid;
    }
}
