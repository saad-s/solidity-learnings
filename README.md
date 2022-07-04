## solidity-learnings

notes and links for solidity

### Truffle setup 
```bash
npm install truffle -g
mkdir MyContract && cd MyContract
truffle init . 
truffle create contract MyContract
truffle create test MyContract
```
create new or edit default migrate file after adding contract.

### Truffle testing  
```bash
truffle compile 
truffle test
truffle develop
truffle(develop)> migrate 
truffle(develop)> migrate --reset # for redeployment 

# load contract instance and interact with contract 
truffle(develop)> let instance = await MyContract.deployed()
# call function with args 
truffle(develop)> instance.myPublicFunction(args) 
# call from other accounts
truffle(develop)> instance.myPublicFunction({from: accounts[2]})
# call payable functions
truffle(develop)> instance.myPublicFunction({value: web3.utils.toWei("1", "ether")}) 
```

### Solidity concepts

#### Functions visibility 
* Private - can only be called from inside smart contract
* Internal - can only be called from inside smart contract and inherited contracts
* External - can only be called from outside smart contract -- [inherited contracts -> TBA]
* Public - can be called from anywhere

```solidity
function transfer(address recipient, uint amount) external returns (bool) {
    // add implementation here 
}
```

#### Functions modifiers 
* View - RO, can only reads from chain
* Pure - doesn’t interact with chain, 
* Payable - [TBA]

```solidity
function getDetails(uint _number) public view returns (RoomStatus memory) {
    // add implementation here
}
```

#### Constructors
Always public [verified?]

#### Language Keywords
Generally language keywords can be described in three categories 
1. tx
2. Msg
3. Block
  
`tx.origin` vs `msg.sender`
  1. Alice calls Smart Contract A {`tx.origin`: Alice, `msg.sender`: Alice}
  2. Smart Contract A calls Smart Contract B {`tx.origin`: Alice, `msg.sender`: Smart Contract A}