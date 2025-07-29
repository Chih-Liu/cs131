# datacollector.sh

## What this command does
This shell script automates the process of:
- Downloading a dataset from a given URL
- Unzipping the file (if zipped)
- Parsing the CSV file
- Asking the user to identify numerical columns
- Generating statistics (min, max, mean, stddev)
- Creating a `summary.md` file

## How to use this command
1. Clone the repository and enter the `a2` directory:

```bash
git clone <your GitHub repo URL>
cd cs131/a2

