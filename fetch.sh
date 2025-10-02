#!/bin/bash

BASE_URL="https://shop.mci.ir/api/search/v1/products"
CATEGORY=3
KEYWORD="09112%2A%2A"
SORT="PRICE_ASC"
SIZE=16
OUTDIR="data"

mkdir -p "$OUTDIR"

COOKIES='cookiesession1=678B79572CBF79D39E2854D4C77B72C6; _ga=GA1.1.289075095.1759392575; _ga_7JBEGY19DS=GS2.1.s1759393874$o1$g1$t1759393874$j44$l0$h0'

for ((page=0; ; page++)); do
  FILEPATH="$OUTDIR/page_${page}.json"

  if [[ -s "$FILEPATH" ]]; then
    echo "==============================="
    echo "📌 Page $page already exists and is non-empty. Skipping..."
    continue
  fi

  echo "==============================="
  echo "📌 Fetching page $page..."
  URL="$BASE_URL?category=$CATEGORY&keyword=$KEYWORD&page=$page&sortType=$SORT&size=$SIZE"
  echo "URL: $URL"

  RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}\n" "$URL" \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Accept-Language: en-GB' \
    -H 'Cache-Control: no-cache' \
    -H 'Connection: keep-alive' \
    -H 'Content-Type: application/json' \
    -b "$COOKIES" \
    -H "Referer: https://shop.mci.ir/products/$CATEGORY/?page=$page&keyword=$KEYWORD&sortType=$SORT" \
    -H 'Sec-Fetch-Dest: empty' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36' \
    -H 'platform: WEB' \
    -H 'sec-ch-ua: "Chromium";v="140", "Not=A?Brand";v="24", "Google Chrome";v="140"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "Windows"')

  HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE" | cut -d':' -f2)
  RESPONSE=$(echo "$RESPONSE" | sed '/HTTP_CODE/d')
  echo "HTTP Status: $HTTP_CODE"

  if [[ "$HTTP_CODE" -eq 200 ]]; then
    echo "$RESPONSE" > "$FILEPATH"
    echo "✅ Saved $FILEPATH"
  else
    echo "⚠️ Failed to fetch page $page, HTTP code $HTTP_CODE"
  fi

  sleep 1
done

echo "🎯 Finished scraping."
