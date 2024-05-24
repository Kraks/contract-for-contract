#!/bin/bash

# Create the output file
output_file="tmp_hack_diff"
> "$output_file"

# Loop through each folder under ../eval-data/hacks
for f in ../eval-data/hacks/*; do
    if [ -d "$f" ]; then
        # Run the consol command
        consol "$f/contract/flattened.sol"
        
        # Remove the JSON file
        rm "$f/contract/flattened_ast.json"
        
        # Specify which file you are diffing
        echo "Diffing files in folder: $f" >> "$output_file"
        
        # Diff the files and append the result to the output file
        diff "$f/contract/flattened_out.sol" "$f/contract/flattened_gt.sol" >> "$output_file"
        
        # Append new lines for readability
        echo -e "\n\n" >> "$output_file"
    fi
done


# error:
# ../eval-data/hacks/any-token-is-destroyed-TecraSpace-63k/contract/flattened.sol 
# ../eval-data/hacks/access-control-LEVUSDC-105K/contract/flattened.sol
# ../eval-data/hacks/lack-of-validation-Miner-466K/contract/flattened.sol
# doesn't compile on remix: ../eval-data/hacks/read-only-reentrancy-sturdy-800K/contract/flattened.sol
