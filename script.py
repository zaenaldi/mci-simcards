import os
import json
import httpx


class MCIProductScraper:
    BASE_URL = "https://shop.mci.ir/api/search/v1/products"

    def __init__(self, category=3, keyword="09112**", sort="PRICE_ASC", size=16, outdir="data"):
        self.category = category
        self.keyword = keyword
        self.sort = sort
        self.size = size
        self.outdir = outdir
        os.makedirs(outdir, exist_ok=True)

        self.client = httpx.Client(
            verify=False,  # ignore SSL
            http2=False,   # force HTTP/1.1 (many servers break on HTTP/2)
            headers={
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                              "AppleWebKit/537.36 (KHTML, like Gecko) "
                              "Chrome/120.0.0.0 Safari/537.36",
                "Accept": "application/json, text/plain, */*",
                "Accept-Language": "en-US,en;q=0.9",
                "Connection": "keep-alive",
            }
        )

    def fetch_page(self, page: int) -> dict:
        url = (
            f"{self.BASE_URL}"
            f"?category={self.category}"
            f"&keyword={self.keyword}"
            f"&page={page}"
            f"&sortType={self.sort}"
            f"&size={self.size}"
        )
        try:
            resp = self.client.get(url, timeout=20)
            resp.raise_for_status()
            return resp.json()
        except Exception as e:
            print(f"⚠️ Failed fetching page {page}: {e}")
            return {}

    def save_json(self, data: dict, page: int):
        filepath = os.path.join(self.outdir, f"page_{page}.json")
        with open(filepath, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"✅ Saved: {filepath}")

    def run(self, max_pages=100):
        for page in range(0, max_pages):
            print(f"Fetching page {page}...")
            data = self.fetch_page(page)
            if not data or not data.get("data"):
                print("No more data, stopping.")
                break
            self.save_json(data, page)


if __name__ == "__main__":
    scraper = MCIProductScraper()
    scraper.run(max_pages=50)
