#! /usr/bin/env zsh

secrets=("leo123leo456" "leo123leo987" "leo987leo654")

for secret in $secrets; do
    address=$(cat $secret | jq '.address')
    echo $address
    # call jsonrpc:
    # method: anvil_setBalance
    # params: address, balance
    curl -H "Content-Type: application/json" -X POST -d '{"jsonrpc":"2.0","method":"anvil_setBalance","params":['$address', "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"],"id":1}' http://localhost:$1
done
