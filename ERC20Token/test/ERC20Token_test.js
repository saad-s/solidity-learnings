const ERC20 = artifacts.require("ERC20Token");
const truffleAssert = require('truffle-assertions');

contract("ERC20Token", (accounts) => {
  const amount = 399;
  const owner = accounts[0];
  const account1 = accounts[1];
  const account2 = accounts[2];

  // test: token details 

  describe('mint', () => {
    // test: should not work for ZERO_ACCOUNT
    // test: should only work for owner account

    // get contract instance 
    before(async () => {
      this.token = await ERC20.deployed();
    });
    beforeEach(async () => {
      this.receipt = await this.token.mint(owner, amount);
    });
    
    it('should update balance of recipient', async () => {
      const balance = await this.token.balanceOf(owner);
      // TODO: do we need to always use return ???
      return assert.equal(balance.toNumber(), amount);
    });

    it('should update total supply of token', async () => {
      const totalSupply = await this.token.totalSupply();
      return assert.equal(totalSupply.toNumber(), amount);
    });

    it('should emit an event on success', () => {
      truffleAssert.eventEmitted(this.receipt, "Transfer", 
        (ev) => {return ev.to === owner && ev.value.toNumber() === amount;},
        "should trigger transfer event");
    });

    afterEach(async () => {
      await this.token.burn(amount);
    });
  });

  describe('burn', () => {
    // get contract instance 
    before(async () => {
      this.token = await ERC20.deployed();
    });
    // add some token for burning tests 
    beforeEach(async () => {
      await this.token.mint(owner, amount);
    });

    it('should update balance of recipient', async () => {
      // burn the amount, and verify that balance has decreased
      await truffleAssert.passes(this.token.burn(amount), 'burn should not fail');
      balance = await this.token.balanceOf(owner);
      return assert.equal(balance.toNumber(), 0);
    });

    it('should check for available balance', async () => {
      // burn the double amount 
      await truffleAssert.fails(this.token.burn(amount * 2), truffleAssert.ErrorType.REVERT);
      // burn the amount now 
      return await truffleAssert.passes(this.token.burn(amount), 'burn should not fail');
    });
    
    it('should update total supply of token', async () => {
      // burn the amount, and verify that total supply has decreased
      await truffleAssert.passes(this.token.burn(amount), 'burn should not fail');
      const totalSupply = await this.token.totalSupply();
      return assert.equal(totalSupply.toNumber(), 0);
    });

    it('should emit an event on success', async () => {
      this.receipt = await this.token.burn(amount);
      truffleAssert.eventEmitted(this.receipt, 'Transfer', 
        (ev) => {return ev.from === owner && ev.value.toNumber() === amount;},
        'should trigger transfer event');
    });
  });

  describe('transfer', () => {
    // get contract instance 
    before(async () => {
      this.token = await ERC20.deployed();
    });
    // mint tokens for owner account 
    before(async () => {
      await this.token.mint(owner, amount);
    });

    it('should check for available tokens', async () => {
      // transfer more amount than available 
      return truffleAssert.fails(this.token.transfer(account1, amount * 2), truffleAssert.ErrorType.REVERT, 'not enough tokens available');
    });

    it('should update balances', async () => {
      this.receipt = await this.token.transfer(account1, amount);
      const senderBalance = await this.token.balanceOf(owner);
      const receiverBalance = await this.token.balanceOf(account1);
      assert.equal(senderBalance.toNumber(), 0);
      return assert.equal(receiverBalance.toNumber(), amount);
    });

    it('should emit transfer event', () => {
      truffleAssert.eventEmitted(this.receipt, 'Transfer', 
      (ev) => {return ev.from === owner && ev.to === account1, ev.value.toNumber() === amount},
      'should trigger transfer event');
    }); 
  });

  describe('approve', () => {
    // get contract instance 
    before(async () => {
      this.token = await ERC20.deployed();
    });
    // add some token for burning tests 
    before(async () => {
      await this.token.mint(owner, amount);
    });

    it('should check for approver balance', async () => {
      // try to allocate double the available amount 
      return truffleAssert.fails(this.token.approve(account1, amount*2), truffleAssert.ErrorType.REVERT, 'not enough tokens available')
    }); 

    it('should update approved amount', async () => {
      // allowance
      this.receipt = await this.token.approve(account1, amount);
      const allowance = await this.token.allowance(owner, account1);
      return assert.equal(allowance.toNumber(), amount);
    });
    
    it('should emit approval event', async () => {
      truffleAssert.eventEmitted(this.receipt, 'Approval', 
      (ev) => {return ev.owner === owner, ev.spender === account1, ev.value.toNumber() === amount}, 
      'should trigger approval event');
    });
  });

  // describe('transferFrom', () => {
  //   // get contract instance 
  //   before(async () => {
  //     this.token = await ERC20.deployed();
  //   });
  //   // add some token for burning tests 
  //   before(async () => {
  //     await this.token.mint(owner, amount);
  //     // approve amount for spending
  //     await this.token.approve(account1, amount);
  //   });

  //   it('should only allow approved amount to be spent', async () => {
  //     // try to spend amount, when none is allocated [account2 is not approved to spend any]
  //     truffleAssert.fails(this.token.transferFrom(owner, account1, amount, {from: account2}), truffleAssert.ErrorType.REVERT);
  //     // try to spend "double" than approved amount [account1 is approved to spend amount]
  //     truffleAssert.fails(this.token.transferFrom(owner, account2, (amount * 2), {from: account1}), truffleAssert.ErrorType.REVERT);
  //   });

  //   it('should check for original account owner\'s balance', async () => {
  //     // transfer 1 token to some other account [by owner]
  //     await this.token.transfer(account2, 1);
  //     // owner now has 1 less token balance than approved for spending
  //     // try spending full approved amount 
  //     truffleAssert.fails(this.token.transferFrom(owner, account2, amount, {from: account1}), truffleAssert.ErrorType.REVERT, 'not enough tokens available');
  //     // transfer back 1 token to owner for further tests
  //     await this.token.transfer(owner, 1, {from: account2});
  //   });

  //   it ('should update balances and approved amount', async () => {
  //     this.receipt = await this.token.transferFrom(owner, account2, amount, {from: account1});
  //     const ownerBalance = await this.token.balanceOf(owner);
  //     const account2Balance = await this.token.balanceOf(account2);
  //     assert.equal(ownerBalance.toNumber(), 0);
  //     return assert.equal(account2Balance.toNumber(), amount);
  //   });

  //   // test: should emit transfer event
  // });

});
