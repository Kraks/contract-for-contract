from bench import Bench
from typing import List, Tuple

def create(bench: Bench, accounts: List[str]) -> str:
    return bench.call_contract_function(accounts[0], 'constructor', [])

token = None

def prepare(bench: Bench, accounts: List[str], contract_address: str) -> List[str]:
    return [] 

def run(bench: Bench, accounts: List[str], contract_address: str) -> Tuple[List[str], List[str]]:
    fns = []
    hashes = []

    # fns.append('stop')
    # hashes.append(bench.call_contract_function(accounts[0], 'stop', [], contract_addr=contract_address))
    #
    # fns.append('start')
    # hashes.append(bench.call_contract_function(accounts[0], 'start', [], contract_addr=contract_address))
    #
    # fns.append('transfer')
    # hashes.append(bench.call_contract_function(accounts[0], 'transfer', [accounts[1], 100], contract_addr=contract_address))
    #
    # fns.append('approve')
    # hashes.append(bench.call_contract_function(accounts[0], 'approve', [accounts[1], 10000000], contract_addr=contract_address))

    fns.append('transferFrom')
    hashes.append(bench.call_contract_function(accounts[0], 'transferFrom', [accounts[0], accounts[2], 100], contract_addr=contract_address))

    # fns.append('name')
    # hashes.append(bench.call_contract_function(accounts[0], 'name', [], contract_addr=contract_address))
    #
    # fns.append('totalSupply')
    # hashes.append(bench.call_contract_function(accounts[0], 'totalSupply', [], contract_addr=contract_address))
    #
    # fns.append('trust')
    # hashes.append(bench.call_contract_function(accounts[0], 'trust', [accounts[1], True], contract_addr=contract_address))
    #
    # fns.append('trusted')
    # hashes.append(bench.call_contract_function(accounts[0], 'trusted', [accounts[0], accounts[1]], contract_addr=contract_address))
    #
    # fns.append('push')
    # hashes.append(bench.call_contract_function(accounts[0], 'push', [accounts[1], 100], contract_addr=contract_address))
    #
    # fns.append('pull')
    # hashes.append(bench.call_contract_function(accounts[1], 'pull', [accounts[0], 100], contract_addr=contract_address))
    #
    # fns.append('move')
    # hashes.append(bench.call_contract_function(accounts[1], 'move', [accounts[0], accounts[2], 100], contract_addr=contract_address))
    #
    # fns.append('mint')
    # hashes.append(bench.call_contract_function(accounts[0], 'mint', [100], contract_addr=contract_address))
    #
    # fns.append('mint(address,uint256)')
    # hashes.append(bench.call_contract_function(accounts[0], 'mint', [accounts[1], 100], contract_addr=contract_address))
    #
    # fns.append('burn')
    # hashes.append(bench.call_contract_function(accounts[0], 'burn', [100], contract_addr=contract_address))
    #
    # fns.append('burn(address,uint256)')
    # hashes.append(bench.call_contract_function(accounts[0], 'burn', [accounts[1], 100], contract_addr=contract_address))
    #
    # fns.append('setName')
    # hashes.append(bench.call_contract_function(accounts[0], 'setName', [b'\x00'], contract_addr=contract_address))

    return (fns, hashes)
    
