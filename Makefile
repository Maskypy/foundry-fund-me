-include .env

.PHONY: all test clean deploy fund withdraw

# Default task
all: clean install build

# Basic Foundry Management
clean  :; forge clean
build  :; forge build

# Testing
test   :; forge test
test-v :; forge test -vv

# Networking & Deployment
# Usage: make deploy-anvil OR make deploy-sepolia
deploy-anvil:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(Anvil_RPC_URL) --private-key $(Anvil_PK) --broadcast

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --account $(MY_ACCOUNT) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

# Interactions
fund:
	@forge script script/Interactions.s.sol:FundFundMe --rpc-url $(Anvil_RPC_URL) --private-key $(Anvil_PK) --broadcast

withdraw:
	@forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $(Anvil_RPC_URL) --private-key $(Anvil_PK) --broadcast