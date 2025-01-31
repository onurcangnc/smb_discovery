#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file.txt>"
    exit 1
fi

INPUT_FILE="$1"
OPTS="-A -S"  # Customize enum4linux-ng options here

# Function to convert CIDR to individual IPs
cidr_to_ips() {
    local cidr="$1"
    {
        IFS=/ read -r ip mask
        IFS=. read -r a b c d <<< "$ip"
        ip_int=$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))
        range=$((2 ** (32 - mask)))
        start=$((ip_int & (0xFFFFFFFF << (32 - mask))))
        end=$((start + range - 1))
        for ((i=start; i<=end; i++)); do
            printf "%d.%d.%d.%d\n" $((i >> 24)) $((i >> 16 & 255)) $((i >> 8 & 255)) $((i & 255))
        done
    } <<< "$cidr"
}

# Process each line in the input file
while IFS= read -r target; do
    # Skip empty lines and comments
    [[ -z "$target" || "$target" == \#* ]] && continue

    echo "Processing: $target"
    
    if [[ "$target" == */* ]]; then
        echo "Expanding subnet: $target"
        for ip in $(cidr_to_ips "$target"); do
            echo "Scanning $ip..."
            enum4linux-ng $OPTS "$ip"
        done
    else
        echo "Scanning $target..."
        enum4linux-ng $OPTS "$target"
    fi
done < "$INPUT_FILE"

echo "All targets processed."
