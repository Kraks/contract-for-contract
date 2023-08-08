from bench import Bench
from typing import List, Tuple

def create(bench: Bench, accounts: List[str]) -> str:
    return bench.call_contract_function(accounts[0], 'constructor', [])

new_token = None

def prepare(bench: Bench, accounts: List[str], contract_address: str) -> List[str]:
    return [] 

def run(bench: Bench, accounts: List[str], contract_address: str) -> Tuple[List[str], List[str]]:
    fns = []
    hashes = []

    # fns.append('changeController')
    # hashes.append(bench.call_contract_function(accounts[0], 'changeController', [accounts[1]], contract_addr=contract_address))
    #
    # fns.append('getController')
    # hashes.append(bench.call_contract_function(accounts[0], 'getController', [], contract_addr=contract_address))
    #
    # fns.append('changeController')
    # hashes.append(bench.call_contract_function(accounts[1], 'changeController', [accounts[0]], contract_addr=contract_address))

    fns.append('transfer')
    hashes.append(bench.call_contract_function(accounts[0], 'transfer', [accounts[1], 100], contract_addr=contract_address))

    # fns.append('approve')
    # hashes.append(bench.call_contract_function(accounts[0], 'approve', [accounts[1], 10000000], contract_addr=contract_address))
    #
    # fns.append('name')
    # hashes.append(bench.call_contract_function(accounts[0], 'name', [], contract_addr=contract_address))
    #
    # fns.append('totalSupply')
    # hashes.append(bench.call_contract_function(accounts[0], 'totalSupply', [], contract_addr=contract_address))
    #
    # fns.append('mint')
    # hashes.append(bench.call_contract_function(accounts[0], 'mint', [accounts[0], 10000000], contract_addr=contract_address))
    #
    # fns.append('allowPrecirculation')
    # hashes.append(bench.call_contract_function(accounts[0], 'allowPrecirculation', [accounts[0]], contract_addr=contract_address))
    #
    # fns.append('allowPrecirculation')
    # hashes.append(bench.call_contract_function(accounts[0], 'allowPrecirculation', [accounts[1]], contract_addr=contract_address))
    #
    # fns.append('allowPrecirculation')
    # hashes.append(bench.call_contract_function(accounts[0], 'allowPrecirculation', [accounts[2]], contract_addr=contract_address))
    #
    # fns.append('transferFrom')
    # hashes.append(bench.call_contract_function(accounts[1], 'transferFrom', [accounts[0], accounts[2], 100], contract_addr=contract_address))
    #
    #
    # fns.append('disallowPrecirculation')
    # hashes.append(bench.call_contract_function(accounts[0], 'disallowPrecirculation', [accounts[0]], contract_addr=contract_address))
    #
    # fns.append('isPrecirculationAllowed')
    # hashes.append(bench.call_contract_function(accounts[0], 'isPrecirculationAllowed', [accounts[0]], contract_addr=contract_address))

    return (fns, hashes)
    
