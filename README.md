# Foundry Fund Me

# About

This is a minimal project allowing users to fund the contract owner with donations. The smart contract accepts ETH as donations, denominated in USD. Donations have a minimal USD value, otherwise they are rejected. The value is priced using a Chainlink price feed, and the smart contract keeps track of doners in case they are to be rewarded in the future.

### Key Features:
- **Chainlink Price Feeds:** Real-time ETH/USD conversion for minimum donation validation.
- **Foundry DevOps:** Automated address discovery.
- **Testing:** Unit and Integration testing. 
- **Gas Optimized:** Efficient storage patterns using `immutable` and `constant` variables.


## Requirements
 - [foundry](https://getfoundry.sh/)
 - Verify installation by running: `forge --version`
## Quickstart

```
git clone https://github.com/Maskypy/foundry-fund-me.git
cd foundry-fund-me
make install
```
# Usage
## Build & Test
```
forge build
make test          # Runs all unit tests
forge test -vvv    # Runs tests with detailed traces
```
#### Only run test functions 

```
forge test --match-test testFunctionName
```
## Deploy
### Deployment to Local Anvil
1. Run Anvil in a separate terminal: `anvil`
2. Deploy the contract:
    ```make deploy-anvil```


### Test Coverage

```
forge coverage
```

# Deployment to a testnet or mainnet

1. Setup environment variables


You'll want to set your `SEPOLIA_RPC_URL` / `PRIVATE_KEY` and `Anvil_RPC_URL` /  `Anvil_PK` as environment variables.

You can add them to a `.env` file.


2. Get testnet ETH

Head over to [faucets.ethereum.link](https://cloud.google.com/application/web3/faucet/ethereum/sepolia) and get some testnet ETH. You should see the ETH show up in your metamask.

3. Deploy

```
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## Scripts

After deploying to a testnet or local net, you can run the scripts. 

Using cast deployed locally example: 

```
cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>
```

or
```
forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $Anvil_RPC_URL --private-key $PRIVATE_KEY  --broadcast
```

### Withdraw

```
cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()"  --private-key <PRIVATE_KEY>
```

## Estimate gas

You can estimate how much gas things cost by running:

```
forge snapshot
```

And you'll see an output file called `.gas-snapshot`


# Formatting

To run code formatting:
```
forge fmt
```
# Thank you!
