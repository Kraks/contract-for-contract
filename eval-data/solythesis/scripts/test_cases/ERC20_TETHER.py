from bench import Bench
from typing import List, Tuple

def create(bench: Bench, accounts: List[str]) -> str:
    return bench.call_contract_function(accounts[0], 'constructor', [100000000000, "Tether USD", "USDT", 6])

new_token = None

def prepare(bench: Bench, accounts: List[str], contract_address: str) -> List[str]:
    bench1 = Bench('/tmp/anvil.ipc', '../contracts/ERC20_TETHER.sol', 'TetherToken', False)
    tx = bench.call_contract_function(accounts[0], 'constructor', [10000000000000000000, "Tether USD", "USDT", 6])
    receipt = bench1.wait_for_result(tx)
    global new_token
    new_token = receipt.contractAddress
    return [] 

def run(bench: Bench, accounts: List[str], contract_address: str) -> Tuple[List[str], List[str]]:
    fns = []
    hashes = []

    # fns.append('pause')
    # hashes.append(bench.call_contract_function(accounts[0], 'pause', [], contract_addr=contract_address))
    #
    # fns.append('unpause')
    # hashes.append(bench.call_contract_function(accounts[0], 'unpause', [], contract_addr=contract_address))
    #
    # fns.append('getOwner')
    # hashes.append(bench.call_contract_function(accounts[0], 'getOwner', [], contract_addr=contract_address))
    #
    # fns.append('getBlackListStatus')
    # hashes.append(bench.call_contract_function(accounts[0], 'getBlackListStatus', [accounts[0]], contract_addr=contract_address))
    #
    # fns.append('addBlackList')
    # hashes.append(bench.call_contract_function(accounts[0], 'addBlackList', [accounts[1]], contract_addr=contract_address))
    #
    # fns.append('destroyBlackFunds')
    # hashes.append(bench.call_contract_function(accounts[0], 'destroyBlackFunds', [accounts[1]], contract_addr=contract_address))
    #
    # fns.append('removeBlackList')
    # hashes.append(bench.call_contract_function(accounts[0], 'removeBlackList', [accounts[0]], contract_addr=contract_address))
    #
    # fns.append('issue')
    # hashes.append(bench.call_contract_function(accounts[0], 'issue', [100000000000], contract_addr=contract_address))
    #
    # fns.append('redeem')
    # hashes.append(bench.call_contract_function(accounts[0], 'redeem', [100000000000], contract_addr=contract_address))
    #
    # fns.append('setParams')
    # hashes.append(bench.call_contract_function(accounts[0], 'setParams', [10, 40], contract_addr=contract_address))

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
    # fns.append('transferOwnership')
    # hashes.append(bench.call_contract_function(accounts[0], 'transferOwnership', [accounts[0]], contract_addr=contract_address))
    #
    # fns.append('deprecate')
    # hashes.append(bench.call_contract_function(accounts[0], 'deprecate', [new_token], contract_addr=contract_address))

    return (fns, hashes)
    
