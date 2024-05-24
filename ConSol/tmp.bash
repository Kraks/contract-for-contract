#!/bin/bash

# Specify the output file for all diff results
output_file="tmp_solythesis_diff"

# Clear the output file or create it if it doesn't exist
> "$output_file"

# Loop over each file with the suffix _spec.sol
for file in ../eval-data/solythesis/contracts/*_spec.sol; do
    # Extract the filename without the suffix for later use
    fname="${file%_spec.sol}"

    # Run consol on the file
    # consol "$file"
    # rm "${fname}_spec_ast.json"


    
    # Output filename information to the output file
    echo "Diff results for $fname:" >> "$output_file"
    echo "--------------------------------" >> "$output_file"

    # Run diff and append the output to the file
    echo "diff "${fname}_spec_out.sol" "${fname}_spec_gt.sol" >> "$output_file"" >> "$output_file"
    diff "${fname}_spec_out.sol" "${fname}_spec_gt.sol" >> "$output_file"
    
    # Add a blank line for readability between entries
    echo -e "\n\n" >> "$output_file"
done

echo "All operations completed. Results are in $output_file."
