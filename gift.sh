#!/bin/bash
# Usage:
#   bash gift.sh -U username -P 3        -> price only
#   bash gift.sh -U username -P 3 -C     -> price + create unpaid checkout link

AUTH="auth_token here"
CT0="ct0 here"

RECIPIENT=""; MONTHS="3"; CREATE=0
while getopts "U:P:C" opt; do
  case $opt in
    U) RECIPIENT="${OPTARG#@}" ;;
    P) MONTHS="$OPTARG" ;;
    C) CREATE=1 ;;
    *) echo "Usage: bash gift.sh -U username -P 3|6 [-C]"; exit 1 ;;
  esac
done
[ -z "$RECIPIENT" ] && { echo "Usage: bash gift.sh -U username -P 3|6 [-C]"; exit 1; }

case $MONTHS in
  3) PRODUCT="prod_TJXJtpzqCpI36N" ;;
  6) PRODUCT="prod_TJXKKNJwZJIhCM" ;;
  *) echo "-P must be 3 or 6"; exit 1 ;;
esac

BEARER="AAAAAAAAAAAAAAAAAAAAANRILgAAAAAAnNwIzUejRCOuH5E6I8xnZz4puTs%3D1Zv7ttfk8LF81IUq16cHjhLTvJu4FA33AGWWjCpTnA"
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36"
H=(-H "Authorization: Bearer $BEARER" -H "User-Agent: $UA" -H "Content-Type: application/json"
   -H "Origin: https://x.com" -H "Referer: https://x.com/$RECIPIENT/gift-premium"
   -H "X-Csrf-Token: $CT0" -H "Cookie: auth_token=$AUTH; ct0=$CT0"
   -H "X-Twitter-Auth-Type: OAuth2Session" -H "X-Twitter-Active-User: yes"
   -H "X-Twitter-Client-Language: en")
GQL="https://x.com/i/api/graphql"

# ---- 1. Eligibility + recipient ID ----
V="%7B%22screenName%22%3A%22${RECIPIENT}%22%7D"
R1=$(curl -s "$GQL/kn8hCE6bHstQV2MtfYDTKg/PremiumGiftingQuery?variables=$V" "${H[@]}")
REST_ID=$(echo "$R1" | grep -o '"rest_id":"[0-9]*"' | head -1 | grep -o '[0-9]\+')
ELIG=$(echo "$R1" | grep -o '"premium_gifting_eligible":[a-z]*' | cut -d: -f2)
echo "== Recipient =="
echo "User:      @$RECIPIENT"
echo "ID:        ${REST_ID:-not found}"
echo "Eligible:  ${ELIG:-unknown}"
[ -z "$REST_ID" ] && { echo "Raw: $R1"; exit 1; }

# ---- 2. Regional price (read-only) ----
V="%7B%22stripeId%22%3A%22${PRODUCT}%22%7D"
F="%7B%22subscriptions_marketing_page_fetch_promotions%22%3Atrue%7D"
R2=$(curl -s "$GQL/Se1Bp6zcNnuXYXRecV2qLA/useSubscriptionProductDetailsByRestIdQuery?variables=$V&features=$F" "${H[@]}")
MICRO=$(echo "$R2" | grep -o '"amount_local_micro":[0-9]*' | head -1 | cut -d: -f2)
CUR=$(echo "$R2" | grep -o '"currency_code":"[A-Za-z]*"' | head -1 | cut -d'"' -f4)
PTYPE=$(echo "$R2" | grep -o '"price_type":"[A-Za-z]*"' | head -1 | cut -d'"' -f4)
echo
echo "== Price ($MONTHS months) =="
if [ -n "$MICRO" ]; then
  echo "Amount:    $((MICRO / 1000000)) $CUR"
  echo "Type:      $PTYPE"
else
  echo "No price returned. Raw: $R2"; exit 1
fi

[ $CREATE -eq 0 ] && { echo; echo "(Price only. Add -C to create an unpaid checkout link.)"; exit 0; }

# ---- 3. Create UNPAID checkout link ----
[ "$ELIG" != "true" ] && { echo; echo "Recipient not eligible, skipping checkout."; exit 1; }
BODY=$(printf '{"queryId":"GqTVJ4S1526tLkxj69xIZw","variables":{"cancel_url":"https://x.com/%s/gift-premium","success_url":"https://x.com/%s/gift-premium/success","external_product_id":"%s","gift_recipient":"%s"}}' \
  "$RECIPIENT" "$RECIPIENT" "$PRODUCT" "$REST_ID")
R3=$(curl -s -X POST "$GQL/GqTVJ4S1526tLkxj69xIZw/useOneTimePurchaseGiftMutation" "${H[@]}" -d "$BODY")
SID=$(echo "$R3" | grep -o '"session_id":"[^"]*"' | cut -d'"' -f4)
SURL=$(echo "$R3" | grep -o '"session_url":"[^"]*"' | cut -d'"' -f4)
SST=$(echo "$R3" | grep -o '"session_status":"[^"]*"' | cut -d'"' -f4)
echo
echo "== Checkout =="
if [ -n "$SURL" ]; then
  echo "Status:    $SST"
  echo "Session:   $SID"
  echo "Link:      $SURL"
else
  echo "Failed. Raw: $R3"
fi
