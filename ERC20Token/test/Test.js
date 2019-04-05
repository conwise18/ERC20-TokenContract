const { BN, constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');
const { ZERO_ADDRESS } = constants;

//const shouldFail = require('../helpers/shouldFail');
//const expectEvent = require('../helpers/expectEvent');

const token = artifacts.require('ERC20Token.sol');

const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

const name = "A Very High Token";
const symbol = "HIGH";
const decimals = 10;
const _totalSupply = 21000000;  

contract('ERC20', function ([owner, recipient, anotherAccount]) {
  beforeEach(async function () {
    this.token = await token.new();
  });

  describe('total supply', function () {
    it('returns the total amount of tokens', async function () {
      (await this.token.totalSupply()).should.be.bignumber.equal(_totalSupply);
    });
  });

  describe('how many decimals', function () {
    it('should have the same amount of decimals as provided in the constructor of the contract', async function () {
      (await this.token.decimals()).should.be.bignumber.equal(decimals);
    });
  });

  describe('name of token', function () {
    it('should be the same name as specified in the constructor of the contract', async function () {
      (await this.token.name()).should.be.equal(name);
    });
  });

  describe('symbol', function () {
    it('should have the same symbol as specified in the contract constructor', async function () {
      (await this.token.symbol()).should.be.equal(symbol);
    });
  });

  describe('balanceOf', function () {
    describe('when the requested account has no tokens', function () {
      it('returns zero', async function () {
        (await this.token.getBalance(anotherAccount)).should.be.bignumber.equal(0);
      });
    });

    describe('when the requested account has some tokens', function () {
      it('returns the total amount of tokens', async function () {
        (await this.token.getBalance(owner)).should.be.bignumber.equal(21000000);
      });
    });
  });

   describe('transfer', function () {
    describe('when the recipient is not the zero address', function () {
      const to = recipient;

      describe('when the sender does not have enough balance', function () {
        const amount = 210000001;

        it('reverts', async function () {
          await shouldFail.reverting(this.token.transfer(to, amount, { from: owner }));
        });
      });

      describe('when the sender has enough balance', function () {
        const amount = 21000000;

        it('transfers the requested amount', async function () {
          await this.token.transfer(to, amount, { from: owner });

          (await this.token.getBalance(owner)).should.be.bignumber.equal(0);

          (await this.token.getBalance(to)).should.be.bignumber.equal(amount);
        });
      });
    });
  });  
});  