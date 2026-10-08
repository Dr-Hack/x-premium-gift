# x-premium-gift
Check if an X (Twitter) account can receive a Premium gift, see the regional price, and optionally create an unpaid checkout link.
## Installation
### Linux (Ubuntu, Debian, AlmaLinux, CentOS)
bash and curl are usually preinstalled. If not:
```bash
# Ubuntu / Debian
sudo apt install -y curl
# AlmaLinux / CentOS / RHEL
sudo dnf install -y curl
```
Then:
```bash
git clone https://github.com/Dr-Hack/x-premium-gift.git
cd x-premium-gift
chmod +x gift.sh
sed -i 's/\r$//' gift.sh     # fixes "syntax error" if edited on Windows
nano gift.sh                 # paste your cookies on lines 6-7 (see "Adding your cookies")
bash gift.sh -U username -P 3
```
### Windows
1. Install [Git for Windows](https://git-scm.com/download/win), which includes Git Bash.
2. Git Bash's built-in curl uses Windows SSL (Schannel), which fails against X on older Windows versions with `SEC_E_ILLEGAL_MESSAGE`. Check:
   ```bash
   curl -sS -o /dev/null -w "HTTP %{http_code}\n" https://x.com
   ```
   If you get `HTTP 000` with an SSL error, download the official build from [curl for Windows](https://curl.se/windows/), extract it to `C:\curl`, and add this as line 2 of `gift.sh`:
   ```bash
   curl() { /c/curl/bin/curl.exe "$@"; }
   ```
3. Open **Git Bash** (not cmd or PowerShell) and run:
   ```bash
   git clone https://github.com/Dr-Hack/x-premium-gift.git
   cd x-premium-gift
   notepad gift.sh             # paste your cookies on lines 6-7, save
   bash gift.sh -U username -P 3
   ```
### Adding your cookies
1. Log in to [x.com](https://x.com) in your browser.
2. Press `F12`, go to **Application**, then **Cookies**, then `https://x.com`.
3. Copy the values of `auth_token` (40 characters) and `ct0` (160 characters).
4. Open `gift.sh` and replace the placeholders on lines 6-7:
   ```bash
   AUTH="auth_token here"   # -> your auth_token value
   CT0="ct0 here"           # -> your ct0 value
   ```
Use a separate X account. Never share your edited `gift.sh` or push it back to GitHub with real values in it.
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
Amount:    XXXX BDT
Type:      XXXX
```
## Notes
- Prices come back in the currency X assigns to the session's region.
- Uses X's internal web API. Query IDs can change without notice.
- Checkout links are unpaid. Nothing is charged unless you complete payment.
- Use a separate X account; automated use may violate X's terms.
## Disclaimer
Not affiliated with X Corp. Use at your own risk.
## Buy X Premium with Crypto
Don't want to deal with cookies and scripts? Get X Premium gifted to any account, paid in crypto (USDT, BTC and more):
👉 **[Buy X Premium on Crypto Awaz](https://cryptoawaz.com/products/buy-x-premium-with-crypto-gift/)**
Fast delivery, no card needed. By [Crypto Awaz](https://cryptoawaz.com).
