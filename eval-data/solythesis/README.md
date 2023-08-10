# Run experiments on Solythesis dataset (Li et al.)

## Step 1: Create a local testnet

Install `anvil` from `Foundry`: https://book.getfoundry.sh/getting-started/installation

Start a local blockchain:
```
anvil --ipc <ipc_path> --block-base-fee-per-gas 0 --gas-limit 999999999999999 --gas-price 0 --port <http_port>
```

- `<ipc_path>` is the ipc endpoint for JSON-RPC of the blockchain, e.g., `/tmp/anvil.ipc`.
- `<http_port>` is the port of the http endpoint for JSON-RPC of the blockchain, e.g., `8545`.

## Step 2: Install Python dependencies and prepare Solidity compiler

```
pip3 install progressbar
pip3 install py-solc
pip3 install web3==v5.0.0-beta.2
pip3 install psrecord
pip3 install solc-select
solc-select install 0.5.12
solc-select use 0.5.12
```

## Step 2: Run experiments

### Run experiments on ERC20_BEC and ERC721_DOC using historical transaction replay

Run on original contract:

```
python replay.py <ipc_path> 90000 ../contracts/ERC20_[BEC|DOZ].sol [BecToken|DozerDoll] ./keys/leo123leo987 ./keys/leo123leo456
```

Run on ConSol-implemented contract:

```
python replay.py <ipc_path> 90000 ../contracts/ERC20_[BEC|DOZ]_transpiled.sol [BecToken|DozerDoll] ./keys/leo123leo987 ./keys/leo123leo456
```
### Run experiments on other contracts using test cases

Run on original contract:

```
python expr.py <contract_file_basename> <contract_name>
```

Run on ConSol-implemented contract:

```
python expr.py --transpiled <contract_file_basename> <contract_name>
```

- `<contract_file_basename>` example: `ERC1202_VOTE`.
- `<contract_name>` example: `AdvancedTokenVote1202`.

## Step 4: Gas consumption results

Gas consumption results for each transaction will be generated in folder `results`.
