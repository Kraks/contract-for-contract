from bench import Bench
from typing import List, Tuple

def create(bench: Bench, accounts: List[str]) -> str:
    return bench.call_contract_function(accounts[0], 'constructor', [])

token = None

def prepare(bench: Bench, accounts: List[str], contract_address: str) -> List[str]:
    hashes = []

    bench1 = Bench('/tmp/anvil.ipc', '../contracts/ERC20_BEC.sol', 'BecToken', False)
    tx = bench1.call_contract_function(accounts[9], 'constructor', [])
    receipt = bench1.wait_for_result(tx)
    global token
    token = receipt.contractAddress

    return hashes

def run(bench: Bench, accounts: List[str], contract_address: str) -> Tuple[List[str], List[str]]:
    fns = []
    hashes = []

    fns.append('createIssue')
    hashes.append(bench.call_contract_function(accounts[0], 'createIssue', [0, token, [0, 1], accounts[1:4], "issue0"], contract_addr=contract_address))

    # fns.append('setStatus')
    # hashes.append(bench.call_contract_function(accounts[0], 'setStatus', [0, True], contract_addr=contract_address))
    #
    # fns.append('issueDescription')
    # hashes.append(bench.call_contract_function(accounts[0], 'issueDescription', [0], contract_addr=contract_address))
    #
    # fns.append('availableOptions')
    # hashes.append(bench.call_contract_function(accounts[0], 'availableOptions', [0], contract_addr=contract_address))
    #
    # fns.append('optionDescription')
    # hashes.append(bench.call_contract_function(accounts[0], 'optionDescription', [0, 0], contract_addr=contract_address))

    fns.append('vote')
    hashes.append(bench.call_contract_function(accounts[1], 'vote', [0, 0], contract_addr=contract_address))

    # fns.append('vote')
    # hashes.append(bench.call_contract_function(accounts[2], 'vote', [0, 0], contract_addr=contract_address))
    #
    # fns.append('ballotOf')
    # hashes.append(bench.call_contract_function(accounts[0], 'ballotOf', [0, accounts[1]], contract_addr=contract_address))
    #
    # fns.append('weightOf')
    # hashes.append(bench.call_contract_function(accounts[0], 'weightOf', [0, accounts[1]], contract_addr=contract_address))
    #
    # fns.append('getStatus')
    # hashes.append(bench.call_contract_function(accounts[0], 'getStatus', [0], contract_addr=contract_address))
    #
    # fns.append('weightedVoteCountsOf')
    # hashes.append(bench.call_contract_function(accounts[0], 'weightedVoteCountsOf', [0, 0], contract_addr=contract_address))
    #
    # fns.append('winningOption')
    # hashes.append(bench.call_contract_function(accounts[0], 'winningOption', [0], contract_addr=contract_address))

    return (fns, hashes)
    
