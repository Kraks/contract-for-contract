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

    # fns.append('createBuilding')
    # hashes.append(bench.call_contract_function(accounts[0], 'createBuilding', [100, 100, 100, 100, 100, 100, 100, 100, accounts[0]], contract_addr=contract_address))
    
    fns.append('mint')
    hashes.append(bench.call_contract_function(accounts[0], 'mint', [accounts[0], 2], contract_addr=contract_address))
    
    fns.append('mint')
    hashes.append(bench.call_contract_function(accounts[0], 'mint', [accounts[0], 3], contract_addr=contract_address))
    #
    # fns.append('tokenURI')
    # hashes.append(bench.call_contract_function(accounts[0], 'tokenURI', [2], contract_addr=contract_address))
    #
    # fns.append('attributes')
    # hashes.append(bench.call_contract_function(accounts[0], 'attributes', [2], contract_addr=contract_address))
    #
    # fns.append('tokensOfOwner')
    # hashes.append(bench.call_contract_function(accounts[0], 'tokensOfOwner', [accounts[0]], contract_addr=contract_address))
    #
    # fns.append('burn')
    # hashes.append(bench.call_contract_function(accounts[0], 'burn', [2], contract_addr=contract_address))
    #
    # fns.append('updateTokenBaseURI')
    # hashes.append(bench.call_contract_function(accounts[0], 'updateTokenBaseURI', ['https://www.google.com'], contract_addr=contract_address))
    #
    # fns.append('symbol')
    # hashes.append(bench.call_contract_function(accounts[0], 'symbol', [], contract_addr=contract_address))
    #
    # fns.append('name')
    # hashes.append(bench.call_contract_function(accounts[0], 'name', [], contract_addr=contract_address))
    #
    # fns.append('tokenByIndex')
    # hashes.append(bench.call_contract_function(accounts[0], 'tokenByIndex', [0], contract_addr=contract_address))
    #
    # fns.append('totalSupply')
    # hashes.append(bench.call_contract_function(accounts[0], 'totalSupply', [], contract_addr=contract_address))
    #
    # fns.append('tokenOfOwnerByIndex')
    # hashes.append(bench.call_contract_function(accounts[0], 'tokenOfOwnerByIndex', [accounts[0], 1], contract_addr=contract_address))
    #
    # fns.append('safeTransferFrom')
    # hashes.append(bench.call_contract_function(accounts[0], 'safeTransferFrom', [accounts[0], accounts[1], 1], contract_addr=contract_address))

    fns.append('transferFrom')
    hashes.append(bench.call_contract_function(accounts[0], 'transferFrom', [accounts[0], accounts[1], 2], contract_addr=contract_address))

    # fns.append('approve')
    # hashes.append(bench.call_contract_function(accounts[0], 'approve', [accounts[1], 1], contract_addr=contract_address))
    #
    # fns.append('setApprovalForAll')
    # hashes.append(bench.call_contract_function(accounts[0], 'setApprovalForAll', [accounts[1], True], contract_addr=contract_address))
    #
    # fns.append('getApproved')
    # hashes.append(bench.call_contract_function(accounts[0], 'getApproved', [1], contract_addr=contract_address))
    #
    # fns.append('isApprovedForAll')
    # hashes.append(bench.call_contract_function(accounts[0], 'isApprovedForAll', [accounts[0], accounts[1]], contract_addr=contract_address))
    #
    # fns.append('ownerOf')
    # hashes.append(bench.call_contract_function(accounts[0], 'ownerOf', [1], contract_addr=contract_address))
    #
    # fns.append('balanceOf')
    # hashes.append(bench.call_contract_function(accounts[0], 'balanceOf', [accounts[0]], contract_addr=contract_address))
    #
    # fns.append('supportsInterface')
    # hashes.append(bench.call_contract_function(accounts[0], 'supportsInterface', ['0x80ac58cd'], contract_addr=contract_address))
    #
    # fns.append('isWhitelisted')
    # hashes.append(bench.call_contract_function(accounts[0], 'isWhitelisted', [accounts[0]], contract_addr=contract_address))
    #
    # fns.append('addWhitelisted')
    # hashes.append(bench.call_contract_function(accounts[0], 'addWhitelisted', [accounts[1]], contract_addr=contract_address))
    #
    # fns.append('removeWhitelisted')
    # hashes.append(bench.call_contract_function(accounts[0], 'removeWhitelisted', [accounts[1]], contract_addr=contract_address))
    #
    # fns.append('renounceWhitelisted')
    # hashes.append(bench.call_contract_function(accounts[0], 'renounceWhitelisted', [], contract_addr=contract_address))
    #
    # fns.append('isWhitelistAdmin')
    # hashes.append(bench.call_contract_function(accounts[0], 'isWhitelistAdmin', [accounts[0]], contract_addr=contract_address))
    #
    # fns.append('addWhitelistAdmin')
    # hashes.append(bench.call_contract_function(accounts[0], 'addWhitelistAdmin', [accounts[1]], contract_addr=contract_address))
    #
    # fns.append('renounceWhitelistAdmin')
    # hashes.append(bench.call_contract_function(accounts[0], 'renounceWhitelistAdmin', [], contract_addr=contract_address))

    return (fns, hashes)
    


