#!/bin/bash

# Loop through each folder under ../eval-data/hacks
for f in ../eval-data/hacks/*; do
    if [ -d "$f" ]; then
        # Create the output file
        output_file="$f.diff"
        > "$output_file"

        # Run the consol command
        consol "$f/contract/flattened.sol"

        # Remove the JSON file
        rm "$f/contract/flattened_ast.json"

        # Specify which file you are diffing
        echo "Diffing files in folder: $f" >> "$output_file"

        if ! test -f $f/contract/flattened_out.sol; then
          echo "$f/contract/flattened_out.sol does not exists!"
          exit
        fi

        # Diff the files and append the result to the output file
        diff "$f/contract/flattened_out.sol" "$f/contract/flattened_gt.sol" >> "$output_file"

        # Append new lines for readability
        echo -e "\n\n" >> "$output_file"
    fi
done

# error:
# ../eval-data/hacks/lack-of-validation-Miner-466K/contract/flattened.sol
# doesn't compile on remix: ../eval-data/hacks/read-only-reentrancy-sturdy-800K/contract/flattened.sol
