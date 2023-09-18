// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TeamWallet {
    address public owner;
    address[] public Members;
    uint  totalCredits;

    enum TransactionStatus { Pending, Debited, Failed }

    struct Transaction {
        uint amount;
        TransactionStatus status;
        address requestedBy;
        uint approvals;
        uint rejections;
    }

    Transaction[] internal  transactions;

    mapping(address => uint) public memberCredits;
    mapping(uint => mapping(address => bool)) internal approvalStatus;
    mapping(uint => mapping(address => bool)) internal rejectionStatus;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the deployer can call this function");
        _;
    }

    modifier onlyMembers() {
        require(isMember(msg.sender), "Only team members can call this function");
        _;
    }

    modifier onlyOnce() {
        require(Members.length == 0, "This function can only be called once");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setWallet(address[] memory members, uint credtis) public onlyOwner onlyOnce {
        require(members.length > 0, "At least one member address required");
        require(credtis > 0, "Credits must be greater than 0");

        Members = members;
        totalCredits = credtis;
    }

    function spend(uint amount) public onlyMembers {
        require(amount > 0, "Amount must be greater than 0");
        require(totalCredits >= amount, "Not enough credits in the contract wallet");

        Transaction memory newTransaction = Transaction({
            amount: amount,
            status: TransactionStatus.Pending,
            requestedBy: msg.sender,
            approvals: 0,
            rejections: 0
        });

        transactions.push(newTransaction);
    }

    function approve(uint n) public onlyMembers {
        require(n < transactions.length, "Transaction does not exist");
        Transaction storage transaction = transactions[n];
        require(transaction.status == TransactionStatus.Pending, "Transaction is not pending");
        require(transaction.requestedBy != msg.sender, "You cannot approve your own transaction");
        require(!approvalStatus[n][msg.sender], "You have already approved this transaction");

        approvalStatus[n][msg.sender] = true;
        transaction.approvals++;

        if (transaction.approvals >= (Members.length * 7) / 10) {
            transaction.status = TransactionStatus.Debited;
            memberCredits[transaction.requestedBy] += transaction.amount;
            totalCredits -= transaction.amount;
        }
    }

    function reject(uint n) public onlyMembers {
        require(n < transactions.length, "Transaction does not exist");
        Transaction storage transaction = transactions[n];
        require(transaction.status == TransactionStatus.Pending, "Transaction is not pending");
        require(transaction.requestedBy != msg.sender, "You cannot reject your own transaction");
        require(!rejectionStatus[n][msg.sender], "You have already rejected this transaction");

        rejectionStatus[n][msg.sender] = true;
        transaction.rejections++;

        if (transaction.rejections > (Members.length * 3) / 10) {
            transaction.status = TransactionStatus.Failed;
        }
    }

    function credits() public view onlyMembers returns (uint ) {
       // return memberCredits[msg.sender];
       return totalCredits;
    }

    function viewTransaction(uint n) public view onlyMembers returns (uint amount, string memory status) {
        require(n < transactions.length, "Transaction does not exist");

        Transaction storage transaction = transactions[n];

        if (transaction.status == TransactionStatus.Pending) {
            status = "pending";
        } else if (transaction.status == TransactionStatus.Debited) {
            status = "debited";
        } else {
            status = "failed";
        }

        return (transaction.amount, status);
    }

    function isMember(address member) internal view returns (bool) {
        for (uint i = 0; i < Members.length; i++) {
            if (member == Members[i]) {
                return true;
            }
        }
        return false;
    }
    
    function transactionStats() public view returns (uint debitedCount, uint pendingCount, uint failedCount) {
    for (uint i = 1; i < transactions.length; i++) {
        if (transactions[i].status == TransactionStatus.Debited) {
            debitedCount++;
        } else if (transactions[i].status == TransactionStatus.Pending) {
            pendingCount++;
        } else if (transactions[i].status == TransactionStatus.Failed) {
            failedCount++;
        }
    }
   }






}
