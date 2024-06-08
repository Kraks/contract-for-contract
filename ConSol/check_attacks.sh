#!/bin/bash

# Loop through each folder under ../eval-data/hacks
for f in ../eval-data/hacks/*; do
    if [ -d "$f" ]; then
        cd $f/contract
        contract=`basename $f`
        # Create the output file
        output_file="$contract.diff"
        > "$output_file"

        # Remove previous result
        if test -f flattened_out.sol; then
          rm "flattened_out.sol"
        fi

        # Run the consol command
        bash run.sh

        # Remove the JSON file
        rm "flattened_ast.json"

        # Specify which file you are diffing
        echo "Diffing files in folder: $f" >> "$output_file"

        if ! test -f flattened_out.sol; then
          echo "$f/contract/flattened_out.sol does not exists!"
          exit
        fi

        # Diff the files and append the result to the output file
        diff "flattened_out.sol" "flattened_gt.sol" >> "$output_file"

        # Append new lines for readability
        echo -e "\n\n" >> "$output_file"

        cd ../../../../ConSol
    fi
done
