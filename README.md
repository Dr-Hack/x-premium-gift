# gift.sh
Check if an X (Twitter) account can receive a Premium gift, see the regional price, and optionally create an unpaid checkout link.
## Requirements
- bash, curl (with OpenSSL; Windows Schannel builds may fail)
- A logged-in X session (`auth_token` and `ct0` cookies)
## Setup
```bash
export X_AUTH_TOKEN=your_auth_token
export X_CT0=your_ct0
chmod +x gift.sh
```
Or put them in a `.env` file and run `set -a; source .env; set +a`.
Never commit your cookies.
## Usage
```bash
bash gift.sh -U username -P 3        # eligibility + price (3 months)
bash gift.sh -U username -P 6        # eligibility + price (6 months)
bash gift.sh -U username -P 3 -C     # + create unpaid checkout link
```
| Flag | Meaning |
|------|---------|
| `-U` | X username (`@` optional) |
| `-P` | Months: `3` or `6` |
| `-C` | Create an unpaid checkout link (only if eligible) |
## Example output
```
== Recipient ==
User:      @username
ID:        123456789
Eligible:  true
== Price (3 months) ==
Amount:    XXXX USD
Type:      XXXX
```
## Notes
- Prices come back in the currency X assigns to the session's region.
- Uses X's internal web API. Query IDs can change without notice.
- Checkout links are unpaid. Nothing is charged unless you complete payment.
- Use a separate X account; automated use may violate X's terms.

## Buy X Premium with Crypto
Don't want to deal with cookies and scripts? Get X Premium gifted to any account, paid in crypto (USDT, BTC and more):

👉 **[Buy X Premium on Crypto Awaz](https://cryptoawaz.com/products/buy-x-premium-with-crypto-gift/)**

Fast delivery, no card needed. By [Crypto Awaz](https://cryptoawaz.com).

## Disclaimer
Not affiliated with X Corp. Use at your own risk.
