import os
import json
from openpyxl import Workbook

DATA_DIR = "data"
OUTPUT_FILE = "products.xlsx"

json_files = sorted([f for f in os.listdir(DATA_DIR) if f.endswith(".json")])

wb = Workbook()
ws = wb.active
ws.title = "Products"

header = [
    "id", "name", "productVariantId", "slug", "thumbnailUrl",
    "price", "priceWithTax", "discountPrice", "discountPercentage",
    "productStatus", "productType", "createdOn",
]
ws.append(header)

for file_name in json_files:
    file_path = os.path.join(DATA_DIR, file_name)
    
    # بررسی اینکه فایل خالی نیست
    if os.path.getsize(file_path) == 0:
        print(f"فایل خالی است و نادیده گرفته شد: {file_name}")
        continue

    with open(file_path, "r", encoding="utf-8") as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError:
            print(f"فایل JSON نامعتبر است و نادیده گرفته شد: {file_name}")
            continue
    
    for product in data.get("products", []):
        row = [
            product.get("id"),
            product.get("name"),
            product.get("productVariantId"),
            product.get("slug"),
            product.get("thumbnailUrl"),
            product.get("price"),
            product.get("priceWithTax"),
            product.get("discountPrice"),
            product.get("discountPercentage"),
            product.get("productStatus"),
            product.get("productType"),
            product.get("createdOn")
        ]
        
        attributes = product.get("attributes", [])
        for attr in attributes:
            value = "; ".join([v.get("displayText", "") for v in attr.get("attributeValueVms", [])])
            row.append(value)
        
        ws.append(row)

wb.save(OUTPUT_FILE)
print(f"Excel file saved as {OUTPUT_FILE}")
