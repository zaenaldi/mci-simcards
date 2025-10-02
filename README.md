# MCI Simcards Data Scraper

A Bah and Python-based project to fetch, store, and convert MCI (Iran Mobile Communications) sim card product data into Excel format.

## Features

- Fetch product data from MCI API using `fetch.sh` (Bash script).
- Save each page of results as separate JSON files in the `data/` directory.
- Convert all JSON files into a single Excel file (`products.xlsx`) using `excel.py`.
- Automatically handles product attributes and appends them to the Excel file.

## Project Structure

```
mci-simcards/
├─ data/                  # Directory containing JSON files fetched from the API
├─ excel.py               # Python script to convert JSON files to Excel
├─ fetch.sh               # Bash script to fetch JSON pages from MCI API
├─ products.xlsx          # Generated Excel file with all products
├─ .gitignore
├─ LICENSE
└─ README.md
````

## Requirements

- Python 3.10+  
- `openpyxl` library (for Excel export)

Install dependencies using pip:

```bash
pip install openpyxl
````

## Usage

1. **Fetch data from MCI API**

   Run the fetch script to download product pages as JSON:

   ```bash
   bash fetch.sh
   ```

2. **Convert JSON data to Excel**

   Run the Python script:

   ```bash
   python excel.py
   ```

   Output will be saved as `products.xlsx`.

## Notes

* The Python script automatically ignores empty or invalid JSON files.
* Product attributes are concatenated with a `;` separator in the Excel sheet.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

Copyright 2025, Max Base
