from bench import Bench
from typing import List, Tuple

def create(bench: Bench, accounts: List[str]) -> str:
    return bench.call_contract_function(accounts[0], 'constructor', ["Clover", "CLV"])

new_token = None

def prepare(bench: Bench, accounts: List[str], contract_address: str) -> List[str]:
    return [] 

def run(bench: Bench, accounts: List[str], contract_address: str) -> Tuple[List[str], List[str]]:
    fns = []
    hashes = []

    fns.append('mint')
    hashes.append(bench.call_contract_function(accounts[0], 'mint', [accounts[0], 2], contract_addr=contract_address))

    fns.append('transfer')
    hashes.append(bench.call_contract_function(accounts[0], 'transfer', [accounts[1], 2], contract_addr=contract_address))

    return (fns, hashes)
    

