import sys
import csv
import progressbar
import argparse
from bench import Bench
import os
import json
import time

dir_path = os.path.dirname(os.path.realpath(__file__))

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('endpoint')
parser.add_argument('iter', type=int)
#  parser.add_argument('csv')
parser.add_argument('path')
parser.add_argument('contract_name')
parser.add_argument('key1')
parser.add_argument('key2')
parser.add_argument("--pow", dest="pow", action="store_true")
parser.add_argument("--progress-bar", dest="progress_bar", action="store_true")
parser.add_argument("--bucket", dest="bucket", type=int, default=16)
args = parser.parse_args()

ITER = args.iter
bucket = args.bucket

if 'ERC20' in args.path:
    contract_name = 'BecToken'
    origin_creator = "0x36642d20f2E288f18A9a21b544AA853C594DD312"
    constructor_args = []
    NUM_OF_CONTRACT = 1
    csv_path = os.path.join(dir_path, 'data', 'erc20.csv')
else:
    contract_name = 'DozerDoll'
    origin_creator = "0x6f53E6F92E85C084E10AAf35D4A44DEE6a27892d"
    constructor_args = ["a", "b"]
    NUM_OF_CONTRACT = 1
    csv_path = os.path.join(dir_path, 'data', 'erc721.csv')


bench = Bench(args.endpoint, args.path, args.contract_name, args.pow)
contract_creator = bench.import_account(args.key1)

bench.w3.anvil.set_automine(True)

with open(csv_path) as f:
    reader = csv.DictReader(f)
    transactions = list(reader)

bench.address_mapping(origin_creator, contract_creator[0])
print('creator: ' + contract_creator[0])

contract_address = [bench.call_contract_function(contract_creator[0], 'constructor', constructor_args,
                                                 private_key=contract_creator[1], wait=True)
                    for i in range(NUM_OF_CONTRACT)]
contract_address = [bench.wait_for_result(
    x, gen_pow=False).contractAddress for x in contract_address]


bar = progressbar.ProgressBar(maxval=ITER,
                              widgets=[progressbar.Bar('=', '[', ']'), ' ', progressbar.Percentage()])
bar.start()

bench.w3.anvil.set_automine(False)

assert bucket > 0
start_at = time.time()

total_txs = 0
total_gas = 0
gas_usage = []
for idx in range(0, ITER, bucket):
    gas = 0
    if args.progress_bar:
        bar.update(idx)
    else:
        now = time.time()
        print(idx, now-start_at, (now-start_at)/(idx+1) * NUM_OF_CONTRACT)

    # execute transaction in bucket
    txs = transactions[idx: idx + bucket]
    # tx results
    results = []
    for tx in txs:
        if int(tx['status']) == 0:
            results.append(None)
            continue
        new = bench.address_mapping(tx['from'])
        # bench.transfer(contract_creator[0], new,
        #                100000000000000, contract_creator[1])
        # tx result for NUM_OF_CONTRACT
        tx_result = []
        try:
            for k in range(NUM_OF_CONTRACT):
                sender = bench.address_mapping(tx['from'])
                value = int(tx['value'])

                private_key = None
                if sender.lower() == contract_creator[0].lower():
                    private_key = contract_creator[1]
                result = bench.replay_contract_function(
                    tx['input'], sender, contract_address[k], value, private_key)
                tx_result.append(result)
            results.append(tx_result)
            total_txs += 1
        except Exception as e:
            results.append(None)
            continue

    bench.w3.anvil.mine()

    # wait for tx results
    for i in range(len(results)):
        if results[i] is None:
            gas_usage.append(None)
            continue
        gas = 0
        for j in range(len(results[i])):
            receipt = bench.wait_for_result(results[i][j], check_successful=False)
            if receipt.status == 0:
                gas_usage.append(None)
                break
            gas += receipt.gasUsed
        else:
            avg_gas = gas / NUM_OF_CONTRACT
            gas_usage.append(avg_gas)
            total_gas += avg_gas

with open(f"output/{os.path.basename(args.path)}_gas.json", 'w') as f:
    json.dump(gas_usage, f)
