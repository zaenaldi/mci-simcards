#!/bin/bash

BASE_URL="https://shop.mci.ir/api/search/v1/products"
CATEGORY=3
KEYWORD="09112**"
SORT="PRICE_ASC"
SIZE=16
OUTDIR="data"

mkdir -p "$OUTDIR"

COOKIES='cookiesession1=678B79572CBF79D39E2854D4C77B72C6; _ga=GA1.1.289075095.1759392575; _ga_7JBEGY19DS=GS2.1.s1759392574$o1$g1$t1759393865$j53$l0$h0'

for ((page=0; ; page++)); do
  echo "Fetching page $page..."

  RESPONSE=$(curl -s "$BASE_URL?category=$CATEGORY&keyword=$KEYWORD&page=$page&sortType=$SORT&size=$SIZE" \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Accept-Language: en-GB' \
    -H 'Cache-Control: no-cache' \
    -H 'Connection: keep-alive' \
    -H 'Content-Type: application/json' \
    -b "$COOKIES" \
    -H 'Pragma: no-cache' \
    -H "Referer: https://shop.mci.ir/products/$CATEGORY/%D8%B3%DB%8C%D9%85%E2%80%8C%DA%A9%D8%A7%D8%B1%D8%AA?page=$page&keyword=$KEYWORD&sortType=$SORT" \
    -H 'Sec-Fetch-Dest: empty' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36' \
    -H 'platform: WEB' \
    -H 'sec-ch-ua: "Chromium";v="140", "Not=A?Brand";v="24", "Google Chrome";v="140"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Windows"')

  HAS_DATA=$(echo "$RESPONSE" | grep -o '"data":[[]' | wc -l)

  if [[ $HAS_DATA -eq 0 ]]; then
    echo "❌ No more data, stopping."
    break
  fi

  echo "$RESPONSE" > "$OUTDIR/page_${page}.json"
  echo "✅ Saved $OUTDIR/page_${page}.json"

  sleep 1
done
