import argparse
import os
import json
import time
import importlib
from bench import Bench

dir_path = os.path.dirname(os.path.realpath(__file__))

parser = argparse.ArgumentParser(description='Experiment')
parser.add_argument('contract')
parser.add_argument('contract_name')
parser.add_argument('--transpiled', action='store_true')
args = parser.parse_args()

contract = args.contract if not args.transpiled else f"{args.contract}_transpiled"

contract_path = f"../contracts/{contract}.sol" 
bench = Bench('/tmp/anvil.ipc', contract_path, args.contract_name, False)
accounts = bench.w3.eth.accounts

# load test suite 
suite = importlib.import_module(f"test_cases.{args.contract}")

# deploy contract
print(f"Deploying contract {args.contract_name}")
bench.w3.anvil.set_automine(True)
tx = suite.create(bench, accounts)
contract_address = bench.wait_for_result(tx).contractAddress

# preparation
print("Running preparation")
bench.w3.anvil.set_automine(True)
txs = suite.prepare(bench, accounts, contract_address)
receipts = [bench.wait_for_result(tx) for tx in txs]
for receipt in receipts:
    assert receipt.status == 1, "Preparation failed"

print(f"Contract address: {contract_address}")
print("Running test suite")
bench.w3.anvil.set_automine(False)
(fns, hashes) = suite.run(bench, accounts, contract_address) # list of functions and transaction hashes
bench.w3.anvil.mine()
txs = [bench.w3.eth.get_transaction(h) for h in hashes] # list of transactions
receipts = [bench.wait_for_result(h, check_successful=False) for h in hashes] # list of transaction receipts
for i, receipt in enumerate(receipts):
    assert receipt.status == 1, f"Test failed: {i}"

with open(f"output/{os.path.basename(contract)}_results.json", 'w') as f:
    for i in range(len(txs)):
        f.write(json.dumps({
            "function": fns[i],
            "gas": int(receipts[i].gasUsed)
        }) + '\n')
