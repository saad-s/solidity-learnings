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
create a one new or edit default migration file after adding a contract.

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

## Solidity 

#### Functions visibility 
* Private - can only be called from inside smart contract
* Internal - can only be called from inside smart contract and inherited contracts
* External - can only be called from outside smart contract -- [inherited contracts -> TBA]
* Public - can be called from anywhere

```solidity
function myFunction() <visibility specifier> returns (bool) {
    return true;
}
```

#### Functions state mutability 
* View - RO, can only reads from chain
* Pure - doesn’t interact with chain, 
* Payable - [TBA]

```solidity
function myFunction() public view returns (bool) {
    return true;
}
```

#### Functions modifiers 
Adds conditions to execute before, after or while executing a function. 
```solidity
// verifies caller before executing functions 
modifier onlyOwner {
    require(msg.sender == owner, "Only owner can call this function.");
    _;
}
// verifies result after function has computed value
modifier validateResult(uint computedValue) {
    _;
    require(computedValue == PI, "Invalid Result");
}

function myFunction() public onlyOwner validateResult(value) view returns (bool) {
    return true;
}
```

### Special Functions 

#### Constructors
* Optional
* Executes on contract creation 

#### Init function
For clones, proxies or libraries an init function is defined instead of a constructor. 
Should be used generally with a single init or reentrant guard. 

#### Fallback function 
* Nameless function 
* Called when other contracts call wrong function name 
* Called when eth is transferred to this contract 
* Can only be defined once per contract 
* Must be external / public 

### Global variables
Generally language keywords can be described in three categories 
1. tx
2. Msg
3. Block
  
`tx.origin` vs `msg.sender`
  1. Alice calls Smart Contract A => {`tx.origin`: Alice, `msg.sender`: Alice}
  2. Smart Contract A calls Smart Contract B => {`tx.origin`: Alice, `msg.sender`: Smart Contract A}