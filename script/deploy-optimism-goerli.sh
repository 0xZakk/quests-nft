forge script \
  script/Deploy.s.sol \
  --fork-url $OPTIMISM_GOERLI_RPC_URL \
  --etherscan-api-key $OPSCAN_API_KEY \
  --verifier-url https://api-goerli-optimistic.etherscan.io/api \
  --broadcast --verify -vvv

