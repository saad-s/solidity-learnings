## solidity-learnings

notes and contracts for solidity

### Truffle setup 
```
npm install truffle -g
mkdir MyContract && cd MyContract
truffle init . 
truffle create contract MyContract
truffle create test MyContract
```
create new or edit default migrate file after adding contract.

### Truffle testing  
``` 
truffle compile 
truffle test
truffle develop
truffle(develop)> migrate 
truffle(develop)> migrate --reset ;; for redeployment 

;; load contract instance and interact with contract 
truffle(develop)> let instance = await MyContract.deployed()
;; call function with args 
truffle(develop)> instance.myPublicFunction(args) 
;; call from other accounts
truffle(develop)> instance.myPublicFunction({from: accounts[2]})
;; call payable functions
truffle(develop)> instance.myPublicFunction({value: web3.utils.toWei("1", "ether")}) 
```