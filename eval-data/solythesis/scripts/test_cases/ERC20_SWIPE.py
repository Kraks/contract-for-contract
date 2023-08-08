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

    # fns.append('freeze')
    # hashes.append(bench.call_contract_function(accounts[0], 'freeze', [], contract_addr=contract_address))
    #
    # fns.append('unfreeze')
    # hashes.append(bench.call_contract_function(accounts[0], 'unfreeze', [], contract_addr=contract_address))
    #
    # fns.append('lockUser')
    # hashes.append(bench.call_contract_function(accounts[0], 'lockUser', [accounts[1]], contract_addr=contract_address))
    #
    # fns.append('unlockUser')
    # hashes.append(bench.call_contract_function(accounts[0], 'unlockUser', [accounts[1]], contract_addr=contract_address))

    fns.append('transfer')
    hashes.append(bench.call_contract_function(accounts[0], 'transfer', [accounts[1], 100], contract_addr=contract_address))

    # fns.append('approve')
    # hashes.append(bench.call_contract_function(accounts[0], 'approve', [accounts[1], 10000000], contract_addr=contract_address))
    #
    # fns.append('transferFrom')
    # hashes.append(bench.call_contract_function(accounts[1], 'transferFrom', [accounts[0], accounts[2], 100], contract_addr=contract_address))
    #
    # fns.append('name')
    # hashes.append(bench.call_contract_function(accounts[0], 'name', [], contract_addr=contract_address))
    #
    # fns.append('totalSupply')
    # hashes.append(bench.call_contract_function(accounts[0], 'totalSupply', [], contract_addr=contract_address))
    #
    # fns.append('burn')
    # hashes.append(bench.call_contract_function(accounts[0], 'burn', [100], contract_addr=contract_address))
    #
    # fns.append('approveAndCall')
    # hashes.append(bench.call_contract_function(accounts[0], 'approveAndCall', [contract_address, 10000000, '0x'], contract_addr=contract_address))
    #
    # fns.append('burnForAllowance')
    # hashes.append(bench.call_contract_function(accounts[0], 'burnForAllowance', [accounts[0], accounts[0], 100], contract_addr=contract_address))
    #
    # fns.append('transfer')
    # hashes.append(bench.call_contract_function(accounts[0], 'transfer', [contract_address, 100], contract_addr=contract_address))
    #
    # fns.append('transferAnyERC20Token')
    # hashes.append(bench.call_contract_function(accounts[0], 'transferAnyERC20Token', [contract_address, 100], contract_addr=contract_address))
    #
    # fns.append('transferOwnership')
    # hashes.append(bench.call_contract_function(accounts[0], 'transferOwnership', [accounts[1]], contract_addr=contract_address))

    return (fns, hashes)
    
