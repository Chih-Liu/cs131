#!/bin/bash

read -p "Enter the URL of a CSV or ZIP dataset: " url

#Download the file
filename=$(basename "$url")
wget -O "$filename" "$url"

#Unzip the file if needed
if [[ "$filename" == *.zip ]]; then
	unzip -o "$filename"
	csv_file=$(find . -name "*.csv" | head -1)
	if [ -z "$csv_file" ]; then
	    echo "No CSV file found in the zip archive."
	    exit 1
	fi
else
	csv_file="$filename"
fi

#Check if CSV file exists
if [[ ! -f "$csv_file" ]]; then
	echo "CSV file not found: $csv_file"
	exit 1
fi

#Display column headers
echo ""
echo "Columns in $csv_file:"
head -n 1 "$csv_file" | tr ',' '\n' | nl

#Get user inputs: column index numbers
read -p "Enter column indices for numerical features(comma separated): " columns
IFS=',' read -ra col_indices <<< "$columns"

#Generate summary.md
output="summary.md"
echo "# Feature Summary for $(basename "$csv_file")" > "$output"
echo -e "\n## Feature Index and Names" >> "$output"
head -n 1 "$csv_file" | tr ',' '\n' | nl >> "$output"

#Statistics
echo -e "\n## Statistics (Numerical Features)\n" >> "$output"
echo "| Index | Feature | Min | Max | Mean | StdDev |" >> "$output"
echo "|-------|-------------------|------|------|-------|--------|" >> "$output"

for idx in "${col_indices[@]}"; do
    col_name=$(head -n 1 "$csv_file" | tr ',' '\n' | sed -n "${idx}p")
    data=$(tail -n +2 "$csv_file" | cut -d',' -f"$idx")
    stats=$(echo "$data" | awk '
   	 BEGIN { min=1e9; max=-1e9; sum=0; sumsq=0; n=0 }
   	 {
        	x = $1 + 0
       		if (x < min) min = x
        	if (x > max) max = x
        	sum += x
        	sumsq += x * x
        	n++
    	}
    	END {
        	mean = sum / n
        	stddev = sqrt((sumsq - sum * sum / n) / n)
        	printf "%.2f | %.2f | %.3f | %.3f\n", min, max, mean, stddev
    	}')

    echo "| $idx | $col_name | $stats |" >> "$output"
done

