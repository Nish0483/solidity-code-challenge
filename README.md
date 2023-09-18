# solidity-code-challenge
the challenge: 

‘Pied Piper’ has emerged as the winning team in the DApp World Arena, the annual web3 multi-player gaming fest. The winning prize of the tournament is a huge amount of money, which will be given in form of credits. For this, DApp World Arena will be sharing the credits in form of a smart contract based shared wallet.

How will the wallet be shared?

This wallet will be in form of a smart contract.
The smart contract will be deployed by the DApp World Arena Judge.
After deploying the smartcontract, the deployer will initialize the smart contract with all the addresses of the members of Pied Piper and the winning prize credit amount by running a one time accessible function of smartcontract.
Now, the smart contract will be ready for the winning team members to use.

How will the winning team use this smart contract?
After the smart contract is completely set to use for the winning team members, the members of the team can create transaction requests inside the smart contract to spend the credits from the smart contract.
There is no limit on the number of transaction requests that can be created in the smart contract.
Any transaction request needs approval from at least 70% of the team members to be completed.
Once a transaction request gets enough approvals, the request will be completed successfully and the credits from the wallet will be spent.
A transaction request can also be rejected by the team members. If a transaction request gets rejections by more than 30% of the team members, then the transaction request will be marked as failed, and the credits will not be spent for that transaction.
Any transaction request which has a spending amount greater than the current available credits in the wallet must automatically fail.

Impressed by your smart contract programming skills, DApp World Arena has selected you to create and give them the required smart contract. Given below are the required public functions which the smart contract must contain :

 

Input:
setWallet(address[] members, uint credits) public: This function is accessible only to the deployer of the smartcontract. The members array will have the addresses of all the members of the winning team. ‘members’ must contain at least one member address. The credits must be strictly greater than 0. The deployer of the smart contract cannot be a member of the team. This function must only execute once, and should not be callable once successfully executed.

spend(uint amount) public: This function will be accessible only to the winning team members. Using this function, a team member can record a transaction request to the smart contract. The amount should be strictly greater than 0. By default, an approval will be recorded for the transaction from the member who is sending transaction request.
Note : Any spend request would be recorded in the smart contract irrespective of the amount, even if the amount exceeds the available credits.

approve(uint n) public: This function will be accessible only to the winning team members. Using this function, a team member can record an approval for nth transaction request sent to the smart contract. This function will revert if the team member has already approved or rejected the nth transaction request.

reject(uint n) public: This function will be accessible only to the winning team members. Using this function, a team member can record a rejection for nth transaction request sent to the smart contract. This function will revert if the team member has already approved or rejected the nth transaction request.

 

Output:
credits() returns (uint): This function will be accessible only to the winning team members. The output must be the current available credits in the wallet.

viewTransaction(uint n) returns (uint amount,string status):This function will be accessible only to the winning team members. ‘amount’ is the spent amount requested for the nth transaction request. ‘status ’ must be :

“pending” : if the transaction request is pending,
“debited” : if the transaction request has been executed and the credits have been spent,
“failed” : if the transaction request has failed.
transactionStats() returns (uint debitedCount,uint pendingCount,uint failedCount):This function will be accessible only to the winning team members. Three output values must be as follows:

‘debitedCount’ : number of transaction requests which have been executed successfully.
‘pendingCount’ : number of transaction requests which are pending.
‘failed’ : number of transaction requests which have failed.
